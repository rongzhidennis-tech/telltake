# ADR-027: Prefer the best coherent Story Cut when the target is unattainable

- Status: Proposed
- Date: 2026-08-18

## Context

Some recordings may not contain enough removable repetition or low-risk story-level material to reach the requested target range. Refusing to produce a Story Cut would discard useful assistance, while forcing the target could encourage aggressive or low-confidence removal.

## Decision

When the requested target range cannot be reached safely, the system generates the best coherent AI Story Cut it can. It shows the actual duration and explains that the result exceeds the requested range because more aggressive removals were not sufficiently supported. The creator can widen the range, inspect the available story suggestions, or continue from the result.

The AI Clean Cut remains available as the stable baseline.

## Consequences

- Duration is a guide, not a hard constraint that overrides confidence and story coherence.
- The Story Cut result needs a clear target-status explanation.
- Evaluation should reward safe, useful reductions even when exact range compliance is impossible.
