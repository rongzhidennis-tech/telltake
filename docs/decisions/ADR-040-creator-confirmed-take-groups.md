# ADR-040: Mark creator-confirmed take groups distinctly

- Status: Proposed
- Date: 2026-08-18

## Context

The creator may confirm a Possible alternatives suggestion. After confirmation, the group can use the compact canonical-row interaction, but the UI must preserve the distinction between an AI-created relationship and a creator-confirmed one.

## Decision

When the creator groups Possible alternatives, the transcript collapses the candidates into a canonical row while keeping the underlying takes expandable. The row is labeled as creator-confirmed, for example:

> Creator grouped alternatives · Show alternatives

The underlying alternatives remain source-ordered, individually playable, and reversible. The action creates or updates the Creator Cut and never modifies AI Clean Cut or AI Story Cut.

Creator confirmation requires an explicit preferred-take choice before the group is collapsed into the Creator Cut. Grouping alone must not cause the app to silently select a candidate.

## Consequences

- The compact review flow remains consistent after creator confirmation.
- Edit provenance is visible at the row level.
- The UI needs distinct states for AI-selected, creator-confirmed, and ungrouped Possible alternatives.
- The confirmation flow needs a clear “Choose this take” action for the preferred candidate.
