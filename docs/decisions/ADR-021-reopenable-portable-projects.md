# ADR-021: Persist a reopenable, portable edit-state project

- Status: Proposed
- Date: 2026-08-18

## Context

The macOS prototype includes long-running cloud analysis and local rendering. Creators need to close and reopen work without losing transcripts, take analysis, cut variants, or manual decisions. The saved state is also the migration boundary for the future iPhone product.

## Decision

V1 persists a reopenable project containing, at minimum:

- ordered source-clip identities and local references;
- original source metadata and creator-confirmed project sequence;
- source media metadata needed for validation;
- immutable transcription versions containing timestamped transcript and word alignment;
- utterance segmentation;
- alternative-take groups and recommendations;
- AI Clean Cut;
- AI Story Cut;
- Creator Cut, when created;
- edit decisions and provenance;
- target duration range; and
- rendering plans and export status.
- analysis-run identity and configuration version for each AI result.

Each project contains one recording session, immutable source-clip records, and versioned sequence membership that defines the ordered active clip set.

The project stores edit state and derived analysis rather than duplicating the original high-resolution video. Its schema should be platform-neutral and versioned so a later iPhone client can read or migrate projects created on macOS.

When a referenced source clip is moved, renamed, or unavailable, reopening the project should show a clear relink flow. The creator can choose the matching local source file for each missing clip, after which the app validates its identity and metadata before enabling preview or export.

Relinking uses strong source identity validation; filename, path, and timestamps are hints only.

If source clips are unavailable, the project remains open for transcript and decision review in a review-only mode; source-dependent preview and export remain disabled until relinking succeeds.

## Consequences

- Cloud processing and local export can resume independently from persisted state.
- The project must detect stale, missing, or incompatible source media before preview or export.
- Analysis outputs must identify the project-sequence revision they were computed against.
- Schema versioning and migration are launch requirements for the portable core.
- Cached audio or proxy media may be treated as disposable derived artifacts rather than authoritative project state.

## Open questions

- Which derived artifacts may be safely regenerated after migration?
