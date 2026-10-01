# Creator Cut operations (EC-08–EC-09)

In the transcript review window, choose AI Clean Cut, AI Story Cut (when present),
or Creator Cut. Select an utterance and choose **Remove utterance** or
**Keep / restore**. The first actual change to an AI baseline creates a Creator
Cut automatically, and the viewer selects it for subsequent edits. Excluded rows
remain visible and source-playable. EC-12 also supports visible non-speech rows.
The AI baselines and original media are never changed.

The persistence API is `editingCut(at:id:)` followed by
`setUtteranceIncluded(at:cutID:expectedRevision:expectedCurrentCreatorCutID:utteranceID:included:)`.
Pass the displayed revision and current Creator pointer; stale commands fail
without writing. Run synchronous store work through `ProjectStoreIO` as the desktop
service does. The service revalidates source availability before committing edits.

Both sealed ready Clean and valid Story baselines are supported. Story ancestry
must match the exact parent Clean run and transcript/correction context. A selected
Creator Cut must have a valid single AI parent. Editing requires the current
sequence/transcript, validated source ranges and an intact plan hash. Selecting
an AI baseline again starts separate work on the next edit and preserves prior
Creator Cut history. No-op keep/remove actions do not fork or append operations.

Remove subtracts exact utterance ranges, preserving intervening and surrounding
content. Keep/restore unions the complete utterance into the plan in source order.
Removal overlapping another utterance or explicit non-speech span is rejected.
Whole-row commands do not trim boundaries, reorder content or delete sources.

Every actual edit atomically writes the resolved plan, revision, duration/hash,
cut-local recommendation overrides, cleared Creator approval, current Creator
pointer and append-only provenance. First-edit creation also seeds current group
membership/preference from the chosen baseline's applied take selections. Group
membership remains independent of inclusion. Global recommendation review states
are not silently accepted or rejected by this command.

`edit_operation` evidence version 1 captures before/after source ranges, revision,
duration/hash, source/target cut identities, and recommendation application states.
Existing AI approvals and plans stay intact. EC-11 now provides take switching and
group edits through [take-group operations](take-group-workflow.md). EC-10 provides Story
generation and atomic section restoration; see [Story Cut operations](story-cut-workflow.md).

Tests cover Clean and Story parent paths, reopen/remove/restore, separate forks,
no-ops, stale views, missing sources, foreign utterances/recommendations, overlap
rejection, approval invalidation, and rollback after a provenance write failure.
See [ADR-081](../decisions/ADR-081-creator-utterance-edits.md).

The desktop loads `editingReview(at:)` to obtain transcript rows, cut snapshots,
and the current Creator pointer in one SQLite read transaction. Use its displayed
revision and pointer for subsequent edits, with an `UtteranceID` for the target.
Concurrent edits or sequence changes are visible on the next load, never as mixed
state within a view. Review and cut operations share source-range validation
independently of display-row construction.

## Persistent undo and session-scoped redo

Choose **Undo** (Command-Z) or **Redo** (Shift-Command-Z) while viewing a Creator
Cut. The window starts a fresh editing session and closes it when dismissed.
Undo survives closing/reopening; redo does not. A new actual edit after undo clears
that cut's redo path, while a no-op leaves it intact. An intervening edit or reversal
from another session also invalidates the previous session's redo path.

Core clients call `beginEditSession(at:)`, pass its ID to edits, `editHistory`,
`undoEdit` and `redoEdit`, then call `endEditSession`. Never persist/reuse that ID
on reopening a UI. The history query takes the displayed revision; reversal takes
both that revision and the current Creator pointer, just like an ordinary edit.
Existing sessionless ordinary-edit clients remain compatible.

Undo/redo append new operations linked through `inverse_of_operation_id` and advance
the plan revision. They restore exact saved ranges, duration/hash and recommendation
applications, invalidate approval and update the current Creator pointer atomically.
Undoing the first edit retains the Creator identity and seeded groups but restores
its parent's plan. AI baselines, analysis results, group membership and global review
decisions are untouched. Unsupported or inconsistent evidence, stale state, missing
required media and closed/foreign sessions fail without a partial edit.

Tests exercise the complete ticket sequence, repeated undo/redo, legacy sessionless
edits, competing sessions, provenance preservation, recommendation restoration,
approval invalidation, corrupted history and transaction rollback. See
[ADR-082](../decisions/ADR-082-persistent-edit-reversal.md).

## Manual sections and visual context (EC-12)

Select a Story section and choose **Remove section** or **Restore section**.
Select a visual/no-speech row and choose **Remove context** or **Keep / restore**.
Excluded rows stay dimmed and source-playable. These explicit Creator actions never
change AI preservation rules. Section removal rejects unrelated speech, visual
context and unclassified gaps; context must be removed through its own row action.

Store clients use `setStorySectionIncluded` and `setNonSpeechContextIncluded`,
passing the displayed revision, Creator pointer and session. Context row IDs resolve
against the current transcript in the same transaction; hidden/nonexistent rows
cannot be targeted. Both saved shown spans and curated completed-coverage gaps work.
Every actual edit supports persistent undo, session-scoped redo and direct restore.
See [ADR-085](../decisions/ADR-085-manual-section-context-edits.md).

## Utterance boundaries (EC-12A)

Select an included utterance and choose **Adjust boundaries…**. Enter source-local
seconds for the start in its first source range and the end in its last range.
The dialog starts with the currently retained boundaries. Changes snap to actual
video frame boundaries; **Restore boundaries** restores both immutable endpoints.
For a single range, start must precede end. Every range stays nonempty, interior
ranges/gaps are untouched, and excluded rows must first be kept/restored. A cut
with interior holes cannot be reshaped with boundary controls.

`ProjectBoundaryCoordinator.adjust` reads a consistent edit snapshot, asks an
`UtteranceBoundaryClient` to validate/snap the source ranges, and commits through
the existing Creator transaction after rechecking revisions and source locations.
The desktop uses `AVFoundationBoundaryClient` for fingerprints, actual output frame
timing and decoded PCM coverage; this local validation can take time on long clips.
Nil endpoint parameters restore the corresponding original endpoint. Undo/redo
preserve exact committed ranges across reopen without modifying word alignment,
transcript ranges, AI plans or take membership. See
[ADR-086](../decisions/ADR-086-conservative-boundary-adjustments.md).
