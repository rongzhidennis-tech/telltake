# ADR-047: Show the newest successful analysis by default

- Status: Proposed
- Date: 2026-08-27

## Context

Reanalysis can produce improved AI results as thresholds, prompts, and models change. Showing technical run history as the primary interface would burden creators, but discarding prior results would undermine reversibility.

## Decision

The newest successful analysis run becomes the default visible AI result. Prior runs remain accessible through a lightweight Previous analysis history for comparison or recovery. Creators are not required to manage run identifiers or configuration versions during ordinary editing.

The default switch changes presentation only; it does not rewrite any AI baseline or Creator Cut.

## Consequences

- The common workflow always opens on the most recent usable AI result.
- Technical analysis history remains available without becoming a primary editing concept.
- The UI must clearly identify when a Creator Cut belongs to an earlier run.
