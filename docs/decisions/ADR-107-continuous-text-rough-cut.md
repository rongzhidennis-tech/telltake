# ADR-107: Continuous transcript cleanup as a reversible rough cut

Status: Accepted for the local macOS validation workflow, September 19, 2026.
Related: ADR-103, ADR-104, ADR-105, ADR-106; Point 6 integration.

## Decision

The user accepted a text-first rough-cut workflow. Use the full chronological
transcript with the frozen `text-cleanup-continuity-v2` prompt, GPT-5.6 Sol/high,
and a 32,000 output-token cap. Prefer preserving unique details, the latest
successfully completed attempt, and coherent continuous passages with fewer
internal deletions. These are editorial preferences, not a promise of perfect
selection. The creator reviews and restores content as needed.

This changes the earlier precision-only automatic Clean Cut policy for this
explicit workflow. Label its output **AI Rough Cut**, distinct from older
mechanical AI Clean Cuts. Reuse the existing `ai_clean` persistence lifecycle
and immutable parent/Creator Cut machinery; record the distinct analysis
configuration `continuity-rough-cut-v1`. Do not reinterpret historical results
or silently claim the old calibrated precision threshold for these proposals.

## Mapping and failure isolation

The model returns contiguous retained quotations and source row references.
The core ignores punctuation, whitespace and Unicode composition when matching,
but preserves every spoken word, repetition, quantity and negation. A quotation
must identify one unique continuous occurrence. Partial rows require exact saved
word anchors; never invent replacement timestamps or choose an ambiguous match.

Validate each passage independently. For an invalid quotation, unsupported timing,
or overlapping/out-of-order claim, keep the entire affected source rows and save
the exact withholding reason. Continue applying independent valid omissions.
An unlocatable row reference or an empty selection protects all speech while still
producing an inspectable result. Structural corruption, stale project context,
unparseable provider envelopes and storage failure still fail the operation;
previous successful cuts remain usable.

Trust structurally usable Doubao timestamps under the existing provider-trust
setting. Retain the optional acoustic-check capability. Localize unknown timing
and physically implausible multi-character timing of 20 ms or less as review
issues. Confidence values of zero cannot rank uncertainty.

Keep continuous source ranges between supported anchors within a passage, so word
spacing is not turned into an edit. Delete only supported omitted speech spans;
preserve visual/non-speech intervals by default. This can leave pauses between
removed utterances and produce many media segments. Pause shortening is separate
work requiring playback review and protection of useful visual context.

Update September 19: [ADR-109](ADR-109-enclosed-gap-default-removal.md)
supersedes this blanket preservation only for visible no-speech rows whose two
neighboring utterances are fully removed. Save a warning and preserve restoration.

## Review and persistence

Preserve all original rows and timestamps. Display excluded content, partial-row
kept ranges, original-row playback and retained-portion playback. Withheld
proposals show an orange `Needs review` note and an optional review-only filter.
Color is supplementary; the text states the reason. Flags are historical evidence
of the AI proposal, not a claim that a later creator edit is invalid.

Save raw provider output, parsed selections, mapping/withholding evidence and
usage in the versioned local analysis. Seal the new result and its cut atomically.
Never mutate an older AI baseline or discard an existing Creator Cut. The first
manual restore/remove creates a Creator Cut; subsequent edits support undo/redo.
The existing preview and approval gates still apply before export.

Offline loading requires exact agreement with the saved source sequence,
transcript, correction revision, rows and timing metadata. The experiment command
writes a fresh canonical backup using SQLite backup, never the source project.
No paid request or credential access is required to replay saved responses.
Private transcripts, raw responses and project copies remain locally ignored.

## Verification

Regression cases cover isolated bad quotations, punctuation-only differences,
ambiguous occurrence, reversed selections, implausible timing, empty/unknown
references, partial-row restoration, undo/redo, reopening, stale import rejection,
and preservation of older cuts. Saved Test23 responses provide local integration
checks; they are development examples, not an independent quality benchmark.
