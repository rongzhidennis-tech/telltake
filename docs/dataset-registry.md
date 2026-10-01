# Dataset registry operations

EC-18A implements the local collection boundary in `EasycutCore.DatasetRegistry`.
Use one registry for the entire development and held-out corpus, not one per
creator or project. This is an operator API; the ordinary macOS editing/import
screen does not enroll recordings in a research dataset. No real creator data
was used in its implementation or tests.

## Storage contract

The registry directory contains `registry.sqlite` and, by default, `artifacts/`.
The independent schema version is **1**, defined by
[`dataset_0001.sql`]. It is not
the project schema (currently version 7). Future
registry changes require new ordered migrations; do not rewrite version 1 once
it has shipped. Opening an unknown version fails.

| Table | Stored data |
| --- | --- |
| `dataset_registry` | Bound storage namespace identity |
| `dataset_item` | Stable pseudonymous creator identity and globally unique canonical source identity |
| `dataset_consent` | Independent purpose grant, evidence reference, grant and withdrawal timestamps |
| `dataset_admission` | Permanent item/purpose/split membership and consent reference |
| `dataset_artifact` | Purpose, parent lineage, pending/ready/deleted state; no content |
| `dataset_deletion`, `dataset_deletion_event` | Current cleanup state and ordered attempt history with fixed error codes |
| `dataset_annotation` | Immutable review revisions and attribution; annotation content lives in a controlled artifact |
| `dataset_manifest`, `dataset_manifest_entry` | Frozen candidate reference, version, ordered items, consent and annotation references |

Recording bytes, transcripts, feedback, and labels are only in controlled
artifacts. Every derivative inherits one item's purpose; cross-item composites
and cross-purpose promotion are unsupported. Split history and audit references
remain after withdrawal to prevent re-enrollment from erasing contamination.
Do not put transcript text, filenames, or other content in identity/evidence/
reviewer/configuration references. Use references to separately governed records.

## Collection workflow

1. Instantiate `DatasetRegistry(at:)` on an operator-controlled local directory.
   Run synchronous operations away from the UI and cooperative executor. The
   prototype reads/writes one artifact as `Data`; production large-file streaming
   and remote storage integration are not part of this ticket.
2. `registerItem(creatorIdentity:sourceIdentity:)` records identity only. Intake
   must reconcile creator aliases and verify a canonical source fingerprint,
   e.g. the full-file SHA-256 from the media inspector. Never use a filename or
   a freshly generated source ID to evade duplicate detection.
3. `grantConsent(item:purpose:evidenceReference:)` records explicit consent for
   evaluation or improvement independently. Repeat grants are idempotent and
   preserve the original evidence reference. A withdrawn grant cannot be restored.
4. `ingest(item:purpose:split:content:)` checks admission before invoking the
   content closure. Held-out admission accepts evaluation only. Development
   admission also requires improvement consent. A creator's previous admission
   to either split permanently blocks admission to the other split.
5. `read(_:purpose:)` rechecks current purpose consent and rejects held-out
   annotations and all their descendants with `frozenManifestRequired`, even
   after a manifest has been frozen. Use the manifest-scoped read below for
   held-out labels. Source media, non-label derivatives, and authorized
   development labels remain readable. `derive(from:purpose:)`
   keeps transcript, audio, and other derivatives under the parent's permission.
   Do not retain returned bytes or create untracked copies for later use.

SQLite transactions serialize admission/access against withdrawal, including
across registry instances. Storage callbacks must not reenter the registry.
An access already in progress finishes before withdrawal commits; after commit,
new access is denied. Bytes already handed to a caller cannot be recalled.

## Labels and frozen evaluation

`submitFeedback` stores the raw diff/provenance as an unreviewed artifact.
`reviewFeedback` produces a new attributed revision, classified as AI error,
preferred take, style preference, or other editorial change. Verified revisions
require explicit creator-intent confirmation. Keep unresolved disagreements in
the annotation content with their reason; do not mark them verified.

`freezeEvaluation(items:candidateReference:)` requires held-out admission and
freezes the latest annotation revision for each item. The candidate reference
must identify the already frozen model/provider, prompt, and thresholds. Missing,
unreviewed, and unresolved labels stay in the manifest but `isScored` is false.
`readScoredAnnotation(manifest:item:)` rejects those entries and reads only the
exact verified revision captured by the manifest. Later reviews do not alter old
manifests. Both manifest opening and scored reads recheck consent; a withdrawn
member invalidates use of that manifest. EC-18 adds `evaluationReport` for
versioned reviewed session payloads, using the same frozen-manifest authorization
boundary. See the [evaluation protocol](evaluation-protocol.md). Synthetic fixtures
never establish a measured product-quality pass.

## Withdrawal and recovery

`withdraw(item:purpose:)` commits revocation and a deletion queue before deleting
any artifacts for that purpose. This includes controlled originals, all descendant
artifacts, feedback, and annotation revisions. A different purpose's copies remain
usable if its own consent is active. Pending writes are tracked before bytes are
written, so a failed or interrupted ingestion remains covered by withdrawal.

Inspect `deletionStatus` and `deletionHistory`. Failed removal reports
`storage_deletion_failed`, with no content or underlying exception text. After
fixing storage access, call `retryDeletion`; completed removals are not repeated.
A process interruption leaves durable pending/failed work for the same retry.

The registry binds the `DatasetArtifactStorage.storageIdentity` at creation and
rejects another namespace on reopen. Adapters must faithfully implement that
identity and idempotent removal, including all copies they control. The default
file adapter is bound to its absolute directory. Moving a registry/storage root
requires a future explicit relocation workflow; silently choosing another path
cannot satisfy deletion. There are no automatic backups or exports. Operator-made
backups, external copies, and production authentication require their own controlled
workflow before real-data collection. This local API is not a security boundary
against a user with direct filesystem/database access.
