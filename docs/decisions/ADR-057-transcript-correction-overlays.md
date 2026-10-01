# ADR-057: Store creator transcript corrections as overlays

- Status: Proposed
- Date: 2026-08-27

## Context

Automatic transcription may misrecognize Mandarin proper nouns, English brand names, internet slang, or code-switched phrases. Creators need to correct visible transcript text without changing the source media, utterance timing, or cut boundaries.

## Decision

V1 supports limited creator text corrections stored as overlays on an immutable transcription version. A correction changes displayed/searchable transcript text only; it does not alter word timestamps, source ranges, utterance boundaries, take-group membership, or rendered audio/video.

The creator edits the text of an entire utterance, with optional cursor placement within that utterance. V1 does not expose word-level timing edits, utterance splitting/merging, or audio changes through transcript correction.

Corrections carry provenance and can be reverted. The original recognized text remains available for audit and analysis reproducibility.

## Consequences

- Creators can fix visible text errors without turning transcript correction into a separate media-editing workflow.
- AI analysis runs remain explainable against the transcription version they consumed.
- The UI must distinguish recognized text from creator-corrected display text when needed.
- If a text correction should affect future semantic analysis, that requires an explicit new analysis run rather than silently mutating prior results.
