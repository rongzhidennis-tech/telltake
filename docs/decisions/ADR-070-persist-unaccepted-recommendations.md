# ADR-070: Persist unaccepted AI recommendations

- Status: Proposed
- Date: 2026-08-27

## Context

Possible alternatives, rejected take recommendations, and story-level cut candidates remain useful for review, comparison, evaluation, and future feedback analysis even when the creator does not apply them to a cut.

## Decision

Persist all AI recommendations as immutable outputs of their analysis run, including recommendations that are not applied. Store creator review actions separately, such as accepted, rejected, ignored, or deferred, without mutating the original recommendation.

An Ignore action is scoped to the recommendation’s analysis run and does not automatically carry forward to a future run.

The project retains enough linkage to show which recommendations contributed to AI Clean Cut, AI Story Cut, or Creator Cut state.

## Consequences

- Recommendation history survives closing, reanalysis comparison, and project backup.
- The database distinguishes “AI did not recommend this,” “AI recommended this but creator rejected it,” and “creator has not reviewed it.”
- Review status can support future feedback analysis without treating it as ground truth automatically.
