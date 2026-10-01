# ADR-051: Back up canonical state, not caches

- Status: Proposed
- Date: 2026-08-27

## Context

The `.easycut` package contains authoritative project state and derived artifacts with different recovery value. Caches can be large and regenerated, while the SQLite state preserves the transcript, analysis, cuts, and creator work.

## Decision

Durable project backup and copy semantics include:

- required: `manifest.json` and `state.sqlite`;
- optional: `exports/`, when the creator chooses to include rendered outputs; and
- excluded by default: `cache/`.

A project restored without `cache/` must open correctly and preserve all canonical state. Missing cache artifacts are regenerated lazily as needed and do not indicate project corruption.

Completed exports are external by default. `exports/` contains copies only when the creator explicitly chooses to include them; otherwise the project stores export metadata or references.

Future backup, migration, and sync systems must use the same boundary: canonical state is required, exports are optional, and caches are never required for recovery.

## Consequences

- Backup size and privacy exposure are reduced.
- Cache invalidation and regeneration are normal lifecycle behavior.
- The app must distinguish missing disposable artifacts from missing source media or corrupt canonical state.
- Recovery tests must open and inspect a cache-less package.
