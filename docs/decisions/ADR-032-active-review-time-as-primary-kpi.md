# ADR-032: Use active creator review time as the primary success metric

- Status: Proposed
- Date: 2026-08-18

## Context

The product goal is to reduce repetitive rough-cut labor from roughly 45–90 minutes to roughly 5–15 minutes. Cloud processing and local export may add wall-clock latency that does not represent creator effort.

## Decision

Track both:

1. **Primary metric — active creator review time:** the creator’s active time reviewing and adjusting usable AI results until the cut is ready to export. This includes selecting a starting cut, switching takes, restoring or removing utterances/story sections, and boundary adjustments. It excludes idle time, cloud processing latency, and local export time.
2. **Secondary metric — total wall-clock time:** elapsed time from import through processing, review, and export.

The v1 success target of 5–15 minutes refers primarily to active creator review time after the relevant AI results are available. Processing and export durations are tracked separately as system performance metrics.

The active review timer stops when the creator’s current cut is marked ready to export. Successful local MP4 export is tracked as a separate completion metric and does not retroactively change the review-time measurement.

## Consequences

- Usability experiments should log interaction time and stage timestamps separately.
- A fast AI result with a frustrating review flow will fail the primary metric even if total wall-clock time is low.
- A high-quality result that takes longer to process can still be valuable, but processing latency must remain visible and measurable.
- Export failures should be diagnosable and retryable without forcing the creator to repeat transcript review or AI analysis.
