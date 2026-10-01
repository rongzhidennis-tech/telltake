# ADR-060: Preserve standalone visual-only spans by default

- Status: Proposed
- Date: 2026-08-27

## Context

The target creator may pause speaking while applying makeup, reacting, looking at the camera, handling an object, or performing another visually meaningful action. A transcript-only system cannot infer that a speechless span has no value.

## Decision

V1 preserves standalone speechless or visual-only spans in the AI Clean Cut by default. The absence of a recognized utterance is not evidence that the underlying video is disposable.

The transcript-first UI represents these spans as lightweight non-speech context rows, for example:

> Visual / no speech · 4.8s · Play

Each row preserves its source clip and timing, displays duration, supports playback, and is visually distinct from transcript utterances. It does not support text correction and is not treated as a normal utterance for semantic take detection.

Mechanical silence associated with a detected restart or false start may still be removed as part of the corresponding high-confidence mechanical decision. Standalone visual-only spans are not automatically removed by the AI Clean Cut or AI Story Cut solely because they contain no speech.

## Consequences

- The project must represent source ranges that have no recognized speech.
- Cut generation cannot assume that the transcript covers all meaningful video content.
- Transcript and video sequence views need a distinct non-speech context state.
- Future visual understanding can add recommendations without changing the source-range model.
