# ADR-048: Do not merge analysis runs into Creator Cuts in v1

- Status: Proposed
- Date: 2026-08-27

## Context

New analysis runs may change transcript segmentation, take-group membership, recommendations, and cut boundaries. Automatically merging those changes into a Creator Cut would require conflict resolution and could silently alter creator work.

## Decision

V1 does not merge new analysis-run results into an existing Creator Cut. A new run may be previewed and compared, but creator work based on it starts as a separate Creator Cut tied to that run. Existing Creator Cuts remain unchanged and recoverable.

## Consequences

- Each Creator Cut has clear provenance to one analysis run and one AI starting point.
- The product avoids cross-run conflict resolution during the initial workflow.
- A future migration tool can be added after the edit model and run comparison behavior are proven.
