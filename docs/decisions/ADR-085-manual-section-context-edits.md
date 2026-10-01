# ADR-085: Manual Story section and curated context edits

- Status: Accepted
- Date: 2026-09-17
- Scope: EC-12, implementing ADR-015 and ADR-060–062

## Decision

Explicit section and non-speech row inclusion commands reuse the atomic Creator
transaction, first-edit fork, range normalization, approval invalidation and
version-1 undo evidence. AI baselines, transcript timing, source media and take
membership remain unchanged. No schema migration is required.

Section targets resolve from the selected Story ancestry and its Clean baseline.
Removal rejects overlap with unrelated speech or explicit context, and rejects
unclassified gaps within the section. Such context requires its own explicit row
action; a section command is not permission to delete visual-only content.

Context commands resolve a visible row ID from the current authoritative transcript
projection inside the write transaction. Both shown stored spans and curated gaps
from completed transcription coverage are supported. Hidden spans, foreign IDs,
speech rows and untranscribed gaps are not context command targets. Callers cannot
submit arbitrary ranges. Display thresholds do not create automatic removals.

Removed rows remain visible, dimmed, source-playable and directly restorable.
Inclusion is projected from the selected resolved plan. Restoration and subtraction
retain original source chronology. Existing revision, pointer, media and session
guards apply, and every actual action appends Creator provenance.

Operation kinds are `remove_story_section`, `restore_story_section`,
`remove_context` and `restore_context`; context targets use `non_speech_context`
and the cut/transcript-scoped review row ID. No-op actions do not create history.
