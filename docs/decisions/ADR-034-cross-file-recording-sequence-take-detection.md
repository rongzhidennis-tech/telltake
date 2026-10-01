# ADR-034: Define local take detection over the ordered recording sequence

- Status: Proposed
- Date: 2026-08-18

## Context

Creators may stop recording after a failed attempt and begin a new source clip for the retry. A single 20–30 minute session can therefore contain multiple files:

> Clip 1: partial attempt → Clip 2: revised attempt → Clip 3: complete attempt

These clips can be strong alternative-take candidates even though no fixed time window within one file connects them.

## Decision

V1 alternative-take detection operates over an ordered recording sequence made from multiple imported source clips. Recording-order locality is the primary locality signal, not a fixed time or single-file distance threshold.

Two utterances may belong to the same alternative-take group when:

- they are consecutive or nearly consecutive in the imported recording sequence;
- they are semantically similar attempts at the same thought; and
- the material between them contains no meaningful new story progression, consisting mainly of failed attempts, pauses, restarts, or other non-advancing material.

The detector should not automatically group a later semantically similar utterance when meaningful new story content occurs between the attempts. Such a later statement may be an intentional callback, summary, or clarification.

When the system is uncertain whether intervening material advances the story, it treats the material as meaningful progression and does not automatically form the cross-file alternative-take group. Automatic grouping requires strong evidence both of repeated intent and of non-advancing material between attempts.

Sequence distance, clip count, and recording-time distance may be used as secondary candidate-generation guardrails for efficiency, but they are not the semantic definition of an alternative take. The full hierarchy is sequence distance, semantic similarity, progression gate, and confidence threshold.

## Consequences

- A project needs an explicit ordered list of source clips and stable clip-local timestamps.
- Take groups may span source-file boundaries while remaining in one source chronology.
- The detector needs a notion of meaningful story progression between candidate attempts.
- Global semantic deduplication remains out of scope; locality is sequence-based and progression-aware.
- Progression uncertainty reduces automation rather than expanding the take group.
- A pair passing the sequence-distance guardrail is only eligible for evaluation; it is not yet an alternative-take relationship.
- The confirmed project sequence, rather than raw file metadata, is the canonical order for each analysis run.

## Open questions

- How should the system identify meaningful story progression conservatively?
- What should happen when clips overlap or contain duplicated source material?
