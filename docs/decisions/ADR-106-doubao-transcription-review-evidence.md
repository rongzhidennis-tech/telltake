# ADR-106: Doubao Turbo transcription with review-only acoustic evidence

- Status: Accepted for the macOS validation prototype
- Date: 2026-09-19
- Amends the provider choice in ADR-104; its preservation and uncertainty rules remain.

## Decision

Use the tested Doubao Turbo recording-file endpoint, `volc.bigasr.auc_turbo`,
`bigmodel`, for new desktop transcription runs. Do not substitute the standard
asynchronous edition (`volc.seedasr.auc`). OpenAI remains the text-analysis
provider; the Whisper adapter remains available for historical evaluation.

Send locally decoded, full-clock PCM WAV audio only, one source clip per request.
Preserve sample rate/channels and source timestamps, including leading silence.
No VAD, splitting, alignment, fallback or hotwords are added. Reject unsupported
or oversized inputs before any upload. Codec padding beyond the canonical source
end is excluded; this is not a speech boundary adjustment.

Request utterances and punctuation, disable semantic smoothing and ITN, omit
language and speaker identification. Each attempt receives a fresh UUID. Require
both HTTP success and the provider status header. No automatic retries. Direct
flash requests create no client-addressable stored job; this does not assert
provider-log deletion or zero retention.

## Evidence and review

Persist complete raw responses, clip/request identities and configuration in
`transcription_provider_evidence`, with immutable per-utterance notes in
`utterance_review_note` (schema migration 5). Raw whitespace tokens with invalid
negative times survive here but cannot enter canonical usable word alignment.
Reject incomplete ordered lexical agreement and invalid utterance ranges.
Invalid word regions remain uncertain using their original utterance range,
explicitly not replacement word timestamps. Never drop repetitions or negations.

Positive ordered word timestamps establish structural consistency only. Preserve
those timestamps but mark their alignment unknown until acoustic verification is
available; existing automatic-cut gates therefore withhold removal. Raw zero
confidence survives in evidence, while canonical confidence is absent rather
than a probability or ranking signal. Historical results are not rewritten.

Flag Latin names for audio review without replacing them using context. Flag
`用你` as a possible extra word or abandoned fragment, not a proven error. A
transparent heuristic flags repeated openings (two or more occurrences from a
small documented phrase list), showing repeat count and utterance duration.
This is an inspection aid, not automatic attempt segmentation or an accuracy
score. It will have false positives and misses; no utterances are split.

The transcript UI displays durable notes and exports raw response evidence.
CER/WER, name correctness, filler fidelity and acoustic boundary accuracy still
require manually reviewed labels; token/utterance counts do not rank ASR quality.

## Credentials and consent

Store Doubao separately from OpenAI in the existing Keychain record. Import is
an explicit user-selected file action, never a runtime repository-key fallback.
The new consent version names Doubao audio and OpenAI text processing; the old
OpenAI-only consent does not silently authorize the new destination. Revocation
and credential changes cancel active requests and invalidate operation tickets.
No key is sent to the other provider. The desktop currently requires the existing
validated OpenAI connection for its combined transcript-and-analysis workflow.

## Test23 presentation-clock finding

The saved M4A and original first source track map media time 44ms to presentation
zero (AVFoundation edit mapping). The earlier ffmpeg evaluation WAV inserted
44ms of leading padding. Production decodes the native source presentation
clock, does not insert that padding, and records a fresh input fingerprint.
Old reports are preserved; their structurally valid timestamps are not promoted
to acoustically validated production boundaries. No fixed timestamp correction
is applied to provider output. Actual empty presentation segments remain silence.

## Desktop workflow correction

A Test23 run on September 19 exposed an unconditional reuse rule: any current
transcript skipped ASR, including a saved Whisper version after switching the
configured provider to Doubao. The following take-analysis stage then failed,
misleadingly appearing to be a Doubao failure. No Doubao request had occurred.
Reuse now requires the exact provider/model/configuration/language match.
The explicit “Transcribe with Doubao” action creates a new ASR version and stops
before take analysis or Clean Cut generation. Prior versions remain sealed and
readable. Take analysis remains an explicit separate action, and invalid take
suggestions produce a descriptive error without relaxing validation or applying
cuts. Regression tests cover switching from sealed Whisper and an intentionally
failing take provider that must never be called by transcription-only work.

## Oversized decoded audio correction

A second Test23 failure occurred before upload: clip 15 (649.316667 seconds,
48 kHz stereo) expands to 124,668,848 PCM bytes, above the 100 MB file limit.
The preparer now keeps native PCM when it fits, otherwise decodes the complete
presentation clock at 16 kHz mono. This produces a 20,778,178-byte WAV for this
clip, without chunking, silence removal, or changing source duration. The WAV
header counts toward the size limit; clips exceeding the duration or compact
size limit fail with a readable error. Configuration `doubao-turbo-review-v2`
and saved preparation-policy/byte-count evidence distinguish these inputs from
previous runs. This is an audio-format change, not evidence of improved ASR or
acoustic alignment. Existing comparison reports remain unchanged.

Verification uses offline extraction and preparation of every included Test23
clip plus a synthetic stereo recording with known silence and trailing speech.
No provider request is needed to reproduce or verify this preparation failure.

## No-speech outcomes and progressive persistence

The next Test23 attempt completed 38 of 39 clips, then returned provider status
`20000003` on IMG_9486.MOV (136.506667 seconds). The previous adapter converted
that outcome into a fatal error and held earlier responses only in memory.
Those unsaved historical responses cannot be recovered by a migration.

Configuration `doubao-turbo-review-v3` accepts HTTP success with status `20000003`
as a completed clip with an empty transcript and an explicit review note. Empty
or absent result bodies are preserved; a contradictory speech-bearing result
still fails validation. Other non-success statuses remain errors without automatic
retry. Successful status with an empty validated transcript receives the same
review note. No-speech is a provider observation, not proof of silence: the full
source remains preserved and reviewable, including clips shorter than two seconds.

Migration 6 stores validated per-clip output and complete response evidence in
SQLite before the adapter starts the next request. Partial work survives process
exit, later failure, and audio-cache deletion. An explicitly requested retry uses
a new run, imports saved clips only from the failed run with exactly matching
sequence/configuration/source identity, and transcribes unfinished clips only.
The final transcript seals atomically in source order. A failure after every clip
was saved can finish on retry without a provider call. Duplicate checkpoints are
rejected; a failed checkpoint commit stops the next upload. A request interrupted
before its response is durably saved cannot be guaranteed free of repeat charges.
No automatic retry, VAD, alignment, hotwords, or speech-boundary repair is added.

## Whisper-to-Doubao integration review

- Speech-only work uses a consent- and generation-bound Doubao authorization
  ticket and does not require an OpenAI key. That ticket cannot authorize OpenAI
  text or Whisper requests. Consent revocation and credential changes invalidate
  queued/in-flight work. Combined analysis retains its OpenAI authorization.
- OpenAI validation now checks the configured text model only. Existing validation
  of the same text model plus Whisper remains valid; removing Whisper access is
  not a reason to block Doubao transcription.
- Only the latest matching failed attempt may be resumed; an older failed run
  must not override a newer successful run when a fresh transcription is requested.
- Full-clock WAV preparation is performed one clip at a time, retaining the same
  audio-format policy while avoiding a session-sized decoded-audio allocation.
- Raw response status, response text, request duration, timestamps and uncertainty
  remain in evidence. Zero confidence does not become a probability, invalid
  formatting entries remain raw, and all unverified acoustic boundaries retain
  their existing automatic-cut restrictions. Names and repetitions are flagged,
  never contextually rewritten.

Verification uses synthetic HTTP responses and real coordinator/store operations:
no-speech and contradictory bodies; other status failures; failed checkpoint
commits; repeated failures and reopen with deleted caches; all-clips-saved
recovery; provider/configuration mismatch; consent/key-change and provider-scope
checks; migration from older schemas. No paid request is made by these tests.

## Creator-authorized provider timing trust (2026-09-19)

After manually checking the Doubao output, the creator requested that independent
acoustic checking stop being a prerequisite, while retaining the stricter option
for future use. This supersedes the blanket unknown-timing policy above.

The default `trustProvider` policy uses configuration
`doubao-turbo-trusted-timing-v4`. Structurally valid lexical timestamps are usable
word timing; all original values remain unchanged. Positive duration, ordering,
utterance containment, audio bounds and complete ordered lexical agreement remain
required. Invalid lexical timing still falls back to unknown utterance evidence
and cannot authorize automatic boundaries. No-speech clips remain preserved.
Recognition and take-selection safeguards are unaffected.

`requireReview` (`doubao-turbo-review-v4`) retains the prior gate and can be
selected in Cloud Settings. This is a selectable requirement, not a newly
implemented acoustic alignment engine. The switch affects future runs; Apply
reinterprets saved raw responses locally without uploading or retranscribing.
Each reinterpretation creates a new immutable transcript and records the source
run and timing policy. Core validation prevents any changes to recognized text,
word/utterance ranges or confidence. Original transcript versions remain intact.
If active cuts exist, a directly reopenable sibling project backup is made before
selecting the new transcript. Cuts remain historical; take analysis is explicit.

Provider zero confidence stays absent in canonical words, unchanged in raw
evidence. In trust mode its repeated per-row notice is suppressed; export states
that confidence is unavailable and timing is trusted by user policy. Evidence
continues to say `acoustically_verified: false`; trust does not fabricate a
verification result or a probability. Strict mode restores the earlier notices.


## Amendment 2026-09-21: duration-sized response wait

The flash endpoint returns only after processing the whole clip, so the request's
idle timeout is effectively the provider's processing time. The desktop client
previously shared the 120-second text-analysis connection, whose session also
capped any single request at 600 seconds including upload; a clip longer than a
few minutes could time out after it was billed, and an explicit retry repeated the
same failure. Doubao requests now use a dedicated connection (`ResponseWait.longRunningAudio`)
and each request sets its own idle wait from the clip duration: 120 seconds plus
half the audio duration, capped at one hour (`DoubaoTranscriptionClient.responseWait`).
The session ceiling is 4,800 seconds. Observed processing has been roughly a quarter
of real time; the factor leaves headroom without letting a hung connection wait
indefinitely. Text analysis keeps its 120-second wait and cleanup its 600-second wait.
