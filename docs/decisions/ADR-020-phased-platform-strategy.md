# ADR-020: Build and validate on macOS, target iPhone for creators

- Status: Proposed
- Date: 2026-08-18

## Context

The target creators are likely to record, review, edit, export, and publish on iPhone. The core workflow can nevertheless be validated faster and with lower implementation risk on macOS, where long-running local media work and transcript-heavy review are easier to develop.

## Decision

Use a two-phase platform strategy:

### Phase 1 — macOS validation prototype

Implement and stabilize the complete workflow:

- video import;
- local audio extraction;
- cloud transcription;
- utterance segmentation;
- local alternative-take detection and/or AI take analysis;
- AI Clean Cut generation;
- AI Story Cut generation;
- Creator Cut editing;
- transcript-driven preview; and
- local video export.

### Phase 2 — iPhone product implementation

Reuse the platform-neutral editing model and processing contracts while redesigning the interaction for mobile. Add Photos import, mobile-friendly transcript review, export progress and recovery, and system share-sheet publishing.

MacOS-specific UI code must not own the core transcript, take-group, edit-decision, cut-variant, AI API, or rendering-plan models.

## Consequences

- The macOS prototype can optimize for learning speed without defining the final product surface.
- Portable domain models and deterministic edit plans become an explicit acceptance criterion for Phase 1.
- The team should avoid building desktop-only timeline concepts that are not required by the utterance-centric workflow.
- iPhone work can begin once the AI editing model is reliable enough, without waiting for a polished commercial Mac editor.

## Open questions

- What project format allows a macOS session to be reopened and later migrated to iPhone?
- Which rendering responsibilities belong to the shared core versus each platform?
- Which macOS conveniences are allowed in the prototype without creating migration debt?
