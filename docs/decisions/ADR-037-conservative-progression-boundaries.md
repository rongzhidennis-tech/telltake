# ADR-037: Treat uncertain story progression as a group boundary

- Status: Proposed
- Date: 2026-08-18

## Context

Similar wording can recur intentionally after a creator has advanced the story. A later statement may be a callback, summary, clarification, or new version of the idea rather than a retry. Cross-file take detection must not collapse these cases merely because the transcript is semantically similar.

## Decision

For automatic alternative-take grouping, the system requires strong evidence that:

- the candidate utterances express the same intended thought;
- they are local in the creator-confirmed recording sequence; and
- intervening material does not contain meaningful story progression.

If the system is uncertain whether intervening material advances the story, it treats that material as a progression boundary and keeps the later utterance outside the automatic take group.

## Consequences

- Clean Cut precision is protected at the cost of missing some cross-file take groups.
- The detector must model the intervening span, not only compare the two candidate utterances.
- A later semantically similar statement remains independently editable unless stronger evidence supports grouping.
- When there is meaningful but insufficient evidence for an alternative relationship, the system may surface a non-applied Possible alternatives suggestion; it must not affect Clean Cut silently.
