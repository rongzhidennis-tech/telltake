# ADR-041: Support multiple candidates per take group

- Status: Proposed
- Date: 2026-08-18

## Context

A creator may attempt the same thought three or more times before arriving at a preferred delivery. Limiting a group to two candidates would force the creator to compare and manage related attempts separately.

## Decision

V1 take groups support any practical number of candidates, including Take 1 through Take N. The canonical-row badge communicates the selected candidate and total count, and expansion shows all candidates in source order with individual playback.

AI-created groups may include multiple candidates only when the high-confidence grouping and progression rules are satisfied. Creator-confirmed groups may include candidates explicitly selected by the creator.

## Consequences

- The take-group data model is a set of ordered candidate utterances rather than a pairwise relationship.
- The UI needs scalable comparison behavior for groups larger than two.
- Take-selection evaluation should measure both group membership and preferred-candidate accuracy.
