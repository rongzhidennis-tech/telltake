# ADR-081: Fork an AI baseline on the first utterance edit

- Status: Accepted
- Date: 2026-09-16
- Scope: EC-08; implements ADR-010, ADR-011, ADR-063, ADR-064, ADR-073

## Decision

An explicit keep/remove/restore command names the selected cut, expected plan
revision, expected current Creator Cut pointer, and immutable utterance ID.
The source must be a ready sealed AI Clean/Story baseline or a Creator Cut with
one valid AI parent. Its sequence/transcript must match the current project.
Story ancestry must match its exact Clean run, transcript and correction context.
An unchanged action is a no-op: it does not fork, append history, or invalidate
approval. A real edit of an AI baseline creates a fresh Creator Cut; selecting
another baseline never overwrites previous Creator work. Subsequent commands name
the returned Creator Cut. Revision and pointer checks reject concurrent stale edits.

Edit exact whole-utterance source ranges, using subtraction for remove and union
for keep/restore. Preserve surrounding gaps and source chronology. Reject removal
overlapping any other utterance or explicit non-speech context, rather than
silently affecting those objects. Validate the original plan, target ranges and
new plan against source identity, bounds and available media. Use ADR-080's hash.

In one transaction, fork metadata and inherited recommendation applications when
needed; seed current Creator group/member/preference rows from applied take
selections; replace the full plan; increment revision; update duration/hash;
invalidate Creator preview/approval; append version-1 before/after plan provenance;
and select the Creator Cut. AI metadata, ranges, recommendations and approvals
remain unchanged. No media is copied or deleted.

Recommendation overrides are cut-local: affected inherited application links
become `overridden` with creator decision source and no selected candidate.
Global recommendation review status is not silently accepted/rejected by a
basic utterance edit. Group membership/preference is separate from inclusion and
remains intact; take switching/membership edits belong to EC-11. Persisted before/
after evidence includes the plan and application states for later undo, but this
ticket does not implement undo/redo or infer feedback as ground truth.

The desktop viewer offers explicit Clean/Story/Creator selection and whole-row
Remove/Keep–restore actions. Rows stay visible and individually source-playable.
Readiness/media and stale-context gates are enforced again at commit. Live Story
generation remains EC-10; a seeded valid Story baseline verifies this parent path.

No migration is needed: schema v3 already includes Creator groups, plan revisions,
recommendation applications, approval state and append-only edit operations.
