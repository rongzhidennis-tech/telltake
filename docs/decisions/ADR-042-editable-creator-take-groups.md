# ADR-042: Let creators edit take-group membership

- Status: Proposed
- Date: 2026-08-18

## Context

AI grouping and creator-confirmed grouping may be imperfect. The creator needs to correct which utterances belong to a group without losing the underlying source candidates or changing AI baselines.

## Decision

Within a Creator Cut, the creator may add or remove individual take candidates from a confirmed group. Group membership changes are reversible Creator Cut edits with provenance.

Removing a candidate from a group does not delete or modify its source media. The candidate remains available as an independent transcript utterance or as a candidate for another creator action.

Removing a candidate from a group does not automatically restore it into the current cut. Group membership and cut inclusion remain separate decisions; the creator must explicitly restore the candidate if they want it included.

## Consequences

- Take groups are editable domain objects, not immutable AI classifications.
- The UI needs explicit group-membership controls and undo/restore behavior.
- The system must distinguish “removed from group” from “removed from current cut.”
- The UI should provide a direct restore-in-cut action for excluded candidates without requiring the creator to recreate the take-group relationship.
- Excluded candidates remain visible as dimmed transcript rows with direct restoration, consistent with ADR-043.
