# CLAUDE.md

Guidance for Claude Code (claude.ai/code) when working in this repository.

For repository workflow, branch protection, issue branch rules, CI, and
localization scope rules, also follow `AGENTS.md`. This file is the practical
day-to-day reference; `AGENTS.md` is the policy reference. When the two
disagree, `AGENTS.md` wins.

---

## 1. Project Overview

**Foodify Cooking** (Android label: *Milliy Taste*) — Flutter recipe app.

- **Flutter SDK**: `^3.11.4` (Dart). Material 3, multi-locale (`uz`, `en`, `ru`).
- **State management**: `flutter_bloc` (Cubit only — no Bloc events).
- **Routing**: `go_router` with `StatefulShellRoute.indexedStack` (5-tab shell).
- **DI**: `get_it` — manual wiring in `lib/core/di/injection_container.dart`.
- **Backend**: Supabase (`supabase_flutter`) for auth, DB, storage. Dio is
  retained for any non-Supabase HTTP.
- **Local storage**: `shared_preferences` wrapped by `StorageService` (allowlist).
- **Design baseline**: 360×800 logical pixels via `flutter_screenutil`
  (`.r`, `.w`, `.h`, `.sp`).
- **Assets**: `flutter_gen` produces `lib/core/gen/assets.gen.dart` and
  `lib/core/gen/fonts.gen.dart`.

### Feature list (each owns its full Clean Architecture stack)

`add_new`, `auth`, `home`, `onboarding`, `recipe`, `save`, `search`,
`settings`, `splash`.

---

## 2. Commands

```bash
# Run the app
flutter run

# Static analysis (MUST pass before push)
flutter analyze

# Tests (MUST pass before push)
flutter test

# Single test file
flutter test test/path/to/test_file.dart

# Regenerate localization after editing lib/l10n/*.arb
flutter gen-l10n

# Regenerate assets / fonts after adding new assets
dart run build_runner build --delete-conflicting-outputs

# Resolve dependencies
flutter pub get
```

After adding any image, SVG, or font asset, ALWAYS run `build_runner build` to
regenerate `lib/core/gen/assets.gen.dart` / `lib/core/gen/fonts.gen.dart`.
Reference via `Assets.*` and `FontFamily.*` — never raw string paths.

When a model field holds an `AssetGenImage`, the containing list must be
`final`, not `const` — `Assets.images.*` getters are not const-evaluable.

---

## 3. Git Workflow (read before every push)

### Branch model

```
prod        (production)        ← only from pre-prod
  ↑
pre-prod    (release candidate) ← only from dev
  ↑
dev         (integration)       ← all feature work merges here
  ↑
issue-N-... (feature branches)  ← created from dev
```

- `dev` is the default integration branch.
- `main` is **legacy** — do not branch from it, do not merge into it.
- All new work branches start from `dev`.
- `dev`, `pre-prod`, `prod` are protected: no direct push, no force push, no
  deletion. PR + 1 approval + green CI (`Flutter analyze and test`) required.

### Starting new work

```bash
# Always sync first
git switch dev
git pull origin dev

# Prefer GH issue linkage (auto-creates and checks out the branch)
gh issue develop <N> --base dev --name issue-<N>-<short-kebab> --checkout

# Manual fallback
git switch -c issue-<N>-<short-kebab> dev
```

Branch name pattern: `issue-<N>-<short-kebab>` (e.g. `issue-6-auth-flow`).
For bugfixes/localization with no issue, open a GitHub issue first.

### During work — commits

- Conventional, scoped commits. Subject ≤50 chars, imperative mood.
- Never mix generated/tooling noise into feature commits. Inspect
  `pubspec.lock` and `windows/flutter/generated_*` (line-ending churn)
  before staging.
- Stage explicitly (`git add <file>`) — avoid `git add -A` / `git add .` to
  prevent accidentally including `.env`, credentials, or noise.
- Never `--amend` after a hook failure (the commit didn't happen). Fix and
  create a NEW commit.
- Never `--no-verify` unless the user explicitly asks.
- Never push to `dev`, `pre-prod`, `prod` directly.

### Before pushing

1. `flutter analyze` — must be clean (or report known baseline failures
   honestly; do not hide them).
2. `flutter test` — must pass.
3. Review `git status` and `git diff --staged` once more.
4. Push: `git push -u origin <branch>`.

### Opening a PR

- Target = `dev` (for issue branches).
- Body MUST include `Closes #<issue-number>` so the issue auto-closes on merge.
- Keep PR title short (<70 chars). Details belong in the body.
- Body sections: `## Summary` (1-3 bullets), `## Test plan` (checklist).

### Release promotion (PR only — never push)

```
dev → pre-prod      (open PR, run CI, manually smoke test uz/en/ru)
pre-prod → prod     (only after pre-prod validation passes)
```

Initial CI on `pre-prod` / `prod` may fail until the first `dev → pre-prod`
promotion brings the newer passing snapshot forward.

### Destructive ops — confirm with user first

`git reset --hard`, `git push --force` (never to `dev`/`pre-prod`/`prod`),
`git clean -f`, branch deletion, force-deleting stashes. If a lock file or
unfamiliar files appear, investigate before deleting — they may be the user's
in-progress work.

---

## 4. Architecture

Clean Architecture with BLoC/Cubit. Per feature:

```
features/<name>/
  data/
    data_sources/   # Supabase (preferred) or Dio remote; StorageService local
    models/         # JSON DTOs with fromJson/toJson, extend domain entity
    repositories/   # Implements domain interface; converts DataState → Result
  domain/
    entities/       # Pure Dart, Equatable
    repositories/   # Abstract interfaces
    usecases/       # Single-responsibility; takes NoParams or a params record
  presentation/
    cubit/          # XxxCubit + XxxState (Equatable, status enum)
    pages/          # One BlocProvider per page, cubit via getIt<>()
    widgets/        # Private widgets extracted from pages when they grow
```

Shared UI → `lib/common/widgets/`. Config → `lib/config/`. Cross-cutting →
`lib/core/`. App shell + bootstrap → `lib/app/`.

### Bootstrap order (`lib/app/bootstrap.dart`)

1. `WidgetsFlutterBinding.ensureInitialized()`
2. `SupabaseService.initialize()` — must run BEFORE DI so `SupabaseClient`
   resolves.
3. `configureDependencies()` — registers everything.
4. `Bloc.observer = AppBlocObserver()`.
5. `runApp(App())`.

`App` then waits on `AppStartCubit` (gates UI behind a loader) and threads
`SettingsCubit` locale into `MaterialApp.router`. `AuthCubit` only mounts if
Supabase initialized AND the auth feature is enabled in DI.

### Dependency Injection

All registrations live in `lib/core/di/injection_container.dart`. Rules:

- **Repositories, services, single-instance state holders** →
  `registerLazySingleton`.
- **Cubits with data dependencies that should be per-screen** →
  `registerFactory`. Page calls `getIt<MyCubit>()` inside
  `BlocProvider.create`.
- **Cubits that survive across screens** (e.g. `AuthCubit`, `AppShellCubit`,
  `SavedRecipesCubit`, `SettingsCubit`) → `registerLazySingleton` and
  provided via `BlocProvider.value` at the appropriate scope.
- **Pure UI-only cubits with no deps** → instantiate inline:
  `create: (_) => MyCubit()`. Do not register in GetIt.

`configureDependencies({bool enableAuthFeature = true})` lets tests register
without auth wiring.

### Navigation (`lib/config/routes/app_router.dart`)

- `GoRouter` with `initialLocation = RouteNames.splash`.
- `StatefulShellRoute.indexedStack` with 5 branches:
  `home → search → addNew → save → profile`. Shell builder injects
  `AppShellCubit`, conditionally `AuthCubit`, `SavedRecipesCubit` via
  `MultiBlocProvider`, then renders `AppShellPage`.
- Outside the shell (top-level routes): `splash`, `onboarding`, `login`,
  `register`, `recipes`, `settings`.
- Route name constants → `lib/config/routes/route_names.dart`.
- **Deep link / OAuth callback**: scheme `foodify-cooking://login-callback`.
  Handled by `AuthCallbackRoute` in router `redirect`. Errors propagate to
  `AuthCubit.handleAuthCallbackFailure`. The intent-filter is declared in
  `android/app/src/main/AndroidManifest.xml`.

### Localization

- `flutter.generate: true` + `l10n.yaml`. Supported: `uz`, `en`, `ru`.
- **Default = Uzbek (`uz`) on first install.** Do NOT use device locale
  fallback for initial language.
- Sources: `lib/l10n/app_*.arb`. Generated: `lib/l10n/generated/`.
- After ARB edits → `flutter gen-l10n`.
- English ARB MUST include `@key` descriptions for every new entry.
- Access in widgets via `context.l10n` from `lib/l10n/l10n_extension.dart`.
- Locale source of truth = `SettingsCubit` (persisted via `StorageService`
  using `StorageKeys.languageCode`). Settings exposes only `uz`, `en`, `ru`.
- **Do NOT translate**: API/backend content, user input, recipe titles from
  data sources, chef names, hashtags, asset names, stable widget test keys.
- For locale-independent state values (e.g. Add New option chips), keep the
  stored value stable and localize only the displayed label.
- Update or add tests when localized text affects widget expectations.

### Design tokens

| Purpose | Value | Where |
|---|---|---|
| Primary blue (app bar, nav) | `#4058A0` | Inline |
| Accent orange (active nav dot) | `#FF6339` | Inline |
| Tertiary yellow (filter btn) | `#DEE21B` | Inline |
| Background tint | `#F6FBF4` | Inline |
| Dark background (media) | `#0E0E0E` | Inline |
| Dark surface / author card | `#353535` | Inline |
| Teal (next-action highlight) | `#05B5BF` | Inline |
| `AppColors.*` (Material palette) | Green-based | `lib/config/theme/app_colors.dart` |

`AppColors` defines the Material theme palette. Brand hex codes above are used
inline in components — they are **not** in `AppColors`.

### Key shared widgets

- `FoodifyAppBar` — three named ctors: `.home()`, `.searchFilter()`,
  `.titleAction()`. Always pass as `Scaffold.appBar`.
- `FoodifyPopularCard` — recipe card, 5 state variants; `LayoutBuilder` scales
  it from the 156×199 design baseline. `imagePath` is typed `Widget?` despite
  the name — pass a pre-built `Image`, e.g.
  `Assets.images.foodifyComponents.popularCardCake.image(fit: BoxFit.cover)`.
- `FoodifyButton` — 4 variants: `fill`, `accent`, `stroke`, `fillWhite`.
- `FoodifyBottomNavigationBar` — custom-painted curved nav; rendered only by
  `AppShellPage`. Tab index 2 (Add New) hides it (return `null` from
  `bottomNavigationBar` when `state.currentIndex == 2`).

### Network

- **Supabase first** for backend access. Data sources receive a
  `SupabaseClient Function()` thunk (not the client directly) so DI stays
  lazy and survives re-init.
- **Dio** still exists for non-Supabase HTTP. `DioFactory.create()` →
  `DioClient` wraps Dio with three interceptors in order: `LoggingInterceptor`,
  `AuthInterceptor` (Bearer from `TokenService`), `RetryInterceptor`.

### Data flow types — pick the right wrapper per layer

- `DataState<T>` (`lib/core/resource/data_state.dart`) — **data layer only**.
  Wraps `DioException`. Variants: `DataSuccess<T>(data)` / `DataFailed<T>(e)`.
- `Result<T>` (`lib/core/utils/result.dart`) — **domain + presentation**.
  Wraps `String message`. Variants: `Success<T>(data)` / `Failure<T>(message)`.
  Consume via `.fold(onFailure, onSuccess)`.

Repositories convert `DataState` → `Result`. Use cases and cubits only ever
see `Result`.

Use cases with no parameters take `NoParams` from
`lib/core/usecases/no_params.dart`.

### Cubit state pattern

```dart
enum XxxStatus { initial, loading, success, failure }

class XxxState extends Equatable {
  const XxxState({this.status = XxxStatus.initial, /* ... */});
  final XxxStatus status;
  // ...
  XxxState copyWith({XxxStatus? status, /* ... */}) =>
      XxxState(status: status ?? this.status, /* ... */);
  @override
  List<Object?> get props => [status, /* every field */];
}
```

Every field in `props`. Always `Equatable`. Status enum for async lifecycle.

### Multi-phase cubit pattern

For flows with distinct pre-form phases (photo picker → crop → multi-step
form), add a `phase` enum alongside `status`. The page widget switches on
`phase` to render entirely different screens. Reference impl:
`lib/features/add_new/presentation/`.

```dart
enum AddNewPhase { photoPicker, cropPhoto, formSteps }
// state holds both `phase` and `currentStep`
// page builder: switch(state.phase) { ... }
```

### Bottom nav suppression

```dart
bottomNavigationBar: state.currentIndex == 2
    ? null
    : FoodifyBottomNavigationBar(...)
```

---

## 5. Auth & Storage

### Storage

`StorageService` is the only `shared_preferences` wrapper allowed.
`StorageKeys` (`lib/core/constants/storage_keys.dart`) is the **closed**
allowlist:

```
auth_token, refresh_token, cached_user, language_code,
onboarding_completed, pending_auth_route
```

Anything written outside `StorageKeys.all` is rejected. To add a key:
1. Add the constant to `StorageKeys`.
2. Add it to `StorageKeys.all`.
3. Use it via `StorageService` only — never call `SharedPreferences` directly.

### Auth flow

- `AuthCubit` (lazySingleton) owns the global auth state. Subscribes to
  `AuthRepository.authStateChanges()` and exposes
  `AuthStatus { initial, loading, authenticated, unauthenticated, failure }`.
- Google Sign-In via Supabase OAuth → returns through deep link
  `foodify-cooking://login-callback` → `AppRouter.redirect` strips the
  callback and lands on `RouteNames.home`. Failures surface via the root
  `ScaffoldMessenger` (`AuthErrorL10n.messageFor`).
- `pendingAuthRoute`: when a guarded action triggers login, the target route
  is stashed in storage; on successful auth, the app navigates there and
  clears the key.
- All auth user-facing errors flow through `AuthFailureMessages` →
  `AuthErrorL10n` so they translate cleanly.
- Tests can disable the entire auth wiring by calling
  `configureDependencies(enableAuthFeature: false)`.

---

## 6. Testing

- Tests live under `test/` mirroring `lib/` structure.
- For widget tests of localized UI, wrap with `AppLocalizations`
  delegates and an explicit `Locale`.
- Prefer the Dart MCP test runner when available for Flutter test runs.
- If a branch has known baseline failures, surface them explicitly in the
  PR body — do not silently skip.
- When localized copy changes affect widget expectations, update tests.

---

## 7. File / Folder Conventions

- One `BlocProvider` per page, near the top of `build`.
- Private widgets stay in the same file until they grow > ~150 lines or are
  reused, then move to `presentation/widgets/`.
- Asset paths: never hardcode strings. Always `Assets.images.xxx.path` or
  `Assets.images.xxx.image(...)`.
- Use `.r` for radii/padding, `.w`/`.h` for sizes, `.sp` for text.
- Imports: package imports above relative imports, sorted by `dart format`.

---

## 8. Deprecated — Do Not Use

| Don't | Use instead |
|---|---|
| `lib/injection_container.dart` (root) | `lib/core/di/injection_container.dart` |
| `lib/core/resourse/` (typo folder) | `lib/core/resource/` |
| `lib/core/constants/asset_constants.dart` | `Assets.*` generated refs |
| `RouteGenerator` | `AppRouter.router` (GoRouter) |
| `main` branch for new work | `dev` |
| Device-locale fallback for first launch | Hardcoded `uz` default |

---

## 9. Completed / In-Progress Issues

- Issue `#1` — localization — DONE (merged via PR `#2`).
- Issue `#4` — responsive UI overflows — DONE (merged via PR `#5`).
- Issue `#6` — auth flow — IN PROGRESS on `issue-6-auth-flow`. PR target:
  `dev`.

For follow-up copy/language bugs after `#1`: open a NEW issue and a NEW
branch from `dev`. Do not reuse `issue-1-localization`.

---

## 10. Sub-Agent / Context Hygiene

- Use subagents (e.g. `Explore`, `general-purpose`) for broad research to
  preserve main context.
- Use `/compact` when context exceeds ~70%.
- Prefer dedicated tools (Read, Edit, Grep, Glob) over shell equivalents.
- Run independent tool calls in parallel.
