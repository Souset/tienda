---
name: add-or-update-firestore-rules-and-indexes
description: Workflow command scaffold for add-or-update-firestore-rules-and-indexes in tienda.
allowed_tools: ["Bash", "Read", "Write", "Grep", "Glob"]
---

# /add-or-update-firestore-rules-and-indexes

Use this workflow when working on **add-or-update-firestore-rules-and-indexes** in `tienda`.

## Goal

Adds or updates Firestore security rules and composite indexes, often with corresponding rule tests and sometimes scripts or deployment helpers.

## Common Files

- `cine_luz_del_mar/firebase/firestore.rules`
- `cine_luz_del_mar/firebase/firestore.indexes.json`
- `cine_luz_del_mar/firebase/rules-tests/*.mjs`
- `cine_luz_del_mar/server/api/instalar_indices.php`

## Suggested Sequence

1. Understand the current state and failure mode before editing.
2. Make the smallest coherent change that satisfies the workflow goal.
3. Run the most relevant verification for touched files.
4. Summarize what changed and what still needs review.

## Typical Commit Signals

- Edit firebase/firestore.rules
- Edit firebase/firestore.indexes.json
- Edit or add firebase/rules-tests/*.mjs for rule testing
- Update or add scripts/server for deploying indexes (e.g. instalar_indices.php)
- Run rule tests to verify

## Notes

- Treat this as a scaffold, not a hard-coded script.
- Update the command if the workflow evolves materially.