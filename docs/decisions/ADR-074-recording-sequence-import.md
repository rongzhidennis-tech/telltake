# ADR-074: Make recording-sequence commands deterministic and atomic

- Status: Accepted
- Date: 2026-09-12
- Scope: EC-02 implementation
- Amends: ADR-035 and ADR-067 (ordering and revision details); ADR-072 (Apple deployment minimums)

## Decision

`ProjectPackageStore` accepts inspected source descriptors (path, fingerprint,
media facts, optional capture and file-creation times). EC-02 supplies the portable
import model; EC-02A connects real media inspection and the macOS clip list.
Locations start `unvalidated`; receiving a descriptor does not prove media availability.

Within each import batch, use capture time when present, otherwise file-creation
time. Sort dated clips first by that time; preserve input order for ties and for
undated clips. Preserve this evidence separately from the creator's order. Append
later batches in their inferred order without rearranging existing membership.
Creators can explicitly reorder the entire list before confirmation.

The existing unique `(project, fingerprint, algorithm)` source identity constraint
defines duplicates. Reject the entire batch with `duplicateSource` if any source
already exists, including duplicates within the same batch. Do not silently relink,
overwrite metadata, or add another membership for the same identity. The creator
can restore an excluded existing source or remove the duplicate from the batch.

Each actual order/inclusion change or additional import creates a new numbered
draft revision, even before confirmation. No-op edits return the existing revision.
Confirmation seals that draft in place; repeat confirmation is idempotent. At least
one active clip is required. Excluded clips retain their position and source identity.
Historical revisions remain readable with their original membership, including
confirmed revisions after a new draft is selected. Historical membership reads
join current locations; source identity and original metadata remain immutable.

Commands require the expected current revision (nil for first import), checked
inside a SQLite write transaction. A stale command fails without changes. Draft
creation selects the new revision and clears all dependent current transcript,
correction, analysis, and cut pointers per ADR-073, retaining the referenced history.
All source/location inserts, membership rows, and pointer changes commit together.
These lifecycle rules are enforced at the store boundary; no raw database handle
is exposed to callers. Existing schema v2 already supports this slice.

The sequence hash is SHA-256 over UTF-8 JSON arrays in membership order. Each array
contains source ID, `active`/`excluded`, fingerprint algorithm, and fingerprint.
Use Foundation JSON serialization without formatting options. Confirmation does
not change this content hash. Hashing uses CryptoKit, with package deployment
minimums macOS 10.15 and iOS 13; the core has no UI or media-framework dependencies.

## Verification

Public store tests use temporary SQLite packages and deterministic media descriptors.
They verify inferred order, reopen, revision history, source-file preservation,
batch rollback, duplicate rejection, stale commands, empty-active-set rejection,
project isolation, and dependent-pointer invalidation without history loss.
