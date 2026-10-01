# ADR-065: Persist undo history and scope redo to the editing session

- Status: Proposed
- Date: 2026-08-27

## Context

Creator edits are durable project state and must remain reversible after closing and reopening. Redo is more sensitive to a new edit invalidating the forward path and need not become a permanent version-management concept.

## Decision

Persist append-only edit operations and enough prior/result state to restore undo history across project reopen. The creator can undo prior Creator Cut operations after reopening.

Redo is session-scoped. It is available while the current undo path remains valid and clears when the creator makes a new edit after undoing.

AI baseline generation and analysis-run history are immutable provenance, not ordinary user-visible undo steps.

## Consequences

- Reopenable projects preserve meaningful reversal capability.
- The UI can present ordinary undo/redo without exposing the full operation log.
- The database needs operation ordering, active/inactive status, and enough state to replay or invert creator edits.
- Creating a new analysis run does not destroy the undo history or baselines of prior Creator Cuts.
