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
- `pre-prod` and `prod` were initialized from the old `main` baseline plus the CI workflow.
- Initial CI on `pre-prod` and `prod` can fail until the first `dev -> pre-prod` promotion brings the newer passing app snapshot forward.
- Localization work is tracked by issue `#1` and branch `issue-1-localization`.

## Localization Issue Scope

- Initial locales: Uzbek (`uz`), English (`en`), Russian (`ru`).
- Add Flutter l10n generation and ARB files.
- Wire localization delegates and supported locales into the app.
- Add a Settings language selector.
- Replace user-facing hard-coded strings in prioritized app areas.
- Add tests for localization configuration and language switching.
