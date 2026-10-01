# ADR-084: Review and edit Creator take groups independently of inclusion

- Status: Accepted
- Date: 2026-09-16
- Scope: EC-11; implements ADR-038–043 and ADR-073's current-group invariants;
  extends ADR-082's undo evidence to group edits.

## Decision

Read group/member/preference state directly from current Creator tables, not by
replaying edit history. AI cuts project their applied immutable take selections.
Candidates are always ordered by confirmed source chronology. Collapsed groups
show the preferred take and total count; expansion reveals every candidate,
including exclusions, with existing revalidated source playback and restore controls.
Creator-confirmed groups are labeled distinctly from AI-created relationships.

Possible alternatives remain visible separate rows and do not cause selection or
exclusion. Their comparison controls expose chronological candidates. Confirmation
requires an explicit preferred member and creates a Creator group with a normalized
provenance link to the suggestion. Confirmation establishes membership/preference
only; it does not alter cut inclusion. The separately named **Choose this take**
action keeps the complete chosen utterance and excludes the other current members.
It rejects removal overlapping other utterances or visual/non-speech context.

Adding/removing a member also leaves inclusion unchanged. Members must belong to
the cut's exact transcript, appear in source order, and belong to at most one
current group. Removing the preferred member of a surviving group requires an
explicit replacement. Below two members, dissolve the group without changing the
plan. Detached excluded rows remain independently visible/restorable. Suggestions
overlapping an occupied member remain inspectable/ignorable but cannot be confirmed
until the membership conflict is resolved; no implicit group merge occurs.

Ignore is a separate, non-applying run-scoped review command for a linked Possible
alternatives recommendation. It updates review state and appends a review event,
without forking or changing plans. New runs retain their own independent suggestions.
Confirmation and membership edits record cut-local overrides, not a global acceptance
of the suggestion across every cut. Undo therefore does not rewrite another cut's
review decision or erase a later Ignore.

## Atomic edits and undo

Commands validate expected revision/current Creator pointer, current sequence and
transcript, session ownership, members and required source availability. AI edits
fork through the shared Creator helper; the selected AI parent never changes.
Group state, full plan, revision/duration/hash, application overrides, cleared approval,
current Creator pointer and append-only provenance commit together, even for a
membership-only edit whose plan hash remains unchanged. Actual no-ops do not fork.

Group commands use edit evidence version 2, adding complete group IDs, optional AI
origins, source-ordered membership, explicit preference and creation timestamps to
the existing plan/application evidence. First-edit before evidence captures the
seeded Creator identities. Undo/redo restores these normalized rows transactionally
and validates membership/context before writing. Version-1 range-only operations
remain readable and leave group state unchanged, so mixed old/new history reverses
correctly. Invalid or unknown evidence fails closed. Current-state reads never need
the operation log. Existing schema-v3 tables suffice; no migration is needed.

## Verification

Three-candidate and Possible alternatives fixtures verify collapsed/expanded rows,
individual source-playback eligibility, explicit selection/confirmation, Ignore,
add/remove/replacement/dissolution, separate inclusion restoration, reopen, mixed
undo/redo, no-op behavior, immutable AI rows, stale/foreign/missing-media/overlap
guards, corrupt evidence rejection and complete rollback. Desktop controls route
through the same core commands and `ProjectStoreIO`; full-cut playback remains EC-15.
