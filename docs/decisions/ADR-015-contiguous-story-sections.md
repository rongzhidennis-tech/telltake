# ADR-015: Restrict v1 story removals to contiguous utterance ranges

- Status: Proposed
- Date: 2026-08-18

## Context

The AI Story Cut should be reviewable as a complete alternative while still exposing every removal. Combining unrelated, non-contiguous utterances into one proposed removal would make the narrative diff harder to understand and could resemble hidden restructuring.

## Decision

V1 story-level suggestions remove only contiguous ranges of transcript utterances. Each proposed removal maps to a continuous source-order range and can be previewed, restored, or overridden as a unit.

Non-contiguous combinations and reordering are outside the v1 story-suggestion model.

## Consequences

- Suggestions can be represented as clear spans in the transcript and predictable transitions in the video.
- The system can still suggest several separate contiguous removals within one AI Story Cut.
- More advanced restructuring can be added later without changing the meaning of a story section.
