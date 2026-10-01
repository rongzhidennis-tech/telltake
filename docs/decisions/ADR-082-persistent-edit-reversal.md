# ADR-082: Reverse Creator edits through append-only operations

- Status: Accepted
- Date: 2026-09-16
- Scope: EC-09; implements the adopted undo/redo contract in ADR-064 and ADR-065.

## Decision

Undo history belongs to each Creator Cut. The ordered operation log determines
which edits are still applied: an ordinary utterance edit pushes an undo step and
clears redo; `undo` pops that step and appends an inverse operation referencing it;
`redo` inverts the latest undo operation and becomes the next undo step. Original
records are never changed or deleted. AI generation is not an undo step.

A desktop transcript-review window owns one fresh `edit_session` ID until it
closes. Reopening creates a new ID, never resumes a stored one, including after
a crash. Undo remains available across sessions, while redo requires an unbroken
path of undo operations from the requesting session. An intervening operation on
that cut by another session discards the old redo path. A new actual edit clears
redo; a no-op does not. Histories of separately forked Creator Cuts are independent.

Version-1 evidence from EC-08 contains the full range plan and cut-local
recommendation applications. Reversal validates its version, cut ancestry,
current-state match, source bounds/availability, hash/duration, recommendation
identity and selected candidates. Unknown operation kinds/evidence fail closed.
Commands require the displayed revision, current Creator pointer and current
sequence/transcript. Closed or foreign-project sessions cannot write.

Undoing the first edit retains the Creator Cut identity and its seeded group
membership but restores the selected AI parent's plan and application states.
Utterance inclusion edits never changed group membership/preference, so their
inverse does not change it either. Future group-edit tickets must introduce
explicit evidence and reversal support rather than reuse range-only evidence.

Ordinary edits, undo and redo share the plan/provenance writers. In one immediate
transaction they replace all segments, advance revision, restore duration/hash
and application state, clear preview/approval, update the current Creator pointer
and session activity, and append provenance. Undo does not restore an old approval
or decrement the revision. Failure rolls back the entire command.

## Consequences

Existing schema-v3 tables suffice; no migration or persisted active flag is needed.
Undo controls inspect history, but opening, reviewing and rendering current state
continue to read materialized projections without replaying history. Sessionless
EC-08 callers remain supported for ordinary edits; reversal requires an explicit
active session. Store calls run off the UI executor through `ProjectStoreIO`.
