# ADR-062: Show curated non-speech context rows

- Status: Proposed
- Date: 2026-08-27

## Context

Showing every speechless gap would overwhelm an utterance-centric transcript, while hiding all speechless content would make meaningful visual pauses hard to review. The source model must preserve every span even when the UI does not represent each one as a row.

## Decision

V1 shows only a curated subset of non-speech context spans as transcript rows—primarily longer or otherwise review-worthy spans. Short ordinary gaps remain available through source timing and playback context but do not become first-class transcript rows.

The display criterion is separate from AI editability. A visible non-speech row remains preserved by default, may be manually removed by the creator, and is never automatically removed solely because it is speechless.

The exact display threshold is an internal, tuneable product parameter rather than a creator-facing setting.

## Consequences

- The transcript stays focused on utterances while retaining access to meaningful visual context.
- All source ranges remain represented in the underlying timeline/edit plan even when omitted from the transcript list.
- Display-threshold tuning must not change Clean Cut safety semantics.
