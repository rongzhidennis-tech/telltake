# ADR-056: Preserve transcription results as immutable versions

- Status: Proposed
- Date: 2026-08-27

## Context

Transcription may be rerun with a different model, language configuration, or audio preprocessing. A revised transcript can change utterance boundaries, word alignment, and downstream take analysis. Older AI results must remain auditable and valid against the transcript they used.

## Decision

Each transcription execution produces an immutable versioned transcript result. The result includes source-clip references, project-sequence revision, word alignment, utterance segmentation, language metadata, and transcription configuration identity.

Each analysis run references exactly one immutable transcription version plus an explicit correction-overlay set, which may be empty. Re-running transcription creates a new version and does not mutate the transcript used by earlier analysis runs or cut variants.

Utterance and word-alignment identities are scoped to the transcription version; downstream analysis must not assume stable utterance IDs across versions.

Creator-facing text corrections are stored as explicit overlays rather than mutating the original transcription result.

## Consequences

- Older AI Clean Cuts, AI Story Cuts, and Creator Cuts remain explainable against their original transcript.
- The SQLite schema needs distinct transcription-version and analysis-run entities.
- Reprocessing can reuse a prior transcript or create a new one without ambiguity.
- Project size remains manageable because transcript data is small relative to source media.
