# Take-group review and editing (EC-11)

Transcript review now shows confirmed groups as a preferred row with **Take N of N**.
Choose **Show / hide alternatives** to expand every candidate in source order.
Select a candidate in the comparison picker and use **Play candidate** for original
source playback. Excluded rows stay dimmed and retain the separate **Keep / restore**
action. Source availability is revalidated before playback and editing.

**Choose this take** includes that complete utterance and excludes other current
members, preserving chronology and surrounding content. It rejects overlaps that
would delete another object. The first change forks the selected AI baseline.

Possible alternatives stay separate, with relationship badges and comparison controls.
Choose a candidate explicitly before **Group (keep inclusion)**. The resulting
Creator-confirmed group has an explicit preference but does not silently exclude its
other members. Use **Choose this take** separately when selection is intended.
**Ignore suggestion** dismisses only that recommendation in that analysis run.

**Add selected transcript row** and **Remove candidate from group** edit membership,
not video inclusion. Removing the preferred member prompts for a replacement if the
group will still contain at least two members. A smaller group dissolves; its utterances
remain visible and keep their existing included/excluded states. One utterance cannot
belong to two current groups. An overlapping suggestion can still be inspected or
ignored, but cannot be confirmed until the conflict is resolved. Editing or dissolving
a group preserves separate overlapping suggestions; when their members become free,
those suggestions become confirmable. Confirming one suggestion overrides only that
relationship. Menu entries use distinct labels and stable group/suggestion identities,
so repeated preferred-take badges do not hide entries or redirect actions.

## Integration

`editingReview(at:)` includes take groups and suggestions in the same read snapshot as
the displayed cut revision and transcript. `takeGroupReview(at:cutID:)` is also available
for a selected cut. Its `visibleRows(_:expanded:)` is the tested collapsed/expanded
projection used by the desktop; UI code does not choose or alter source ranges.

`editTakeGroup` accepts an explicit `TakeGroupEdit`, expected revision/current Creator
pointer and optional editing session. `ignorePossibleAlternatives` performs only
run-scoped review. Run these synchronous store operations through `ProjectStoreIO`.
No command modifies AI groups, candidates, recommendations or baseline plans.

Undo/redo supports group operations after reopening. Version-2 edit evidence stores
membership and preference alongside the plan; existing version-1 utterance/Story edits
remain compatible. Membership-only edits still advance the revision and invalidate
approval. Current group reads use normalized tables, not history replay.

See [ADR-084](../decisions/ADR-084-creator-take-group-editing.md) for the transaction,
provenance, safety and verification contract.
