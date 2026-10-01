# ADR-091: Captured-plan local MP4 exports

- Status: Accepted
- Date: 2026-09-17
- Scope: EC-16; implements ADR-018, ADR-055, ADR-073, ADR-089 and ADR-090

## Decision

The explicit export command checks the selected cut revision, matching preview and
approval hashes, and required-source readiness in one SQLite transaction. It writes
`export_record` and every ordered `export_segment` together. Rendering reloads this
captured plan and verifies its hash against immutable source identities; it never
reads the current cut's segments. Changing takes, editing the cut or switching
sequence pointers cannot change a requested export. Unused missing clips do not
block it. Existing schema-v2 tables suffice; no migration is required.

Each request transitions from requested to running once, then completed, failed or
cancelled. Duplicate execution does not claim or fail another running attempt.
Interrupted attempts are not automatically resumed; recovery is EC-17/EC-19.
Output records retain the external path, SHA-256 fingerprint, byte size, measured
duration and captured plan hash. Completion is separate from current cut approval.

The prototype renderer uses AVFoundation reader/writer with H.264 video and AAC
audio in MP4. This chooses a concrete local encoding path for EC-16; broader codec
and device coverage remains EC-19. Decoder/encoder or format failures fail the
request rather than substitute or normalize inputs. The validated composition is
shared with preview, including ADR-090 stereo fallback selection. Encoding consumes
decoded samples at their original composition presentation timestamps; it does not
set a fixed frame rate or apply a video composition. Source orientation is retained,
and PCM audio retains its timeline before AAC encoding. Output dimensions, audio
format and exact microsecond duration are checked before publication.

Sources are fingerprinted before assembly and after encoding. Only required clips
are opened. A changed or unreadable original fails the attempt. Temporary MP4s are
written in a unique sibling directory; the final file is published using an atomic
no-replace hard link, then temporary names are removed. Unsupported destination
filesystems fail safely. Existing files and symlinks are never replaced, original
source paths and locations inside the project package are rejected, and no original
media is edited or uploaded.

The database and external filesystem cannot share a transaction. If the MP4 is
published but the completion write fails, retain the output and report failure
with its requested path; do not delete a deliverable to conceal the error. A crash
can leave a requested/running record and disposable temporary output. No automatic
retry or broad cleanup is introduced in this slice.

The desktop export has an independent task and cancellation control. Editing may
continue once capture finishes. Cancellation before publication removes only the
attempt's staging directory; after publication, completion recording wins.

## Verification

Core tests cover approval/readiness, atomic capture, revision and range checks,
reopen, mutation during rendering, duplicate execution, failed/cancelled outcomes
and output validation. Real synthetic movies exercise multi-clip take plans,
decoded frame colours/order, frame timestamps (constant, mixed and variable),
orientation, audio energy/timing including offsets and tails, output fingerprints,
and no-overwrite publication. Fixture success is not broad codec/device validation.
