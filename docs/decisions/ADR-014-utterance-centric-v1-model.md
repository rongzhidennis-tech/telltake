# ADR-014: Keep the v1 editing model utterance-centric

- Status: Proposed
- Date: 2026-08-18

## Context

Filler words, pauses, and word-level timing are useful signals, but exposing them as individual editing tasks would turn the product into a micro-editor and recreate the repetitive review workflow it is meant to remove. The core creator job is selecting meaningful speech units and choosing among alternative attempts.

## Decision

The v1 creator-facing editing model has three primary objects:

1. **Utterance** — a natural sentence- or speech-unit-sized row that can be kept or excluded.
2. **Alternative-take group** — locally repeated utterances in the ordered recording sequence, potentially across source-file boundaries, expressing the same thought and separated by no meaningful story progression.
3. **Story section** — a contiguous range of one or more utterances that can be proposed for removal as part of the AI Story Cut.

The UI also shows **non-speech context spans** as lightweight playback-only rows. They preserve visual-only content but are not utterances, take candidates, or transcript-text editing objects.

Words, filler words, and pauses remain underlying metadata. They support transcription alignment, take detection, confidence assessment, natural cut-boundary selection, and future capabilities, but they are not standalone editing objects in v1.

Accordingly:

- the AI Clean Cut may exclude an utterance or select an alternative take when the mechanical evidence is high confidence;
- the AI Story Cut may propose removing an utterance or multi-utterance story section;
- filler-word cleanup is handled, if at all, through choosing a better complete take rather than deleting individual words; and
- pause removal is handled, if at all, as part of excluding an abandoned utterance or selecting another take, not as an independent pause task.

## Consequences

- The transcript UI stays centered on selecting, switching, restoring, and previewing meaningful speech units.
- The data model still needs word timestamps and pause metadata, but the UI does not need word-level checkboxes or pause cards.
- Automatic decisions can be evaluated at the utterance/take level, which better matches the creator’s real editing workflow.
- Story-level diffs remain easy to explain because each proposed removal maps to a contiguous transcript range.
- A future micro-editing or pacing mode can be layered on later without redesigning the underlying alignment model.
- The transcript view does not imply that untranscribed source ranges are valueless.

## Open questions

- What exactly qualifies as an utterance boundary for long or compound sentences?
- How should the system represent a creator override that changes only an internal boundary without exposing word-level editing?
