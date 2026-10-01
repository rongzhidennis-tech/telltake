# ADR-038: Surface uncertain repeats as non-applied suggestions

- Status: Proposed
- Date: 2026-08-18

## Context

Some semantically similar utterances may plausibly be alternative takes even when the system cannot confidently establish that no meaningful story progression occurred between them. Automatically grouping them would risk collapsing callbacks, summaries, or clarifications into a false take group.

## Decision

When alternative-take evidence exists but the no-progression condition is uncertain:

- keep both utterances fully included and separate in the AI Clean Cut;
- do not automatically select or exclude either utterance;
- optionally surface a non-applied **Possible alternatives** suggestion for creator review; and
- never let the suggestion modify the AI Clean Cut automatically.

Only high-confidence groups satisfying the progression boundary rule may become automatic take groups with a selected canonical row.

## Consequences

- The product preserves Clean Cut trust while still exposing useful model hypotheses.
- The UI needs a visual distinction between confirmed take groups and Possible alternatives suggestions.
- Accepting a Possible alternatives suggestion is an explicit creator action and should create or update the Creator Cut according to the normal cut-variant rules.
- Evaluation should track both missed confirmed groups and unsafe automatic groupings separately from suggestion usefulness.
