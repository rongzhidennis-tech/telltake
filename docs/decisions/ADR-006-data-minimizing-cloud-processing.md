# ADR-006: Use cloud intelligence with stage-specific data minimization

- Status: Proposed
- Date: 2026-08-17

## Context

Cloud transcription and AI analysis are acceptable for v1 because local-only processing could significantly compromise quality, model capability, or development speed. Creator footage may be sensitive and high-resolution video is larger and more private than the audio needed for speech processing.

## Decision

V1 should use a data-minimizing, stage-oriented pipeline:

1. keep the original high-resolution source video on the creator’s device whenever possible;
2. extract audio locally when transcription does not require video pixels;
3. upload only the minimum representation required by each cloud stage;
4. encrypt uploaded data in transit and at rest;
5. return transcript and edit decisions to the client;
6. perform video editing and export locally against the original footage; and
7. provide clear, user-controlled deletion of uploaded media, transcripts, and associated processing artifacts.

Cloud retention should be limited and clearly communicated. Temporary artifacts should not be retained indefinitely by default. The processing pipeline should not permanently require cloud execution; each stage should have a boundary that could support a future on-device implementation.

The default v1 retention policy is to delete uploaded audio and temporary cloud artifacts after the transcript and analysis outputs have been durably returned. The local project remains the primary retained record of transcript and edit state.

## Consequences

- V1 requires a reliable local audio extraction and local render path.
- Backend interfaces should exchange stage outputs such as timestamped transcripts and edit decisions rather than require a persistent cloud copy of the original video.
- Storage, retention, deletion, encryption, and failure recovery are product requirements, not only infrastructure concerns.
- Some future features that depend on visual content will require a new explicit data-flow decision.

## Open questions

- Which exact temporary artifacts are created by each processing stage?
- What retention duration and deletion semantics should the product promise?
- How should processing behave if the creator goes offline after upload but before local rendering?
