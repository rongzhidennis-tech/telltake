# ADR-069: Keep AI analysis outputs immutable per run

- Status: Proposed
- Date: 2026-08-27

## Context

AI analysis produces take groups, progression assessments, confidence, candidate suggestions, and recommendations. Creators may accept, reject, or alter these findings. Mutating the analysis output in place would erase what the model originally decided and make evaluation or reanalysis comparisons unreliable.

## Decision

All AI analysis outputs are immutable and scoped to one analysis run. This includes:

- take-group candidates and membership;
- selected-take recommendation;
- semantic similarity and progression evidence;
- confidence and decision classification;
- Possible alternatives suggestions; and
- AI Clean Cut and AI Story Cut proposals.

Unaccepted recommendations remain persisted as part of the immutable run output. Creator review status is stored separately.

Creator actions are recorded separately as Creator Cut edit operations and resolved cut-plan updates. They do not mutate the source analysis output.

## Consequences

- The database can reproduce and audit each AI result.
- Accepted, rejected, and modified recommendations remain distinguishable from original model output.
- New analysis runs can be compared without conflating model changes with creator edits.
- The UI must present analysis findings and Creator Cut state as related but distinct layers.
