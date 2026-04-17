# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run the app
flutter run

# Analyze for lint errors
flutter analyze

# Run tests
flutter test

# Run a single test file
flutter test test/path/to/test_file.dart

# Regenerate assets/fonts after adding new files to assets/
dart run build_runner build --delete-conflicting-outputs

# Get dependencies
flutter pub get
```

After adding any new image, SVG, or font asset, always run `build_runner build` to regenerate `lib/core/gen/assets.gen.dart` and `lib/core/gen/fonts.gen.dart`. Reference assets via `Assets.*` and fonts via `FontFamily.*` — never use raw string paths.

When a model field holds an `AssetGenImage`, the list containing it must be `final`, not `const` — `Assets.images.xxx.yyy` getter properties are not const-evaluable.

## Architecture

Clean Architecture with BLoC/Cubit state management. The design baseline is **360×800** logical pixels using `flutter_screenutil` — always use `.r`, `.w`, `.h`, `.sp` suffixes for sizing.

### Layer structure (per feature)

```
features/<name>/
  data/
    data_sources/   # Remote (Dio) and local (StorageService) implementations
    models/         # JSON DTOs with fromJson/toJson
    repositories/   # Implements domain repository interface
  domain/
    entities/       # Pure Dart business models (Equatable)
    repositories/   # Abstract interfaces
    usecases/       # Single-responsibility use cases
  presentation/
    cubit/          # XxxCubit extends Cubit<XxxState>; XxxState extends Equatable
    pages/          # One BlocProvider per page, creates cubit via getIt<>()
    widgets/        # Private widgets extracted from pages when they grow large
```

Shared UI lives in `lib/common/widgets/`. Config (theme, routes) lives in `lib/config/`. DI wiring is manual in `lib/core/di/injection_container.dart` — no code generation.

### Dependency Injection

All dependencies are registered in `lib/core/di/injection_container.dart` using `GetIt`. Cubits that depend on use cases use `registerFactory`; repositories and services use `registerLazySingleton`. Call `getIt<MyCubit>()` inside `BlocProvider.create`.

Cubits with **no** data dependencies (e.g. UI-only state) are instantiated directly with `create: (_) => MyCubit()` — do not register them in GetIt.

### Navigation

`GoRouter` with a `StatefulShellRoute` for the 5-tab bottom navigation shell (Home → Search → Add New → Save → Profile). The shell wraps all branch routes inside `AppShellPage`, which renders `FoodifyBottomNavigationBar`. Individual feature routes outside the shell (login, register, recipe detail, settings) are top-level `GoRoute`s. Route name constants live in `lib/config/routes/route_names.dart`.

### Design tokens

| Purpose | Value | Where defined |
|---|---|---|
| Primary blue (app bar, nav) | `#4058A0` | Inline in components |
| Accent orange (active nav dot) | `#FF6339` | Inline in components |
| Tertiary yellow (filter btn) | `#DEE21B` | Inline in components |
| Background tint | `#F6FBF4` | Inline in components |
| `AppColors.*` | Green-based palette | `lib/config/theme/app_colors.dart` |

`AppColors` defines the Material theme palette. The brand UI colors (`#4058A0`, etc.) are used directly as constants inside individual widgets — they are not in `AppColors`.

### Key shared widgets

- `FoodifyAppBar` — three named constructors: `.home()`, `.searchFilter()`, `.titleAction()`. Always use as `Scaffold.appBar`.
- `FoodifyPopularCard` — recipe card with 5 state variants; uses `LayoutBuilder` to scale responsively from 156×199 design dimensions.
- `FoodifyButton` — four variants: `fill`, `accent`, `stroke`, `fillWhite`.
- `FoodifyBottomNavigationBar` — custom painted curved nav bar; rendered only by `AppShellPage`.

### Network

`DioClient` wraps `Dio` with three interceptors: `LoggingInterceptor`, `AuthInterceptor` (attaches Bearer token from `TokenService`), and `RetryInterceptor`. Data sources inject `DioClient` directly.

### Data flow types

Two distinct result wrappers — use the right one per layer:

- `DataState<T>` (`lib/core/resource/data_state.dart`) — data layer only. Wraps `DioException`. Variants: `DataSuccess<T>(data)` / `DataFailed<T>(dioException)`.
- `Result<T>` (`lib/core/utils/result.dart`) — domain/presentation layer. Wraps a `String message`. Variants: `Success<T>(data)` / `Failure<T>(message)`. Use `.fold(onFailure, onSuccess)` to consume.

Use cases with no parameters take `NoParams` from `lib/core/usecases/no_params.dart`.

### Cubit state pattern

States use a status enum (`initial / loading / success / failure`) + `copyWith`. Always extend `Equatable` and list all fields in `props`. Example shape:

```dart
enum XxxStatus { initial, loading, success, failure }

class XxxState extends Equatable {
  const XxxState({this.status = XxxStatus.initial, ...});
  final XxxStatus status;
  // ...
  XxxState copyWith({XxxStatus? status, ...}) => XxxState(status: status ?? this.status, ...);
  @override
  List<Object?> get props => [status, ...];
}
```

### Deprecated — do not use

- `lib/injection_container.dart` (root) — use `lib/core/di/injection_container.dart`
- `lib/core/resourse/` (typo folder) — use `lib/core/resource/`
- `lib/core/constants/asset_constants.dart` — use `Assets.*` generated references instead
- `RouteGenerator` — use `AppRouter.router` (GoRouter)

### Key shared widgets (additional notes)

`FoodifyPopularCard.imagePath` is typed as `Widget?` (despite the name) — pass a pre-built `Image` widget, e.g. `Assets.images.foodifyComponents.popularCardCake.image(fit: BoxFit.cover)`.
