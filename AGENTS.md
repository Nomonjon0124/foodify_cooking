# AGENTS.md

This file is the working guide for Codex and other coding agents in this repository.

## Git Workflow Rules

- The default integration branch is `dev`.
- `main` is legacy and must not be used for new work.
- Stable branch flow is always `dev -> pre-prod -> prod`.
- Feature, bugfix, and localization branches must start from `dev`.
- Issue branches must be created with GitHub issue linkage when possible:
  `gh issue develop <issue-number> --base dev --name issue-<issue-number>-<short-name> --checkout`.
- Pull requests for issue branches must target `dev`.
- PR bodies must include `Closes #<issue-number>` when the issue should close after merge to `dev`.
- Release promotion must use PRs only:
  `dev -> pre-prod`, then `pre-prod -> prod`.
- Do not push directly to `dev`, `pre-prod`, or `prod` unless explicitly bootstrapping repository infrastructure and the user asked for it.
- `prod` represents production-ready state. Only merge into it from `pre-prod`.

## Branch Protection Expectations

- `dev`, `pre-prod`, and `prod` are protected branches.
- Required check: `Flutter analyze and test`.
- Require at least 1 approving review.
- Dismiss stale reviews after new pushes.
- Require conversation resolution before merge.
- Force pushes and branch deletions are disabled.
- Admins are expected to follow the same protection rules.

## Validation Rules

- Before pushing code changes, run static analysis and tests:
  `flutter analyze` and `flutter test`.
- For Dart/Flutter tests, prefer the Dart MCP test runner when available.
- If a branch has known baseline failures, report them clearly and do not hide them.
- Do not mix generated/tooling noise into feature commits. Inspect `pubspec.lock` and platform generated files before committing if tools changed them.

## Current Repository State Notes

- `dev` contains the current working app snapshot and the Flutter CI workflow.
- `dev` also contains the completed localization work from PR `#2`.
- Issue `#1` (`Add app localization support`) is closed after merge to `dev`.
- `pre-prod` and `prod` were initialized from the old `main` baseline plus the CI workflow.
- Initial CI on `pre-prod` and `prod` can fail until the first `dev -> pre-prod` promotion brings the newer passing app snapshot forward.
- Local `windows/flutter/generated_*` files can appear modified from line-ending/tooling noise. Do not stage them unless their diff contains intentional plugin changes.

## Localization Rules

- Supported locales are Uzbek (`uz`), English (`en`), and Russian (`ru`).
- Default language is always Uzbek on first install. Do not use device locale as the default.
- Persist user language changes through `SettingsCubit` and `StorageService`.
- Source translations live in `lib/l10n/app_*.arb`; generated files live in `lib/l10n/generated/`.
- After changing ARB files, run `flutter gen-l10n`.
- English ARB entries must include descriptions for new keys.
- Use `context.l10n` in presentation widgets.
- Do not translate backend/API data, user-entered values, recipe titles from data sources, chef names, hashtags, asset names, or stable widget test keys.
- Keep Add New form state values locale-independent. Use localized label mapping in the UI for option chips and preview labels.
- Update or add tests when localized text affects widget expectations.

## Post-Issue Workflow After Localization

- After PR `#2` merge, continue new work from `dev`.
- Do not reuse `issue-1-localization`; it is complete and linked to closed issue `#1`.
- For follow-up localization bugs or copy changes, open a new GitHub issue and create a new issue branch from `dev`.
- Before starting new feature work:
  `git switch dev && git pull origin dev`.
- For release readiness, open a PR from `dev` to `pre-prod`, run CI, and manually smoke test Uzbek, English, and Russian language switching.
- Only promote `pre-prod` to `prod` after pre-prod validation passes.
