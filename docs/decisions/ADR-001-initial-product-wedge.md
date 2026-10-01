# ADR-001: Start with transcript-first rough-cut editing for Chinese storytelling creators

- Status: Proposed
- Date: 2026-08-17

## Context

Storytelling-style Chinese creators often record themselves while doing an activity such as makeup, getting ready, or cooking. Their raw footage may contain false starts, stumbles, abandoned sentences, pauses, and multiple attempts at delivering the same idea. The first-pass cleanup is repetitive and currently requires manually searching the video timeline for cut points.

## Decision

The initial product focus is an AI-assisted, transcript-first rough-cut editor for this creator segment. The system should:

1. transcribe speech with word- or sentence-level timestamps;
2. identify candidate false starts, abandoned speech, pauses, and alternative takes;
3. recommend a cleaned-up sequence while preserving the original media;
4. let the creator review, switch, keep, remove, and override decisions in the transcript interface; and
5. generate reversible video cuts from the reviewed transcript selection.

The AI is an assistant for first-pass editing, not an autonomous publisher or final creative authority.

The first release is optimized for a solo, Rednote-style storytelling creator who records one chronological talking-head session across multiple clips:

- raw footage: approximately 20–30 minutes total across multiple source clips;
- desired output: approximately 3–5 minutes;
- source: one camera angle and one recording session;
- current rough-cut effort: approximately 45–90 minutes;
- target outcome: approximately 5–15 minutes of creator review and adjustment.

The v1 scope prioritizes transcript-to-video accuracy and repeated-take detection. B-roll, captions, music, transitions, effects, color grading, and multi-camera editing are out of scope for this wedge.

The guaranteed launch speech matrix is Mandarin-first single-speaker storytelling, including natural Mandarin-English code-switching and regional accents where reasonably supported. Dialect-heavy speech, Cantonese and other Chinese language varieties, overlapping speech, interviews, podcasts, and multi-speaker conversational recordings are outside the v1 guarantee. The core transcript, language, and take models should remain extensible to these cases later.

Cloud processing is acceptable for v1, but the original high-resolution video should remain local whenever possible. The preferred flow is local audio extraction, encrypted upload of audio, cloud transcription and analysis, return of timestamped edit decisions, and local rendering against the original video. The pipeline should remain stage-oriented so individual processing stages can move on-device in the future.

## Consequences

- The product must preserve a reliable mapping from transcript selections to source media ranges.
- Alternative takes must be modeled as alternatives, not treated as duplicate text to delete blindly.
- Reversibility and manual override are core requirements, not later polish.
- The first version can focus on speech-led rough cuts instead of full finishing, effects, color, or publishing workflows.
- The product can assume chronological storytelling across an ordered sequence of source clips before supporting more complex editorial structures.

## Open questions

- Which creator workflow and video format should define the first release?
- What counts as a successful first-pass edit?
- How much human review is acceptable before the product stops feeling like a time saver?
- Which language, dialect, code-switching, and privacy constraints are in scope?
- Which removals are safe to apply automatically, and which must always require creator confirmation?
