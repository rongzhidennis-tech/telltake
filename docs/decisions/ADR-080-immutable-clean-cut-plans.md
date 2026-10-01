# ADR-080: Materialize conservative immutable Clean Cut plans

- Status: Accepted
- Date: 2026-09-16
- Scope: EC-07; implements ADR-003, ADR-014, ADR-043, ADR-063, ADR-073

## Decision

Materialize one ready, sealed AI Clean Cut from a sealed successful EC-06 Clean
analysis. Start with the complete active source clips in confirmed order. Apply
only validated high-confidence take-selection recommendations; exclude the exact
stored ranges of nonpreferred utterances. Do not extend exclusions into adjacent
silence, snap boundaries, remove words, or infer mechanical exclusions from missing
text. Boundary adjustment and real-media snapping belong to EC-12A. EC-06 currently
produces take selections, not independently validated false-start/dead-space events;
unsupported recommendation types fail validation rather than gaining authority.

Recheck the semantic/progression/confidence/coverage policy and the normalized
group, candidate, preferred-member, and target relationships before applying a
selection. Inconsistent evidence fails the transaction. An exclusion overlapping
another utterance, an explicit non-speech span (shown or hidden), or a Possible
alternatives member defers the entire group. Unknown and standalone visual spans
are preserved. Remaining source ranges are coalesced per clip without changing
chronology; they must fit the immutable source duration and currently validated
source availability. Availability is revalidated by the media adapter before
preview/export; generating a plan does not grant playback approval.

Persist cut metadata, ranges, applied/not-applied recommendation links, a succeeded
generation stage, and eligible current-pointer changes in one transaction. The
hash is SHA-256 over versioned deterministic JSON containing each ordered range,
source ID, fingerprint algorithm/fingerprint, and recorded source duration. Paths,
timestamps, random cut IDs, and review status do not affect the hash. Duration
arithmetic is checked for overflow. No schema change is required.

Creation is idempotent: subsequent calls return the existing sealed plan without
rewriting or reactivating it. Public snapshots have immutable fields and there is
no baseline-edit command. Sealed analysis/recommendation edits remain rejected by
their existing services. This is a transaction/service invariant, not protection
against arbitrary direct SQLite tampering. Creator editing is EC-08 and later.

Activation follows ADR-073 request-time ordering (run ID breaks ties). Only a cut
matching the current sequence and transcript can activate; older completion cannot
displace a newer successful Clean result. Preserve the active Creator Cut and
saved corrections; clear the selected Story pointer when the selected Clean run
changes. Failed generation leaves all pointers and previous cuts unchanged.
Transcripts from other current contexts remain historical rather than being
silently switched by background completion.

Inspection exposes selected/excluded utterance states without deleting transcript
rows or source ranges. The desktop viewer remains read-only; switching/restoring
takes requires the later Creator Cut workflow. Uncertain relationships do not
collapse rows or become exclusions.
