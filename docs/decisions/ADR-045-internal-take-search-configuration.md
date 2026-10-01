# ADR-045: Keep take-search guardrails internal in v1

- Status: Proposed
- Date: 2026-08-27

## Context

Sequence-distance limits are useful for bounding candidate search and tuning precision, but exposing utterance, clip, or time limits would shift model configuration work onto creators and make the editing workflow harder to understand.

## Decision

V1 keeps sequence-distance guardrails and their initial values internal to the analysis configuration. The team may tune them against the development and held-out evaluation sets without exposing them as creator-facing settings.

Creators see the resulting take groups, Possible alternatives, and uncertainty states—not the search parameters used to generate them.

Any change to analysis configuration creates a new analysis run and does not silently rewrite an existing AI Clean Cut, AI Story Cut, or Creator Cut.

The project may present the newest successful run as the current AI result by default, but it must preserve prior runs and never replace creator work implicitly.

## Consequences

- Model tuning can evolve without adding configuration burden to the creator UI.
- Projects need to record the analysis configuration version used for their outputs.
- Reanalysis produces a new AI result that can be compared against preserved existing cuts.
- Creator work remains protected from silent algorithm changes.
