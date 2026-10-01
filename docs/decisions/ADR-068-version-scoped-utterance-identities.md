# ADR-068: Scope utterance identities to transcription versions

- Status: Proposed
- Date: 2026-08-27

## Context

Rerunning transcription may change utterance boundaries, text, word alignment, or segmentation. Reusing the same utterance identity across incompatible transcript versions could make old take groups and cuts point at the wrong source units.

## Decision

Each transcription version owns its own immutable utterance identities and word-alignment records. Downstream analysis runs, take groups, cut decisions, and source-range mappings reference utterances from the specific transcription version they consumed.

Cross-version utterance mapping is not required in v1. If future migration needs to relate equivalent utterances across versions, it is an explicit derived mapping and must not mutate prior results.

## Consequences

- Older analysis runs and cuts remain stable when transcription is rerun.
- The SQLite schema must include transcription-version scope in utterance references.
- Creator Cut provenance can always resolve to the original source clip and transcript version.
- New analysis runs need new take-group and decision identities, even if the result appears similar.
