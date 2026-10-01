# Durable project transcription

EC-04 provides `ProjectTranscriptionCoordinator` and `ProjectPackageStore`
commands. The EC-00 `MinimalProjectWorkflow` remains a seam demonstration and is
not used for durable project processing. Desktop wiring and live provider
integration are complete (EC-19); transcript review UI is EC-05. The shipped
provider is Doubao Turbo ([ADR-106](../decisions/ADR-106-doubao-transcription-review-evidence.md))
with bounded concurrency and durable checkpoints ([ADR-110](../decisions/ADR-110-transcription-progress-and-concurrency.md)).
The user-level consent gate of [ADR-093](../decisions/ADR-093-user-level-cloud-processing-consent.md)
is implemented in Cloud settings; live dispatch stays blocked until the user agrees
in-app and a Doubao key is saved.

## Run and inspect

Construct the coordinator with `ProjectAudioExtractionClient`,
`ProjectTranscriptionClient`, and an immutable `TranscriptionConfiguration`.
`AVFoundationAudioExtractor` is the real local adapter. It validates the original
fingerprint and metadata, exports audio-only M4A, and checks identity again after
extraction. Export runs away from the cooperative executor. Temporary extraction
files are removed before returning audio bytes.

Call `start(at:sequenceID:)` for the current explicitly confirmed sequence.
Alternatively, call `requestTranscription` first to obtain the durable run ID,
then `execute`. The store rechecks the current sequence inside its request
transaction, and a run can be claimed only once. The snapshot API
`transcription(at:run:)` and `transcriptionRuns(at:)` exposes durable stage
progress, failures, cleanup status, transcript output, and missing coverage.

The coordinator dispatches synchronous persistence, cache I/O, and hashing onto a
dedicated queue, including provider progress callbacks. Snapshots expose typed
run, stage, and cleanup states. Claiming a requested run rechecks the current
sequence atomically; a stale request commits failed stages with `stale_sequence`
before returning, without invoking extraction or the provider.

The provider receives ordered audio bytes, MIME type, duration, opaque clip IDs,
language/model configuration, and a job ID. It receives neither source filenames
nor video paths. It must encrypt data in transit and at rest and own every upload
and temporary artifact under that job ID, including artifacts created before an
exception. `deleteTemporaryArtifacts(for:)` must be idempotent. The deterministic
test adapter verifies this contract; it does not claim real cloud encryption.

The local adapter's selected M4A encoding is a transcription input only; it does
not alter original video or define export encoding. Cached audio is disposable
under `cache/transcription/`. Provider inputs currently load one audio batch into
memory; streaming/provider limits are integration work for EC-19.

## Coverage and immutable results

The provider reports `completedClipIDs`, including successfully processed clips
with no speech. Every omitted active clip is explicitly unresolved. Extraction
failures may leave a partial batch; a completely empty batch fails before upload.
An utterance has a clip-local source range and ordered word alignment. The store
rejects unknown clips, out-of-bounds or out-of-order ranges, empty speech/word
text, overlapping words, and invalid confidence values before committing output.

One transaction seals the transcript version, utterances, ranges, word alignment,
clip coverage, and transcription stage. Speechless successful coverage can have
zero utterances. Partial output is inspectable, never an instruction to exclude
missing content. Source membership is untouched. `ProjectTranscript.isEditable`
is false: editing eligibility after Clean Cut readiness belongs to later slices.

Successful activation requires the same current sequence and no newer successful
run already active. Prior sealed versions stay immutable. A new transcript clears
incompatible analysis/correction/cut pointers; failures preserve prior results.

## Failure, retry, and cleanup

Cleanup ownership is durable before any provider call. After sealing output—or
recording a failed/cancelled invocation—the coordinator attempts cleanup even if
the caller was cancelled. Cleanup failure leaves the run's transcript intact and
sets `cleanupStatus` to `failed`. `retryCleanup` can be called after reopening;
it uses the same provider/model configuration and persisted run scope.

If recording a provider failure itself fails, the coordinator still attempts
deletion using the already persisted job scope and reports the persistence error.
If the cleanup-status write also fails, its durable pending status remains for
recovery. Once storage is available and the worker has stopped, mark the run
interrupted and retry cleanup; deletion is idempotent.

`retry(at:run:)` is explicit and creates a new run from a failed one. It reuses
cached audio only when its SHA-256 verifies; missing or corrupt cache is extracted
again. There is no automatic retry policy. Successful extraction progress stays
durable when the provider fails. Diagnostic stage errors are fixed codes rather
than provider messages or transcript content.

If a process stops mid-run, the stored processing state remains visible. After
terminating the old worker, call `markTranscriptionInterrupted`, then retry cleanup
and/or transcription. The old run cannot seal after being marked failed. Do not
mark a live remote worker interrupted and assume its uploads have stopped; live
provider cancellation/reconciliation must honor the job-scope contract in EC-19.

## Persistence and verification

[Migration 0003](../schema/migrations/0003_transcription.sql) upgrades project schema
v1/v2 to **v3** without changing existing transcript rows. `transcription_job`
stores request order and cleanup state; `transcription_audio` stores hashed cache
references; `transcript_clip_coverage` records complete/unresolved source IDs.
Older transcripts remain readable by their existing consumers; these new
coordinator snapshots apply to EC-04 jobs, not historical fixture-only runs.

Run `swift test --disable-sandbox` and `python3 scripts/check_schema.py`.
The real extraction test requires access to macOS media services; an outer agent
sandbox may reject AVFoundation export even though SwiftPM sandboxing is disabled.
Deterministic tests validate policy and recovery, not speech recognition quality.
