# ADR-064: Store edit operations as append-only provenance

- Status: Proposed
- Date: 2026-08-27

## Context

Cut variants need reliable reversal, comparison, creator-feedback capture, and future analysis. Updating or deleting a prior edit record would make it difficult to explain how a Creator Cut evolved.

## Decision

Creator and system edit operations are append-only records in SQLite. Each operation identifies its actor or source, target cut variant, affected utterance/take/context span or source range, prior state, resulting state, and timestamp/order.

The current resolved cut plan and the corresponding operation record are updated transactionally. Undo and redo use inverse or replayable operations rather than mutating or deleting history.

AI-generated baseline decisions are also retained as immutable provenance; creator overrides are appended separately.

## Consequences

- Reversal, audit, comparison, and future feedback analysis have a durable history.
- The database must distinguish active state from historical operations.
- Operation schemas need explicit versioning because they are part of the portable project format.
- The product can expose simple undo/redo without exposing event-sourcing concepts to creators.
- Undo history persists across reopen; redo is session-scoped and clears after a new edit, as defined in ADR-065.
