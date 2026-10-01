# ADR-024: Expose processing stages progressively

- Status: Proposed
- Date: 2026-08-18

## Context

The workflow contains distinct local and cloud stages that may complete at different times. Waiting for every stage before showing any result would make long processing feel opaque and would make recovery harder.

## Decision

V1 exposes stage-level progress and makes durable intermediate results available as they complete:

1. import complete;
2. audio extracted;
3. transcript available;
4. take groups analyzed;
5. AI Clean Cut ready; and
6. AI Story Cut ready.

The project persists stage status and outputs independently so interrupted work can resume or retry from the last durable stage.

Before the AI Clean Cut is ready, the transcript is inspectable but not editable. Creator-facing selection, take switching, restoration, and cut editing become available once the AI Clean Cut has been generated.

## Consequences

- The creator gets immediate visibility into whether the workflow is progressing.
- Transcript and analysis failures can be localized to a stage or region.
- The UI must clearly distinguish “available for review” from “analysis still in progress.”
- The final cut variants cannot be treated as all-or-nothing data.
- The UI needs a clear readiness gate so creators do not mistake an in-progress transcript for an editable cut.
