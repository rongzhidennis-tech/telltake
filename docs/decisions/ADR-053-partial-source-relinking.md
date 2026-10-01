# ADR-053: Allow partial inspection during source relinking

- Status: Proposed
- Date: 2026-08-27

## Context

A project may contain several source clips, and only some may be available after restore or transfer. Blocking all inspection until every clip is found would make recovery unnecessarily opaque, while exporting an incomplete sequence would be unsafe.

## Decision

When only some source clips are relinked:

- allow transcript and edit-decision inspection for the available portions;
- allow source playback only for ranges whose media is present and validated;
- identify missing ranges and clips clearly; and
- keep full-cut preview and MP4 export disabled until every source clip required by the selected cut is relinked and validated.

The app must never export a cut with silently missing or substituted source ranges.

## Consequences

- The project remains useful during an incomplete recovery.
- Preview needs range-level availability status.
- Export readiness depends on source completeness, not only on the presence of a valid SQLite project state.
