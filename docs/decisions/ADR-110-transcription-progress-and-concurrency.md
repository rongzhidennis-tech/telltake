# ADR-110: Saved transcription progress and bounded Doubao concurrency

**Status:** Accepted and implemented, 2026-09-19 (Point 8).

## Decision

Use up to two independent Doubao Turbo requests concurrently. Cloud Settings
offers one or two; a change applies to the next run. Keep the existing model,
request options, native-audio preparation and selected timing-trust policy.
Concurrency is execution metadata, not an ASR configuration change, so it does
not invalidate compatible saved results. This supersedes ADR-106's one-at-a-time
preparation implementation. No multi-file API body, new chunking, VAD or model
change is introduced.

Checkpoint every completed clip before refilling its slot. Preserve source
chronology even when responses arrive out of order. A provider or persistence
failure stops new dispatch and drains successful work already in flight to
checkpoint. Cancellation or revoked authorization can cancel in-flight requests;
previously committed results remain reusable. No automatic paid retries occur.
Explicit retry retains the existing source, configuration and checkpoint
validation. Explicit no-speech results count as completed clips with review notes.

Cached compressed inputs are file-backed. Decoded audio preparation occurs only
in occupied slots. A conservative combined 100 MB PCM estimate can reduce the
limit to one for large clips. This bounds the scheduler's audio working budget,
not total process memory: encoded request bodies and framework buffers add overhead.

## Progress and UI

Persist a transcription progress snapshot in the transcription processing stage's
existing `output_ref_json`; no database migration is required. It contains phase,
times, total/prepared/saved/reused clips, audio durations, active/validating/failed
ordinals and observed throughput. It contains no audio, transcript or credential.
Older projects without this metadata continue to open. Run lifecycle overrides
stale snapshot phase after crash recovery or sealing. Reject older event writes.

Show preparation separately from transcription. Confirmed percentage uses saved
audio duration, not clip count. Advance only after a durable clip checkpoint;
cap at 99% until sealing succeeds. Incomplete audio coverage is explicitly shown
as unresolved, never 100%. Empty no-speech transcripts count as completed coverage.

Show elapsed time, current clip ordinals, reused results, failure guidance and a
Stop transcription action. Estimate remaining time from smoothed observed
throughput only after two newly completed clips. Show “Estimating time…” earlier;
display a broad minute range that widens on stalls. This is an estimate, not
provider-reported progress within a request. Animate confirmed changes and keep
the activity spinner; respect Reduce Motion and expose text accessibility values.

## Verification and limits

Deterministic tests cover slot bounds, checkpoint-before-refill, out-of-order
results, failure draining, rate limits, cancellation, consent/key changes,
large-clip serialization, saved progress on reopen/retry, no-speech completion,
duration weighting and ETA/completion presentation.

A live Test23 pilot used the same three cached clips (344.948333 seconds total),
once sequentially and once with two slots: 95.813 versus 55.390 seconds, a 42.2%
wall-time reduction. Six requests succeeded without retries; prepared audio
hashes and request options matched. All 57 utterances per run retained structurally
usable word timing. Outputs had small text/timing differences between requests;
this was not an acoustic accuracy evaluation. Evidence is private and ignored at
`~/Documents/EasycutData/reference/point8-live-benchmark-v1/`.

This supports the default of two, not a promised speedup on the full recording.
Account quotas, bandwidth and clip sizes can constrain throughput. Actual billed
cost, isolated upload time and provider processing time were not available;
request wall time includes upload/network/provider time. More concurrency, 16 kHz
mono for all inputs, and a full-session speed study remain separate experiments.
