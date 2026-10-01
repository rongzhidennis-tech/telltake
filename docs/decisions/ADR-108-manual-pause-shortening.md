# ADR-108: Reversible pause shortening and transition review

Status: Accepted for the local macOS validation workflow, September 19, 2026.
Related: ADR-107; creator edit history and preview/export contracts.

## Decision

Keep the accepted transcription and text-cleanup configuration stable. Add a
manual pacing adjustment to original non-speech review rows, including derived
gaps. Absence of transcript speech is not evidence that a visual action is
unnecessary. Never apply this adjustment automatically or to all gaps at once.

[ADR-109](ADR-109-enclosed-gap-default-removal.md) separately authorizes complete
default removal of a gap between two fully removed utterances, with a warning.
That rule does not automatically apply this manual duration-shortening control.

The creator selects a row and chooses Shorten pause. Retain 0.6 seconds by
default, split equally between the original interval's two ends; allow a minimum
of 0.4 seconds. These are adjustable pacing defaults, not measured acoustic
boundaries. The creator reviews the picture and sound. Reject overlap with
transcript speech or other protected context, stale state and unavailable media.
Subtract the middle only from currently retained ranges; repeated adjustments
must not restore an earlier removal. Use Keep / restore or Undo to lengthen it.

Fork an immutable AI baseline into a Creator Cut, or revise the existing Creator
Cut. Save the plan and `shorten_context` edit operation atomically using the
existing edit-history representation. Preserve the original rows and timing.
Restoration, undo/redo, reopening, preview approval and export retain their
existing contracts. No database schema change is required.

## Review controls

Pauses only filters original non-speech rows, including subsecond gaps after the
ADR-109 correction; it does not infer silence or change the cut. Previous join / Next join navigate
the prepared cut using cumulative retained duration, starting playback one
second before each join. Reuse the existing source validation and seek path.
Playback highlighting follows original source rows without changing the editing
selection. These controls do not approve a cut or certify transition quality.

## Verification

Tests cover retained edges, unchanged transcript and AI baseline, reopening,
no-op repetition, undo/redo, full restoration, invalid targets, stale state,
overlap, missing media, transactional rollback and composition join positions.
A disposable generated-media fixture exercises shorten → restore → undo →
prepared preview → approval → real MP4 export. Human Test23 pacing and visual
review remain with the user; no automated quality judgment replaces that review.
