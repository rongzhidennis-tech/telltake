# ADR-039: Keep Possible alternatives separate until creator confirmation

- Status: Proposed
- Date: 2026-08-18

## Context

Possible alternatives are useful hypotheses, but their progression boundary is uncertain. Collapsing them would imply a confidence level the system does not have and could hide meaningful story content.

## Decision

Possible alternatives remain separate transcript rows in the main sequence. A visible relationship badge connects the rows without changing their inclusion state. Opening the badge provides an inline comparison with actions such as:

- Compare;
- Group as alternatives; and
- Ignore.

The rows are not collapsed, excluded, or automatically reselected unless the creator explicitly acts.

## Consequences

- Confirmed take groups and uncertain suggestions have distinct visual and behavioral states.
- The creator can understand and dismiss model hypotheses without losing source chronology.
- Accepting a suggestion is a normal creator edit with edit provenance. It creates or updates the Creator Cut from the currently chosen AI starting point, while preserving AI Clean Cut and AI Story Cut unchanged.
