# ADR-095: Prepare bounded cloud audio without changing the source timeline

- Status: Accepted
- Date: 2026-09-18
- Scope: EC-19 continuation; amends ADR-094's per-clip audio limitation

## Decision

The user requested support for realistic recordings through local extraction,
transcoding and necessary chunking, with original-media timestamp continuity.
There is **no 25 MB source-video limit**. The existing extractor validates the
original and produces audio only, including leading/trailing silence on its
source clock. Video remains local and unchanged.

Use a **24,000,000-byte audio-file budget**, leaving headroom under the provider's
25 MB limit for multipart framing. If extracted audio already fits, send it as one
file without extra transcoding. Otherwise locally encode mono **16 kHz AAC at
32 kbit/s**. This makes ordinary 20–30 minute speech recordings comfortably small
enough for one request; a generated 30-minute fixture verifies that path. Always
check actual bytes, not estimated bitrate or original video size.

If the compact file is still too large, decode the original extracted audio to
16-bit, 16 kHz mono PCM on its original presentation clock. Divide that PCM into
contiguous WAV windows of at most ten minutes, further bounded by the byte budget.
Prefer a quiet interval of at least 300 ms in the last ten seconds (or last quarter
of a shorter window). Silence is neither removed nor compacted. With no suitable
pause, use the exact sample boundary; there is no overlapping context or heuristic
text deduplication that might delete a genuine repetition. Speech crossing a hard
boundary can lose ASR context, so boundary recognition remains a real-validation
check, not a claim of guaranteed model quality. Transport chunks are not edits.

## Source-clock mapping and failure boundaries

- Each chunk carries its original clip ID, absolute start offset and duration.
  Sample offsets are converted independently to integer microseconds; do not sum
  rounded sample durations. Final coverage ends at the canonical clip duration.
- Resampling/container end rounding is bounded to **1 ms**. Pad missing decoded
  tail samples with silence only within that tolerance; ignore padding outside
  the canonical end. Larger discrepancies fail preparation rather than silently
  shortening, stretching or shifting the recording. The final sample can extend
  less than 62.5 µs past the exact microsecond endpoint; transcript ranges cannot.
- WAV windows introduce no per-chunk codec delay. Decode sample buffers completely,
  including partial reads at the tail. No seeking through compressed-byte offsets.
- Before any upload, validate every prepared chunk: supported audio type, nonempty
  bytes below budget, matching clip ID, contiguous non-overlapping ranges, and exact
  complete coverage. Invalid preparation causes zero content dispatches.
- Validate each Whisper response in chunk-local coordinates first, then add that
  chunk's source offset to every segment and word. Preserve source clip IDs and order.
  Existing core transcript-range validation remains authoritative.
- Mark a clip complete only after all its chunks succeed. Any chunk failure returns
  no successful partial clip to seal. No automatic retry; an explicit new attempt
  may resend earlier chunks and incur charges, under ADR-094.
- Every chunk uses the original operation authorization generation. Revocation,
  key changes and cancellation still block subsequent dispatches, even after re-grant.
  Original audio caches remain disposable; temporary preparation files are removed
  on success, failure or cancellation. No new provider Files resources are created.

Configuration version: `whisper-word-segment-chunks-v2`. No SQLite migration is
needed: sealed utterance/word ranges already store original clip microseconds.
Existing sealed transcripts remain immutable and reopenable. No consent scope or
provider change is introduced; there is no new per-recording consent prompt.

## Verification and authorization

**Historical implementation checkpoint:** Approved seams were synthetic local media preparation and injected cloud transcription.
Tests cover long-audio compression, unchanged small inputs, forced chunk sample
continuity, silence, AAC decoding, 48 kHz stereo/fractional endings, shifted word
timestamps, adjacent boundaries, gap/overlap rejection, failed later chunks and
revocation between chunks. No live key or real recording was required or used for these offline tests.

At that checkpoint EC-19 remained `in_progress`. Real validation must use a recording explicitly
selected by the user, with in-app consent and a configured/validated credential.
Neither this implementation request nor loading existing projects starts uploads.
**Current status (2026-09-18):** EC-19 integration validation is complete. See the
[final evidence and limitations](../workflows/cloud-processing-workflow.md), including
tester-confirmed real-media workflows. EC-18's quality gate remains separate.

The [official transcription guide](https://developers.openai.com/api/docs/guides/speech-to-text)
documents the upload limit, compressed audio/chunking, word timestamps and the
accuracy risk of mid-sentence splits (consulted 2026-09-18).
