---
name: add-new-feature-module
description: Workflow command scaffold for add-new-feature-module in tienda.
allowed_tools: ["Bash", "Read", "Write", "Grep", "Glob"]
---

# /add-new-feature-module

Use this workflow when working on **add-new-feature-module** in `tienda`.

## Goal

Adds a new feature or domain module (e.g. Agenda, News, Films, Library, Community, etc) with repository, domain, presentation layers, providers, screens, widgets, and tests.

## Common Files

- `cine_luz_del_mar/app/lib/features/*/data/repositories/*.dart`
- `cine_luz_del_mar/app/lib/features/*/domain/repositories/*.dart`
- `cine_luz_del_mar/app/lib/features/*/presentation/providers/*.dart`
- `cine_luz_del_mar/app/lib/features/*/presentation/screens/*.dart`
- `cine_luz_del_mar/app/lib/features/*/presentation/widgets/*.dart`
- `cine_luz_del_mar/app/lib/core/router/app_router.dart`

## Suggested Sequence

1. Understand the current state and failure mode before editing.
2. Make the smallest coherent change that satisfies the workflow goal.
3. Run the most relevant verification for touched files.
4. Summarize what changed and what still needs review.

## Typical Commit Signals

- Create data/repositories/feature_repository_impl.dart
- Create domain/repositories/feature_repository.dart
- Create presentation/providers/feature_providers.dart
- Create presentation/screens/feature_screen.dart (and detail screens if needed)
- Create presentation/widgets/ as needed

## Notes

- Treat this as a scaffold, not a hard-coded script.
- Update the command if the workflow evolves materially.