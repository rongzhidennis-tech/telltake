# ADR-023: Degrade conservatively when analysis is uncertain

- Status: Proposed
- Date: 2026-08-18

## Context

Transcription, utterance segmentation, and take analysis may be incomplete or uncertain because of audio quality, code-switching, accents, model errors, interrupted processing, or unsupported speech. The product’s safety model favors preserving source content over making aggressive guesses.

## Decision

When a stage is incomplete or confidence is insufficient:

- preserve the affected source content in the AI Clean Cut;
- omit low-confidence automatic exclusions or take replacements;
- expose uncertainty or incomplete coverage where it affects review;
- allow the rest of the project to remain usable when possible; and
- avoid blocking the entire project because one region or stage failed.

Low-confidence suggestions may be surfaced later for creator review, but they must not silently change the proposed cut.

## Consequences

- The AI Clean Cut may be longer than expected when analysis quality is poor, but it remains safer and explainable.
- The project needs region-level or stage-level status rather than only a single success/failure state.
- Evaluation should reward safe preservation and recoverability, not only the amount of content removed.
