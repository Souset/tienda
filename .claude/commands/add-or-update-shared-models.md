---
name: add-or-update-shared-models
description: Workflow command scaffold for add-or-update-shared-models in tienda.
allowed_tools: ["Bash", "Read", "Write", "Grep", "Glob"]
---

# /add-or-update-shared-models

Use this workflow when working on **add-or-update-shared-models** in `tienda`.

## Goal

Adds or updates shared data models using Freezed, including .dart, .freezed.dart, .g.dart files, and updates the models.dart barrel file. Often includes round-trip tests.

## Common Files

- `cine_luz_del_mar/app/lib/shared/models/*.dart`
- `cine_luz_del_mar/app/lib/shared/models/*.freezed.dart`
- `cine_luz_del_mar/app/lib/shared/models/*.g.dart`
- `cine_luz_del_mar/app/lib/shared/models/models.dart`
- `cine_luz_del_mar/app/test/shared/models/*.dart`

## Suggested Sequence

1. Understand the current state and failure mode before editing.
2. Make the smallest coherent change that satisfies the workflow goal.
3. Run the most relevant verification for touched files.
4. Summarize what changed and what still needs review.

## Typical Commit Signals

- Create or update lib/shared/models/model.dart
- Generate model.freezed.dart and model.g.dart
- Update lib/shared/models/models.dart barrel
- Add or update tests for model serialization/deserialization

## Notes

- Treat this as a scaffold, not a hard-coded script.
- Update the command if the workflow evolves materially.