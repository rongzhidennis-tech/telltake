# ADR-058: Require explicit reanalysis after transcript correction

- Status: Proposed
- Date: 2026-08-27

## Context

Creator text corrections can improve semantic analysis, especially for Mandarin-English code-switching and proper nouns, but automatically recomputing take groups or cuts would make a small text change unexpectedly alter creator work.

## Decision

Transcript corrections do not automatically trigger AI recomputation. Existing analysis runs, AI Clean Cuts, AI Story Cuts, and Creator Cuts remain unchanged.

The creator may explicitly request **Reanalyze using corrected text**. That action creates a new analysis run referencing the immutable transcription version plus the selected correction overlays. The new run produces new AI results without modifying prior runs or cuts.

In v1, the selected correction-overlay set is all currently saved corrections for that transcription version.

Source timing, utterance boundaries, and media ranges remain unchanged by text correction and text-based reanalysis in v1.

## Consequences

- Text correction remains low-risk and predictable during review.
- The project must record which correction overlay set an analysis run used.
- The UI needs a clear distinction between corrected display text and the text used by each analysis run.
- Reanalysis remains subject to the no-cross-run merge rule.
