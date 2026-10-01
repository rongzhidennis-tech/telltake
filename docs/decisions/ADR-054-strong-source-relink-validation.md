# ADR-054: Validate relinked clips with strong source identity

- Status: Proposed
- Date: 2026-08-27

## Context

Filenames and capture timestamps can change during transfer, export, or processing by other apps. Attaching the wrong local clip to a project could produce incorrect previews or exports while appearing superficially valid.

## Decision

Relinking requires a strong source-identity validation using a stable content fingerprint together with key media metadata such as duration, dimensions, frame rate, and audio characteristics where available. Filename, path, and timestamps may suggest likely matches but are not sufficient proof.

If validation fails or remains ambiguous, the clip stays unresolved and source-dependent preview/export remains disabled for affected ranges. The app must not silently substitute a plausible file.

## Consequences

- Relinking may require time to inspect or fingerprint a large video file.
- The project must store enough source identity metadata to validate later without relying on path stability.
- The UI needs clear match, mismatch, and ambiguous states.
- Source identity must remain independent from disposable cache identity.

## Session reuse for local editing (2026-09-18)

Routine desktop edits may reuse a successful full inspection within the service
lifetime. On local filesystems the cache checks device, inode, generation, size,
nanosecond modification time and nanosecond change time before reuse. These are
change detectors, not identity evidence: the cached fingerprint and media metadata
still have to match the immutable source. Missing files, in-place writes, path
replacement and relinking cannot use stale evidence. Unsupported/remote filesystem
stamps fall back to full inspection. The cache holds at most 256 descriptors and
is never persisted. Inspection brackets its work with change checks.

Opening, explicit relinking, approval and export keep authoritative full checks.
Routine unchanged validation avoids duplicate source audit writes. After an edit,
one read transaction refreshes the affected cut, history and controls; other cuts
and the transcript stay loaded. Revision checks and atomic edit persistence remain.

Preview preparation shares the same cache as routine editing. A session generation
changes when a cached source changes or entries are evicted; prepared previews
capture this generation and reject reuse when it differs. Completion checks source
availability with this reuse policy and the captured generation. Explicit approval
and export still perform full authoritative inspections.
