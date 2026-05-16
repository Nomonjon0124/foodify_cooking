# Milliy Taste

Milliy Taste is a Flutter cooking app with Clean Architecture, Cubit/BLoC state
management, Supabase-backed data sources, custom Foodify UI components, and
three-language localization.

## Current State

- Default integration branch: `dev`.
- Localization issue `#1` was completed by PR `#2`.
- Supported locales: Uzbek (`uz`), English (`en`), Russian (`ru`).
- First install/default app language is always Uzbek. Device locale is not used
  for initial language selection.
- User language selection is persisted with `shared_preferences`.
- Current release flow remains `dev -> pre-prod -> prod`.

## Development Commands

```bash
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
flutter run
```

After adding image, SVG, or font assets, regenerate generated asset references:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Localization Workflow

- Source ARB files live in `lib/l10n/`.
- Generated localization files live in `lib/l10n/generated/`.
- Config lives in `l10n.yaml`.
- Add new user-facing copy to `app_en.arb` first, including a description.
- Add matching translations to `app_uz.arb` and `app_ru.arb`.
- Run `flutter gen-l10n` after ARB changes.
- Use `context.l10n` from `lib/l10n/l10n_extension.dart` in widgets.
- Keep internal values locale-independent; map them to localized labels in the UI.
- Do not translate backend content, user-entered text, recipe names from data
  sources, asset names, or stable test keys.

## Git Workflow

- New issue branches start from `dev`.
- PRs for issue branches target `dev` and include `Closes #<issue-number>` when
  the issue should close on merge.
- After an issue PR is merged to `dev`, verify the issue is closed and pull the
  latest `dev` locally.
- Promote only through PRs: `dev -> pre-prod`, then `pre-prod -> prod`.
- Keep generated platform/tooling noise out of commits unless it is intentional.

## After Localization Issue Closure

1. Work from updated `dev`: `git switch dev && git pull origin dev`.
2. Open new issues for remaining work instead of reusing the closed localization
   issue branch.
3. For release testing, open a `dev -> pre-prod` PR and run CI plus manual app
   smoke tests in all three languages.
4. Fix release-candidate conflicts or test failures before merging to
   `pre-prod`.
5. Open `pre-prod -> prod` only after pre-prod validation passes.
