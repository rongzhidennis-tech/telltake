# ADR-059: Use all current text corrections for corrected-text reanalysis

- Status: Proposed
- Date: 2026-08-27

## Context

Transcript corrections are small creator-authored overlays intended to fix recognition errors. Requiring creators to assemble a correction set one utterance at a time would add friction to an already explicit reanalysis action.

## Decision

When the creator requests **Reanalyze using corrected text**, v1 uses all currently saved transcript correction overlays for the project’s selected transcription version. The creator does not select corrections individually.

The resulting analysis run records the correction-overlay set it consumed. Prior analysis runs and cut variants remain unchanged.

## Consequences

- Corrected-text reanalysis remains a single understandable action.
- Reverting a correction before reanalysis changes the next correction set.
- Fine-grained correction-set selection can be added later if real workflows require it.
