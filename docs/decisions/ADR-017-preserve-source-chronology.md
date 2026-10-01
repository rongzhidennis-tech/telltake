# ADR-017: Keep v1 edits in original chronological order

- Status: Proposed
- Date: 2026-08-18

## Context

The launch workflow is a chronological talking-head recording session that may contain multiple source clips. The product’s value comes from finding usable utterances and choosing among local retries, not from reconstructing the story in a new order.

## Decision

V1 Creator Cuts preserve the imported recording chronology across source clips. Creator-facing editing is limited to:

- keeping or removing utterances and contiguous story sections;
- switching among alternative takes in their source position; and
- making limited boundary adjustments within the existing sequence.

Transcript-driven reordering, non-chronological assembly, and rearrangement of story sections are out of scope for v1.

## Consequences

- The edit engine can represent a cut as an ordered subset of source ranges, simplifying preview and local rendering.
- Story-level removals produce gaps in the source chronology but never reorder the remaining content.
- Future restructuring features can build on the same source-range model without being required for launch.
