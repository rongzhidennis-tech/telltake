# ADR-109: Default removal of gaps enclosed by removed utterances

Status: Accepted for the local macOS workflow, September 19, 2026.
Related: ADR-107 and ADR-108.

## Decision

The user explicitly requested default removal of a no-speech interval when its
preceding and following utterances are both fully removed, with a warning and
restoration available. This narrowly supersedes ADR-107's preservation of all
non-speech intervals and the corresponding default in CONTEXT. It does not
enable general silence detection or automatic shortening of every pause.

Apply the rule to original no-speech review rows after the rough cut's
speech decisions and local validation have resolved. Find nearest speech on both
sides in the confirmed source chronology, including across clips. Require every
tied neighbor to be completely excluded. Preserve a gap if either neighbor is
partly retained, if speech overlaps it, if a neighbor is absent, or if transcript
coverage is incomplete. Hidden protected context remains protected. All positive
gaps between timed utterances and at completed-clip edges must be represented,
including gaps shorter than two seconds. Pauses only must expose these rows too.
A display-duration filter must not determine which gaps enter the edit policy.

Save the removed row IDs and visual-content warnings in the analysis application
evidence. The corrected application policy is `continuity-rough-cut-v3-all-gaps`; the
Sol/high prompt, provider response and transcription are unchanged. Old sealed
AI cuts remain immutable. No retrospective change is made simply by opening one.

An individual manual utterance removal also removes newly enclosed gaps in the
same undoable operation. Do not repeatedly reapply the rule to already enclosed
gaps: a creator-restored gap stays restored during unrelated edits. Restoring
speech does not silently restore other rows; Keep / restore and Undo remain
explicit. Legacy Story-section and boundary-edit contracts are unchanged.

For saved cuts, Remove enclosed gaps explicitly applies the rule without another
AI request. Record the batch as `remove_enclosed_gaps` in existing edit history,
forking a Creator Cut when needed. Full state, revision, plan, duration and undo
evidence commit atomically. No schema migration is required.

## Review and verification

Excluded no-speech rows remain visible in orange with a textual warning and
appear under Needs review only. A restored gap loses its current removal warning;
original AI evidence remains available. Warnings do not block independent edits.

Tests cover two fully excluded neighbors, partial retention, chronology across
clips, tied neighbors, overlapping speech, incomplete coverage, beginning/end
gaps, persisted warnings, unchanged original rows and AI baseline, restoration,
undo/redo, stale edits and transactional rollback.

Offline replay of the saved Test23 continuity-v2 response removes 112 visible
gaps: 41:09.353 becomes 33:03.373, saving 8:05.981. All 607 speech-row decisions
remain unchanged (242 kept, 359 excluded, six partial); no paid API call occurs.
The replay writes a fresh local backup. This is a deterministic behavior check,
not an acoustic or visual quality assessment; the user handles that review.

## Short-gap correction

The initial v2 implementation incorrectly reused a projection that hid gaps below
two seconds. Test23 retained 15 detached speechless fragments totaling 8.07 seconds
between the reported makeup and Bobbi Brown passages, despite all displayed gaps
being excluded. The v3 policy includes every positive inferred gap and exposes its
duration, warning and restore action. A regression reproduces the actual projection
→ application → saved review path with a 300 ms interval, rather than passing a
manually constructed gap row directly to the candidate helper.
