# ADR-050: Make SQLite the canonical project-state store

- Status: Proposed
- Date: 2026-08-27

## Context

The project contains relational, progressively updated state: an ordered clip set, transcript utterances and word alignment, take groups, versioned analysis runs, cut variants, creator decisions, provenance, and resumable processing status. A collection of canonical JSON documents would make multi-entity updates and recovery harder.

## Decision

Inside the `.easycut` package:

- `state.sqlite` is the canonical editable project state;
- `manifest.json` is lightweight package identity and compatibility metadata only;
- `cache/` contains disposable regenerable artifacts; and
- `exports/` contains rendered outputs or export references, never canonical edit state.

SQLite updates are transactional. The schema uses explicit version numbers and migration code. Relational integrity connects clips, utterances, take groups, analysis runs, cut variants, creator decisions, processing stages, and rendering plans.

## Consequences

- Partial stage updates can be committed safely without rewriting a large project document.
- Reopen and recovery behavior can query durable state directly.
- The same logical schema can be reused by macOS and later iPhone clients.
- JSON remains useful for the manifest and cloud/API exchange, but is not the source of truth for the editing graph.
- Cut variants persist resolved ordered source ranges alongside their edit provenance so preview/export can read a direct cut plan.
- SQLite migration tests are part of the portable-core acceptance criteria.
