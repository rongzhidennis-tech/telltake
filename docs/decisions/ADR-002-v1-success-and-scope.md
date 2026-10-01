# ADR-002: Define v1 as a reviewable rough-cut accelerator

- Status: Proposed
- Date: 2026-08-17

## Context

The target workflow is a 20–30 minute talking-head recording session represented by multiple source clips from a Rednote-style Chinese storytelling creator. The creator generally tells the story chronologically across the clips, but the footage contains pauses, false starts, stumbles, repeated phrases, and alternative takes. The intended social-media output is approximately 3–5 minutes.

## Decision

V1 succeeds when it turns the raw recording into a plausible first-pass cut that the creator can inspect and correct through the transcript, reducing rough-cut work from approximately 45–90 minutes to approximately 5–15 minutes.

V1 will prioritize:

- reliable speech transcription with precise source timestamps;
- detection and grouping of false starts, abandoned sentences, and repeated or alternative takes;
- an understandable recommendation for which take to keep;
- transcript selections that map accurately to video cuts;
- fast review, manual override, and reversible changes; and
- export of the resulting cut video.

The default safety model is:

- high-confidence mechanical edits may be applied automatically to the proposed cut;
- alternative takes may be automatically assigned a recommended take when confidence is high;
- subjective or creative judgments must remain recommendations that require creator action; and
- all automatic decisions must be visible in the transcript and reversible without changing the original media.

After mechanical cleanup, v1 may generate an optional complete AI Story Cut to help reach a creator-selected target duration, such as 3–5 minutes. The story cut is a proposed alternative sequence that requires creator review; the system must not treat its story-level removals as accepted editorial decisions by default.

V1 will not attempt to solve full creative post-production, including B-roll selection, captions, music, transitions, effects, color grading, multi-camera editing, or automatic publishing.

## Consequences

- Quality should be evaluated on time saved and edit correctness, not on how much of the process is fully autonomous.
- A useful result should include both an automatically cleaned AI Clean Cut and an immediately previewable AI Story Cut, with the story-level differences exposed for inspection and reversal.
- A recommendation that is slightly conservative but easy to review may be more valuable than an aggressive cut that silently removes story content.
- Product design must make uncertainty and alternative takes visible to the creator.
- The system needs a clear distinction between safe cleanup candidates and editorial choices that require confirmation.
- "Remove" means exclude from the proposed sequence, never delete from the source footage.
- The transcript must communicate kept content, excluded content, and take-selection decisions as distinct states.

## Open questions

- What is the acceptable error rate for removals that happen without explicit confirmation?
- Should the default behavior be conservative keep-more, or aggressive remove-more?
- How should the editor represent uncertain boundaries and competing takes?
