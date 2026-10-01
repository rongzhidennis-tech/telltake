# ADR-077: Persist transcription inputs, coverage, and cleanup

- Status: Accepted
- Date: 2026-09-15
- Scope: EC-04; implements ADR-006 and ADR-022–ADR-024

## Decision

The project transcription coordinator requires the current explicitly confirmed
sequence. It extracts each active source locally; extraction failures leave that
clip uncovered rather than changing sequence membership. The provider receives
audio bytes, opaque clip IDs, duration, language, and a stable job scope—never
original video paths or bytes. The real local adapter validates source identity
and exports audio-only M4A. Cloud encryption/provider selection remains EC-19.

Schema v3 records cached audio references, explicit per-clip transcript coverage,
and a cleanup state bound to a transcription job. Extraction and transcription
progress use the existing processing-stage table. A successful provider response
is validated, sealed atomically with utterances and word alignment, and made
inspectable. Missing coverage makes the result partial; it never implies an edit
or exclusion. Transcript editing is unavailable in this slice.

The provider owns all temporary cloud artifacts under the job scope persisted
before invocation. Its delete operation must be idempotent and cover partially
created uploads/jobs as well as successful jobs. Cleanup runs after durable
outputs return, or after a failed invocation is durably recorded. Cleanup failure
does not erase a transcript; pending/failed status remains available for explicit
retry. Provider implementations must not embed source content in errors; the
coordinator persists fixed failure codes only.

Failure-state persistence errors must not prevent an attempt to delete artifacts
using the previously persisted job scope. If storage also rejects the cleanup
result, retain the pending scope for explicit interruption recovery and cleanup
retry once storage is available.

An explicit retry creates a new run and may reuse the previous durable audio
cache when it is intact. Missing cache is regenerated from validated originals.
There are no automatic provider retries, chosen backoff intervals, or retention
duration promises. Interrupted runs remain visible; the caller must terminate the
old worker before explicitly marking an interrupted run failed. A superseded
worker cannot seal results after that transition. Cleanup can then be retried.

Completion preserves immutable history. It activates a new transcript only when
its sequence is still current and no newer successful transcription is already
active. Activation clears incompatible downstream pointers. Failure leaves all
previous successful results and source membership unchanged.

## Consequences

The portable coordinator and persistence commands are verified with deterministic
clients. Local extraction is separately verified with generated movie fixtures.
Real cloud wiring, authentication, and complete application integration remain
EC-19. Dataset collection still goes through EC-18A's registry; ordinary personal
editing is not dataset admission.
