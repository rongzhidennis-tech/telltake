# ADR-055: Keep rendered exports external by default

- Status: Proposed
- Date: 2026-08-27

## Context

Rendered MP4s can be large and are outputs rather than canonical project state. Including every export inside the `.easycut` package would make projects heavier and blur the distinction between editable state and deliverables.

## Decision

V1 writes completed MP4 exports as external files by default. The project stores export metadata and a reference to the output when available. The creator may explicitly include rendered outputs in `exports/` for durable backup or portability, but they are not required for project recovery.

## Consequences

- The `.easycut` package remains lightweight.
- Export references must be treated as stale when an external file is moved or deleted.
- Reopening a project does not require retaining prior rendered outputs.
- The creator can regenerate an export from canonical state and validated source clips.
