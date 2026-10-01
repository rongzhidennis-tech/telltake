# ADR-092: Canonical backups and non-destructive recovery inspection

- Status: Accepted
- Date: 2026-09-18
- Scope: EC-17; implements ADR-049–055 and preserves ADR-075/091

## Decision

The explicit desktop backup command creates a new `.easycut` package containing
only `manifest.json` and `state.sqlite`. SQLite's online backup API captures
committed state, including a live write-ahead log; copying an open database's main
file alone is unsafe. The destination is reopened in rollback-journal mode and
checked to be standalone, with no required WAL. An unused destination SHM sidecar
is removed only after its connections close. Source files are never modified.
Existing destinations and destinations inside the original package are rejected.
A failed backup removes only the new directory owned by that command. The backup
retains project identity, history, pointers and source/export references; it does
not copy originals, caches or rendered outputs.

Ordinary open does not require or reconstruct caches or exports. A read-only
recovery report distinguishes missing/corrupt disposable audio caches from missing
original media and missing/changed export files. Export status is an observation,
not a mutation of its historical completion record: completed output references
are checked by full-file SHA-256 and size. Unreadable files, legacy references
without identity evidence, and unfinished attempts remain explicit. No filename
search, automatic replacement, export regeneration, attempt resumption, cloud
request or provenance reconstruction runs on open.

Streaming hashes run off the UI thread and check file identity, size and modification
time across reads. Report generation does not hold a database read transaction
while hashing files. Reports reflect a point-in-time observation and can be refreshed
explicitly using Recovery status. The app performs this inspection on open and
explicit refresh, not after each edit/reorder. No schema migration is required.

Source availability continues through the existing exact-identity inspection and
explicit relink commands. Canonical transcript/analysis/edit inspection remains
usable with missing media; only source-dependent operations are gated. Original
media must be backed up separately. Existing lazy audio-cache regeneration is
used when a separately requested transcription operation needs it; sealed transcript
results do not need regeneration merely because a cache was discarded.

Crash/interrupted-job reconciliation and automatic filesystem cleanup remain
outside this slice. In particular, a failed or running export is reported without
assuming another window's active render has stopped. Backups are usable only after
the command reports success; no cross-filesystem crash-atomic publication is claimed.

## Verification

Canonical-table comparisons cover caches/exports omitted from a WAL-backed backup,
history, cuts, edit provenance and pointers across reopen. Disposable-audio and
missing/moved/changed/legacy export checks leave the database unchanged. Real
synthetic-media tests restore a genuinely exported project, lose its export and
one original, reject a wrong relink, then accept the fingerprint-matching moved
original without changing saved plans or export history.
