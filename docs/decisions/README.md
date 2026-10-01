# Architecture decision index

## Authority and conflicts

1. Accepted ADRs govern their explicit scope. ADR-073 reconciles the review conflicts
   and amends the earlier decisions listed there; an explicit amendment or supersession
   takes precedence over the affected clause. A later date alone is not an override.
2. The root context and product brief summarize the adopted v1 behavior. Historical
   Proposed ADRs are requirements only where incorporated into that baseline or an
   Accepted ADR. Unadopted clauses and open questions remain proposals.
3. The glossary owns vocabulary, not an alternative product behavior. The SQLite
   catalog and ordered migrations implement persistence; they cannot silently change
   product rules. The roadmap sequences work and cannot expand or weaken acceptance.
4. Surface any remaining disagreement before implementing the affected behavior.
   Record the resolution in an explicit ADR amendment, then update summaries and tickets.

Keep historical IDs stable. Mark answered questions with links to their resolution;
do not leave them listed as unresolved. Update this index when adding or changing an ADR.
The current implementation and recommended module boundaries are in
[code architecture](../code-architecture.md).

## Current pipeline

The shipped app is described by six decisions read together:
[ADR-106](ADR-106-doubao-transcription-review-evidence.md) (Doubao Turbo transcription
with review-only acoustic evidence) → [ADR-110](ADR-110-transcription-progress-and-concurrency.md)
(saved per-clip progress and bounded concurrency) → [ADR-107](ADR-107-continuous-text-rough-cut.md)
(the AI Rough Cut from transcript text with GPT-5.6 Sol) → [ADR-109](ADR-109-enclosed-gap-default-removal.md)
(default removal of gaps enclosed by removed speech) → [ADR-108](ADR-108-manual-pause-shortening.md)
(manual pause shortening and join review) → [ADR-089](ADR-089-plan-preview-and-approval.md) and
[ADR-091](ADR-091-captured-local-mp4-exports.md) (full-preview approval and captured-plan
export). Persistence and editing rest on ADR-072 to ADR-092. Where these narrow or replace an
earlier decision, the earlier row below says so.

## Decisions

| Decision / topic | Status |
| --- | --- |
| [ADR-001: Start with transcript-first rough-cut editing for Chinese storytelling creators](ADR-001-initial-product-wedge.md) | Proposed |
| [ADR-002: Define v1 as a reviewable rough-cut accelerator](ADR-002-v1-success-and-scope.md) | Proposed |
| [ADR-003: Automate high-confidence mechanical cleanup, suggest creative edits](ADR-003-reversible-automation-boundary.md) | Proposed |
| [ADR-004: Suggest story-level cuts to reach a target duration](ADR-004-target-duration-suggestions.md) | Proposed |
| [ADR-005: Launch with Mandarin-first single-speaker recordings](ADR-005-launch-speech-matrix.md) | Proposed |
| [ADR-006: Use cloud intelligence with stage-specific data minimization](ADR-006-data-minimizing-cloud-processing.md) | Proposed |
| [ADR-007: Use utterances for creator edits and words for alignment](ADR-007-utterance-first-transcript-editing.md) | Proposed |
| [ADR-008: Focus v1 take detection on local retries](ADR-008-local-alternative-take-detection.md) | Superseded by ADR-034 |
| [ADR-009: Collapse take groups while exposing the AI decision](ADR-009-collapsed-take-groups-with-visible-decisions.md) | Proposed |
| [ADR-010: Review a complete story cut against a clean-cut baseline](ADR-010-two-cut-review-model.md) | Proposed |
| [ADR-011: Preserve two AI baselines and one creator working cut](ADR-011-simple-cut-variant-model.md) | Proposed |
| [ADR-012: Remove only restart-associated pauses automatically](ADR-012-conservative-pause-removal.md) | Superseded by ADR-014 |
| [ADR-013: Keep uncertain mechanical candidates separate from story cuts](ADR-013-separate-optional-cleanup-candidates.md) | Superseded by ADR-014 |
| [ADR-014: Keep the v1 editing model utterance-centric](ADR-014-utterance-centric-v1-model.md) | Proposed |
| [ADR-015: Restrict v1 story removals to contiguous utterance ranges](ADR-015-contiguous-story-sections.md) | Proposed |
| [ADR-016: Use a target duration range for story-cut generation](ADR-016-target-duration-range.md) | Proposed |
| [ADR-017: Keep v1 edits in original chronological order](ADR-017-preserve-source-chronology.md) | Proposed |
| [ADR-018: Export one locally rendered MP4 for v1](ADR-018-local-mp4-export.md) | Proposed |
| [ADR-019: Evaluate iPhone-first and macOS-first against the real creator workflow](ADR-019-platform-surface-evaluation.md) | Accepted |
| [ADR-020: Build and validate on macOS, target iPhone for creators](ADR-020-phased-platform-strategy.md) | Proposed |
| [ADR-021: Persist a reopenable, portable edit-state project](ADR-021-reopenable-portable-projects.md) | Proposed |
| [ADR-022: Delete cloud processing artifacts by default](ADR-022-default-cloud-deletion.md) | Proposed |
| [ADR-023: Degrade conservatively when analysis is uncertain](ADR-023-conservative-degradation-on-uncertainty.md) | Proposed |
| [ADR-024: Expose processing stages progressively](ADR-024-progressive-processing-results.md) | Proposed |
| [ADR-025: Generate the AI Story Cut only after explicit target input](ADR-025-explicit-story-cut-generation.md) | Proposed |
| [ADR-026: Prefill the Story Cut target with 3–5 minutes](ADR-026-prefilled-target-range.md) | Proposed |
| [ADR-027: Prefer the best coherent Story Cut when the target is unattainable](ADR-027-best-effort-story-cut-targets.md) | Proposed |
| [ADR-028: Evaluate AI Clean Cut with precision-first safety metrics](ADR-028-precision-first-clean-cut-evaluation.md) | Proposed |
| [ADR-029: Evaluate on consented real creator recordings](ADR-029-real-recording-evaluation-corpus.md) | Proposed |
| [ADR-030: Separate evaluation consent from improvement consent](ADR-030-purpose-specific-data-consent.md) | Proposed |
| [ADR-031: Treat Creator Cut changes as feedback by default](ADR-031-creator-cuts-as-feedback-not-ground-truth.md) | Proposed |
| [ADR-032: Use active creator review time as the primary success metric](ADR-032-active-review-time-as-primary-kpi.md) | Proposed |
| [ADR-033: Keep editing transcript-first with read-only timeline context](ADR-033-transcript-first-with-read-only-timeline.md) | Proposed |
| [ADR-034: Define local take detection over the ordered recording sequence](ADR-034-cross-file-recording-sequence-take-detection.md) | Proposed |
| [ADR-035: Infer clip order, then freeze a creator-confirmed sequence](ADR-035-confirmed-recording-sequence.md) | Proposed |
| [ADR-036: Make source-clip inclusion nondestructive](ADR-036-nondestructive-clip-inclusion.md) | Proposed |
| [ADR-037: Treat uncertain story progression as a group boundary](ADR-037-conservative-progression-boundaries.md) | Proposed |
| [ADR-038: Surface uncertain repeats as non-applied suggestions](ADR-038-non-applied-possible-alternatives.md) | Proposed |
| [ADR-039: Keep Possible alternatives separate until creator confirmation](ADR-039-possible-alternatives-review-ui.md) | Proposed |
| [ADR-040: Mark creator-confirmed take groups distinctly](ADR-040-creator-confirmed-take-groups.md) | Proposed |
| [ADR-041: Support multiple candidates per take group](ADR-041-multi-candidate-take-groups.md) | Proposed |
| [ADR-042: Let creators edit take-group membership](ADR-042-editable-creator-take-groups.md) | Proposed |
| [ADR-043: Keep excluded content visible and reversible](ADR-043-visible-excluded-transcript-content.md) | Proposed |
| [ADR-044: Use sequence distance only as a candidate-search guardrail](ADR-044-configurable-sequence-distance-guardrail.md) | Proposed |
| [ADR-045: Keep take-search guardrails internal in v1](ADR-045-internal-take-search-configuration.md) | Proposed |
| [ADR-046: Preserve prior results across reanalysis](ADR-046-versioned-analysis-runs.md) | Proposed |
| [ADR-047: Show the newest successful analysis by default](ADR-047-newest-analysis-default.md) | Proposed |
| [ADR-048: Do not merge analysis runs into Creator Cuts in v1](ADR-048-no-cross-run-creator-cut-merge.md) | Proposed |
| [ADR-049: Use a portable `.easycut` project package](ADR-049-project-package-format.md) | Accepted |
| [ADR-050: Make SQLite the canonical project-state store](ADR-050-sqlite-canonical-project-state.md) | Proposed |
| [ADR-051: Back up canonical state, not caches](ADR-051-durable-project-backup-boundary.md) | Proposed |
| [ADR-052: Open projects in review-only mode when source clips are missing](ADR-052-review-only-with-missing-source-media.md) | Proposed |
| [ADR-053: Allow partial inspection during source relinking](ADR-053-partial-source-relinking.md) | Proposed |
| [ADR-054: Validate relinked clips with strong source identity](ADR-054-strong-source-relink-validation.md) | Proposed |
| [ADR-055: Keep rendered exports external by default](ADR-055-external-export-files-by-default.md) | Proposed |
| [ADR-056: Preserve transcription results as immutable versions](ADR-056-immutable-transcription-versions.md) | Proposed |
| [ADR-057: Store creator transcript corrections as overlays](ADR-057-transcript-correction-overlays.md) | Proposed |
| [ADR-058: Require explicit reanalysis after transcript correction](ADR-058-explicit-reanalysis-after-text-correction.md) | Proposed |
| [ADR-059: Use all current text corrections for corrected-text reanalysis](ADR-059-reanalyze-all-current-corrections.md) | Proposed |
| [ADR-060: Preserve standalone visual-only spans by default](ADR-060-preserve-visual-only-spans.md) | Proposed; narrowed by ADR-109 (gaps enclosed by removed speech are removed by default with a warning and restore) |
| [ADR-061: Allow explicit manual removal of visual-only spans](ADR-061-manual-removal-of-visual-only-spans.md) | Proposed |
| [ADR-062: Show curated non-speech context rows](ADR-062-curated-non-speech-context-rows.md) | Proposed; widened by ADR-109 (every positive gap is a visible row, including gaps under two seconds) |
| [ADR-063: Persist resolved cut plans alongside edit provenance](ADR-063-materialized-cut-plans-with-provenance.md) | Proposed |
| [ADR-064: Store edit operations as append-only provenance](ADR-064-append-only-edit-operations.md) | Proposed |
| [ADR-065: Persist undo history and scope redo to the editing session](ADR-065-persistent-undo-session-redo.md) | Proposed |
| [ADR-066: Scope each v1 project to one recording session](ADR-066-one-recording-session-per-project.md) | Proposed |
| [ADR-067: Keep source clips immutable and sequence membership separate](ADR-067-immutable-source-clips-separate-membership.md) | Proposed |
| [ADR-068: Scope utterance identities to transcription versions](ADR-068-version-scoped-utterance-identities.md) | Proposed |
| [ADR-069: Keep AI analysis outputs immutable per run](ADR-069-immutable-analysis-output-per-run.md) | Proposed |
| [ADR-070: Persist unaccepted AI recommendations](ADR-070-persist-unaccepted-recommendations.md) | Proposed |
| [ADR-071: Persist recommendation dismissals per analysis run](ADR-071-persist-recommendation-dismissals.md) | Proposed |
| [ADR-072: Establish the portable-core runtime and test seams](ADR-072-portable-core-runtime-and-test-seams.md) | Accepted |
| [ADR-073: Reconcile the v1 product and persistence contracts](ADR-073-review-contract-clarifications.md) | Accepted |
| [ADR-074: Make recording-sequence commands deterministic and atomic](ADR-074-recording-sequence-import.md) | Accepted |
| [ADR-075: Require exact recorded identity when relinking sources](ADR-075-source-relink-validation.md) | Accepted |
| [ADR-076: Enforce dataset consent through a shared registry](ADR-076-dataset-registry.md) | Accepted |
| [ADR-077: Persist transcription inputs, coverage, and cleanup](ADR-077-durable-transcription.md) | Accepted |
| [ADR-078: Project a read-only transcript review with preserved context](ADR-078-transcript-review.md) | Accepted |
| [ADR-079: Persist conservative, versioned take-analysis evidence](ADR-079-versioned-take-analysis.md) | Accepted |
| [ADR-080: Materialize conservative immutable Clean Cut plans](ADR-080-immutable-clean-cut-plans.md) | Accepted; the Clean-kind cut slot is now filled by the AI Rough Cut (ADR-107), and the per-utterance analysis that produced Clean Cuts is retained for existing projects only (post-launch action P1) |
| [ADR-081: Fork an AI baseline on the first utterance edit](ADR-081-creator-utterance-edits.md) | Accepted |
| [ADR-082: Reverse Creator edits through append-only operations](ADR-082-persistent-edit-reversal.md) | Accepted |
| [ADR-083: Persist explicitly requested Story Cut proposals](ADR-083-explicit-story-cut-proposals.md) | Accepted; deferred from v1: the shipped app does not generate Story Cuts, and saved proposals remain reviewable |
| [ADR-084: Review and edit Creator take groups independently of inclusion](ADR-084-creator-take-group-editing.md) | Accepted |
| [ADR-085: Manual Story section and curated context edits](ADR-085-manual-section-context-edits.md) | Accepted |
| [ADR-086: Conservative utterance boundary adjustments](ADR-086-conservative-boundary-adjustments.md) | Accepted |
| [ADR-087: Sealed transcript correction snapshots](ADR-087-sealed-transcript-corrections.md) | Accepted |
| [ADR-088: Explicit corrected-text reanalysis and non-merging history](ADR-088-corrected-text-reanalysis-history.md) | Accepted |
| [ADR-089: Resolved-plan preview and explicit approval](ADR-089-plan-preview-and-approval.md) | Accepted |
| [ADR-090: Import camera spatial audio and variable frame timing](ADR-090-camera-recording-compatibility.md) | Accepted |
| [ADR-091: Captured-plan local MP4 exports](ADR-091-captured-local-mp4-exports.md) | Accepted |
| [ADR-092: Canonical backups and non-destructive recovery inspection](ADR-092-canonical-backup-and-recovery.md) | Accepted |
| [ADR-093: Require one-time user-level cloud processing consent](ADR-093-user-level-cloud-processing-consent.md) | Accepted; model choice amended by ADR-100 and then ADR-107 (GPT-5.6 Sol); consent extended to Doubao transcription by ADR-106 |
| [ADR-094: Guard the small-scale cloud integration with explicit credentials](ADR-094-cloud-credentials-and-test-integration.md) | Accepted; model choice amended by ADR-100 and ADR-107; a separate Doubao key added by ADR-106; the validation model list is `gpt-5.6-sol` only |
| [ADR-095: Prepare bounded cloud audio without changing the source timeline](ADR-095-timeline-preserving-cloud-audio-chunks.md) | Accepted |
| [ADR-096: Preserve segments with zero-duration word alignment](ADR-096-conservative-zero-duration-alignment.md) | Accepted |
| [ADR-097: Preserve text at zero-duration segment boundaries](ADR-097-conservative-zero-duration-segments.md) | Accepted |
| [ADR-098: Keep complete segment text when word timing cannot be assigned](ADR-098-complete-text-alignment-fallback.md) | Accepted |
| [ADR-099: Local reference-cut reconstruction pilot](ADR-099-local-reference-cut-reconstruction.md) | Accepted |
| [ADR-100: Use GPT-5.6 Luna for cost-sensitive text analysis](ADR-100-cost-sensitive-text-analysis-model.md) | Superseded in part by ADR-107: the shipped analysis uses GPT-5.6 Sol, and the Luna client was removed on 2026-09-21; the versioning and cost-accounting rules remain |
| [ADR-101: Keep transcript editing beside cut preview](ADR-101-transcript-preview-workspace.md) | Accepted |
| [ADR-102: Compact analysis transport and retain usage evidence](ADR-102-compact-analysis-and-usage-accounting.md) | Accepted for usage evidence; the compact take/Story transport was removed with the Luna client (2026-09-21), and the Rough Cut request format is ADR-107's |
| [ADR-103: Detect and review complete passage takes](ADR-103-passage-level-take-review.md) | Accepted implementation; not run by the shipped app (the Rough Cut replaced per-utterance analysis); retained for existing projects, retirement scheduled as post-launch action P1 |
| [ADR-104: Localized alignment and passage calibration](ADR-104-localized-alignment-and-passage-calibration.md) | Accepted implementation; automatic-selection quality gate failed; Whisper provider choice superseded by ADR-106 for new desktop runs |
| [ADR-105: Narrow retake rough cuts with reversible boundaries](ADR-105-development-retake-rough-cuts.md) | Accepted for development-only use; the reversible boundary adjustment ("Adjust AI cut edges…") ships, the retake policy does not run in the shipped analysis |
| [ADR-106: Doubao Turbo transcription with review-only acoustic evidence](ADR-106-doubao-transcription-review-evidence.md) | Accepted; supersedes ADR-104's Whisper provider choice for new desktop runs; extends ADR-093 consent and ADR-094 credentials to Doubao |
| [ADR-107: Continuous transcript cleanup as a reversible rough cut](ADR-107-continuous-text-rough-cut.md) | Accepted; the shipped analysis (AI Rough Cut, GPT-5.6 Sol); supersedes the precision-only automation policy for this labelled proposal and ADR-100's model choice; gap preservation narrowed by ADR-109 |
| [ADR-108: Reversible pause shortening and transition review](ADR-108-manual-pause-shortening.md) | Accepted; manual, one row at a time, never automatic |
| [ADR-109: Default removal of gaps enclosed by removed utterances](ADR-109-enclosed-gap-default-removal.md) | Accepted; narrows ADR-060, ADR-107 and the CONTEXT default; application policy `continuity-rough-cut-v3-all-gaps` |
| [ADR-110: Saved transcription progress and bounded Doubao concurrency](ADR-110-transcription-progress-and-concurrency.md) | Accepted and implemented; up to two concurrent Doubao requests, durable per-clip checkpoints, Stop keeps finished clips |
