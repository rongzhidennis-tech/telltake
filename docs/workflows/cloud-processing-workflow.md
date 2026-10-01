# Cloud processing: EC-19 testing integration

## Current status — integration validation complete (2026-09-18)

EC-19 is complete following the tester's final confirmation that revocation,
restart persistence, blocked cloud status and saved local preview all passed.
Both real-media export paths, reopen and recovery evidence are recorded below.
Historical checkpoints describe what was pending at that time; this final status
supersedes those pending statements. EC-18 is now dependency-ready, but no quality
gate has passed and no evaluation-dataset permission is implied. Consent remains
revoked unless the user explicitly grants it again in Settings.

Read-only saved stage timings for the successful selected-session run: local audio
extraction 0.406 s, transcription 15.264 s, take analysis 6.846 s; two Story requests
took 14.206 s and 9.248 s. These are individual observed stage durations, not
latency benchmarks. Billing cost was not measured. The short selected recording
does not establish long-recording recognition quality; compression/chunk continuity
is covered by the separately recorded synthetic tests. No production-quality or
broader representative-corpus claim is made.

## Knowing when analysis is finished

### Local preview diagnostics

Preview failures display a full in-app diagnostic dialog and a status tooltip,
and log to macOS subsystem `Easycut`, category `PreviewDiagnostics`. Fixed rule
names distinguish time jumps, player status/end failures, invalid time/rate,
coverage observations, incomplete endings, preparation and receipt persistence.
Numeric fields contain composition position, credited coverage, total duration,
elapsed observation time (microseconds), playback rate and item status
(0 unknown, 1 ready, 2 failed). Raw platform error descriptions, media content,
paths and credentials are excluded. Logging does not change acceptance thresholds
or approve/export a cut. No network is involved.

For the immediate Creator preview failure, restart the updated build, reopen
the selected project and Creator Cut, click **Preview full cut** once, and share
the diagnostic dialog if it fails. Do not rerun cloud analysis. Following the
reported pre-ready coverage sample, the startup correction in ADR-089 now waits
for readiness, verifies zero positioning and prerolls while paused before starting
coverage. Removing opening context does not require keeping a blank row as a workaround.
Startup failures have separate timeout, zero-position and preroll diagnostic codes.

Startup-fix verification (2026-09-18): the new paused-start regression failed
before the change and passed afterward. Fixture playback verifies nonzero source
starts, normal completion, seek rejection, and stopping/reusing the player during
startup. A standalone local playback of the earlier opening-trimmed Creator plan
completed coverage without writing a receipt or approval to the user's project.
The temporary diagnostic project copy was removed afterward. The full suite passed
with macOS media-service access (155 core, 28 cloud, 7 desktop, 26 reported media
tests; opt-in real-camera test skipped), plus seven schema checks. The initial
sandboxed full run failed in synthetic media-reader tests; the permitted rerun
passed. No cloud request or original-media change was made. The user subsequently
confirmed Creator preview, approval, exported playback and reopen persistence work.

The project window now derives completion from saved transcript and Clean Cut
results, including when reopening a project. It shows **Analysis complete — ready
to review**, highlights **Review results…**, and relabels the optional paid rerun
as **Run analysis again…**. A spinner appears during work. After a successful
analysis, an in-app completion sheet offers **Review now** or **Later**; reopening
saved results does not repeat the sheet or start processing. A saved transcript
without a Clean Cut instead offers **Continue analysis…**. Story generation is
separate. These presentation changes do not call cloud services or read Keychain.

Verified with six desktop tests, including completed/partial/initial status
presentation. No live analysis was run for this UI change.

## Transcription rejection diagnostics

Zero-duration words now use the conservative segment-level fallback in
[ADR-096](../decisions/ADR-096-conservative-zero-duration-alignment.md). Full text and
provider segment timing are preserved; word alignment is explicitly unknown.
Automatic take selections spanning that uncertainty become review-only suggestions.
`word_duration` now rejects reversed timing, not equal start/end times. Other
invalid responses still produce diagnostics. Rebuild before explicitly retrying;
the previous failed attempt is not repaired retroactively.

Zero-duration follow-up verification (2026-09-18): the full offline Swift suite
passed (opt-in real-camera test skipped), followed by focused passing tests for
all-point segments and candidate/intervening alignment uncertainty through reopen
and reanalysis. All seven schema checks and whitespace checks passed. No user
recording, stored credential or live endpoint was accessed during this fix.

Transcription response validation now reports a fixed rule name and numeric
values in the error message (hover for the full message) and local macOS logs,
subsystem `Easycut`, category `TranscriptionDiagnostics`. No response body,
transcript text, audio, credential, file path or project/clip ID is logged.
Values are zero-based segment/word indexes followed by relevant microsecond
timings or counts. `word_duration`, for example, reports segment index, word
index, word start and word end. `timestamp_bounds` reports the allowed chunk
duration; `response_shape` deliberately excludes raw decoder details.
These diagnostics do not relax validation, retry requests, or change cloud
authorization. They are not stored in the project database; macOS controls log
retention. Existing failures cannot be reconstructed retroactively.

To diagnose an existing failure, quit and rebuild/relaunch Easycut, reopen the
selected project, and explicitly choose **Start analysis**. This is a new cloud
attempt and may incur charges. Share the diagnostic message or screenshot if
it fails. Do not share credentials. At this historical checkpoint, EC-19 was still
in progress pending validation.

**Historical offline implementation checkpoint:** The guarded integration was
implemented; EC-19 was **not complete** at that time. No real recordings
or live credentials were used during implementation. Tests use synthetic bytes,
temporary packages, in-memory settings and injected HTTP responses, never the
user's Keychain or OpenAI endpoint.

## Explicit setup

1. Launch Telltake with no project. Open **Telltake → Settings…** (⌘,) or
   **Cloud settings…** in the project window.
2. Click **Review & agree…**, read the disclosure (audio to Doubao, transcript text
   to OpenAI, video never leaves the Mac), then choose **Agree**. **Not now** is the
   default; closing the notice does not grant consent. If this agreement version is
   already granted, no repeat is needed.
3. **Doubao key (transcription).** In the Volcengine console, create a speech
   (豆包 / 大模型语音) API key with the recording-file recognition model
   `bigmodel` enabled (the app requests the `volc.bigasr.auc_turbo` resource).
   Paste the key into the **Doubao speech API key** field and click **Save Doubao
   key**, or choose **Import Doubao key file…** for a text file that holds exactly
   one key. The key is saved only to this Mac's Keychain; saving contacts nothing.
   It is checked when you first transcribe, not at save time.
4. **OpenAI key (AI Rough Cut).** Paste your OpenAI API key into the **OpenAI API
   key** field and click **Save key**; then **Validate key…** and confirm. Validation
   contacts OpenAI only to check that the key can use GPT-5.6 Sol, the model behind
   the Rough Cut; it sends no recording or transcript. A key without access to that
   model stays saved and the status names the missing model. Missing, malformed,
   rejected or unvalidated keys cannot process recordings, and nothing retries or
   switches model on its own. You can transcribe with Doubao without an OpenAI key.
5. Create a **new project** and import **only the recording(s) you select**. Check
   the clips and their order, choose **Check & confirm sequence**, then
   **Transcribe with Doubao…** and confirm the request. Review the transcript, then
   choose the analysis button (**Start analysis** / **Generate rough cut…**) to send
   the transcript text for the AI Rough Cut. Corrected-text reanalysis remains an
   explicit command. Preview approval and local MP4 export rules are unchanged.

The implementation does not select a real recording or start these actions on
your behalf. Key saving, consent, project opening and import alone upload nothing.
Key validation sends a credential to OpenAI but no audio/transcript; the Doubao key
is checked only when a transcription is requested. No existing project or library is
automatically processed after configuration.

For the development build, the normal launch is `swift run EasycutMac` from the
repository. If the repository's build directory has signing attributes, use the
verified isolated build/run command instead:

```sh
env CLANG_MODULE_CACHE_PATH=/private/tmp/easycut-clang-cache \
  SWIFTPM_MODULECACHE_OVERRIDE=/private/tmp/easycut-swift-cache \
  swift run --disable-sandbox --scratch-path /private/tmp/easycut-ec19-build \
  --cache-path /private/tmp/easycut-spm-cache EasycutMac
```

Consent covers existing/future recordings without per-recording prompts. The Start
analysis confirmation is an operation/cost confirmation, not another consent grant.
Revoke in Settings at any time; local review/export remain usable. Revocation
blocks downstream stages, retries and old operations even after re-grant. It cannot
recall content already transmitted. Reopening restores results, never cloud jobs.

Recovery shows transcription lifecycle and cleanup status. Doubao receives audio in
a direct request and creates no deletable hosted file, so the app has nothing to
clean up afterwards and hides **Retry cloud cleanup**; this says nothing about
provider log retention. Interrupted runs are retained as failed attempts with their
per-clip checkpoints, and **Transcribe with Doubao…** reuses finished clips.

## Long audio and chunk timestamps

**Shipped Doubao path (ADR-106, ADR-110).** Each clip is sent as one request, up to
two hours long; oversized audio is compressed to 16 kHz mono first and refused with
a plain message if it still exceeds Doubao's size limit. Clips are not chunked, up to
two run at a time, and every finished clip is checkpointed before the next request.
The chunking description below belongs to the Whisper-era client, which now lives in
`EasycutCloudDev` for the command-line tools only.

Source-video size is not an upload limit. Easycut extracts audio locally, keeps
files below 24 MB as one request, and transcodes larger audio to 16 kHz mono AAC
at 32 kbit/s. Actual encoded size determines whether chunking is necessary.
If still too large, it creates contiguous PCM WAV chunks (at most ten minutes),
preferring quiet split points. No silence is removed; original video is untouched.

Each chunk's offset is added to all returned word/utterance times. For example,
a word at 0.5 s in a chunk beginning at 600 s maps to **600.5 s in the original
clip**, not 0.5 s and not the cumulative position across other clips. Final source
coverage is exact in microseconds; local decoder-tail rounding is bounded to 1 ms.
Larger timing mismatches, invalid response ranges, gaps or overlaps fail safely.
Speech across a forced non-silent boundary still needs recognition-quality review.

Every chunk rechecks the operation's consent generation. Failure never seals a
partially transcribed clip or retries automatically; an explicit new attempt can
resend earlier chunks and incur another charge. No uploaded Files resource is added.
See [ADR-095](../decisions/ADR-095-timeline-preserving-cloud-audio-chunks.md).

## Offline verification (checkpoint of 2026-09-18, Whisper/Luna providers)

`EasycutCloudTests` covers missing/invalid credentials, explicit content-free
validation, denial/old-version/corrupt consent, version/time persistence, revocation,
Keychain-store outage with independent denial, disk-marker reopen, stale validation,
in-flight response rejection, operation and multi-clip revocation/re-grant, no
automatic retry, sanitized failures, Whisper timing, batch size preflight, strict
take output and Story/incomplete output. `CloudWorkflowTests` verifies authorization
before media access and interrupted cleanup/reopen without cloud consent.

Run tests in an isolated writable scratch path if the repository build directory
has signing attributes. No test requires a real key or operational cloud consent.

Verification recorded 2026-09-18 on macOS 26.6.2 (25G83), Apple Swift 6.4:

- After the chunking continuation, the final complete Swift suite exited
  successfully: 154 core, 23 cloud, 4 desktop, and 26 reported media tests;
  the opt-in real-camera media test was skipped.
- Added synthetic 30-minute compression; unchanged small audio; sample-exact
  forced WAV chunks; preserved silence; original AAC sample timing; 48 kHz stereo
  AAC ending at 60,999,854 µs; adjacent/offset provider timestamps; invalid
  gap/overlap/out-of-chunk ranges; later-chunk failure and between-chunk revocation.
- The fractional camera fixture reproduced a six-sample resampler-tail rounding
  difference. Bounded 1 ms handling now passes while retaining the exact canonical
  duration and original half-second audible start. No real recording was tested.
- Initial restricted-media execution aborted; rerunning with macOS media-service
  access passed, including the final complete suite. All media were local fixtures.
- All 7 schema regression tests passed; no migrations were changed. `git diff
  --check` passed. Actual Settings/Keychain UX and real-cloud behavior remain untested.

## Scoped implementation review

The user selected EC-19 changes only, excluding the extensive pre-existing
uncommitted implementation. No unrelated changes were staged or committed.

### Standards

No outstanding findings after fixes. Independent denial persistence protects
against Keychain outages; operation-scoped authorization covers Start analysis,
reanalysis and Story; interrupted-run reconciliation enables explicit cleanup.
The chunking continuation was separately reviewed against the saved starting
workspace; its fractional-duration verification concern was reproduced and fixed.

### Spec

No outstanding findings in the guarded implementation after fixes. Both reanalysis
and Story establish the authorization generation before asynchronous preparation.
At this historical review checkpoint, representative real-media validation was
still pending, so that review did not close EC-19.
The chunking re-review has no outstanding findings; realistic sample-rate and
fractional-ending coverage is included, and no source-video size cap is introduced.

Summary: 0 outstanding Standards findings; 0 outstanding Spec findings. The initial
two privacy races and interrupted-cleanup issue were fixed and regression-tested.

## Real-media validation evidence

### User-run progress (2026-09-18)

Read-only inspection of the selected local project confirmed successful
transcription at 15:08:34 UTC, take analysis at 15:08:41 UTC, and Clean Cut
generation at 15:08:41 UTC. The user confirmed the completion UI works. Earlier
failed attempts remain recorded; the zero-duration alignment rejection was
diagnosed and handled conservatively. This establishes successful execution,
not transcript quality or cut accuracy. No Story/Creator variant or export was
present at this checkpoint. No private transcript or recording content is copied
here. The agent did not initiate additional processing.

Subsequent user confirmations cover unchanged Clean preview/approval/export and
playback, followed by Story generation, Creator editing, full preview/approval,
export playback and reopening with edits preserved. These are user-observed
workflow results, not a held-out quality evaluation.

### Recovery continuation (2026-09-18)

The agent used the canonical backup API on the explicitly selected project to
create a disposable, cache-free package. Reopen preserved all three current cuts,
one previous cut and current pointers; saved transcript inspection remained usable.
Recovery correctly reported six unavailable derived audio caches. Two external
exports passed the stored SHA-256/size identity check. No media was uploaded,
rendered or moved, and no credential or user-level consent was changed.

In that copy only, source references were marked missing and pointed to a nonexistent
path. All current cuts refused export requests while saved transcript review remained
available; no output was created. This checks the real saved plans against the
missing-source gate, not a manual Finder-move/Settings UI exercise. The independent
synthetic-media relink test also passed with an actual moved local movie. The
original project's cuts were re-read and confirmed unchanged. The disposable
package and diagnostic executable were removed after verification.

Focused recovery/relink, cloud authorization and interrupted-cleanup tests passed
(exit 0), including all 28 cloud tests. Revocation/restart, old-operation rejection,
between-chunk revocation and cleanup while denied passed offline. The actual
Settings revocation/restart check was subsequently confirmed by the tester.

Completed user check: choose **Cloud settings → Revoke cloud processing**, verify
**Consent record: revoked** and **Cloud processing: blocked**, quit and relaunch,
then verify both statuses persist. Reopen the project and preview the saved cut
locally. The tester reported all steps passed, including both Settings statuses
and local preview. No new analysis was required.

Known UX limitations remain: section removal can be rejected for protected or
unclassified context with insufficiently visible feedback; editing controls are
below the transcript; provider explanation text can estimate a different duration
from the authoritative saved plan. These observations do not justify bypassing
content-preservation rules or claiming production readiness.

- Settings consent/credential and revocation/restart flows passed by tester report.
- Both selected-session real-media journeys were confirmed by the tester; broader
  launch-recording representativeness and quality are not established by this session.
- Cache-free reopen and simulated source-loss-before-export passed as described
  above; the earlier rejected live transcription and explicit successful retry
  provide the observed cloud-failure path.
- Actual Keychain and Settings UI validation, system versions, observed model
  identity/configuration, stage timings, costs and recording-size limits.
- Verify compression/chunk boundary recognition quality on the selected recording,
  including playback at the beginning, end and each chunk transition when used.
- No quality claim until the separate EC-18 held-out gate passes. Approved
  3/1/.95/.99 take settings are explicitly uncalibrated tests, not release thresholds.

See [ADR-093](../decisions/ADR-093-user-level-cloud-processing-consent.md) and
[ADR-094](../decisions/ADR-094-cloud-credentials-and-test-integration.md).

## Selected-recording validation checklist

Reusable checklist (completed for this selected session as recorded above):

1. Selected recording → import/confirm → transcription/Clean → complete preview
   and approval → **unchanged Clean MP4**, without Story or manual edits.
2. Same selected session → explicitly request Story → review/restore proposals →
   Creator edit → complete preview/approval → local MP4.
3. Close/reopen between durable stages; check saved transcript/source timestamps
   and playback around chunk boundaries. Reopen must not make cloud calls.
4. Check recovery without caches, a controlled cloud failure, and source loss
   before export without deleting the original. Use copies for destructive-looking
   recovery exercises and retain the original recording unchanged.
5. Revoke consent in Settings, restart, and verify future analysis is blocked while
   saved local review remains usable. Re-grant only if further cloud tests are wanted.

Record OS/build, model/configuration (`whisper-segment-fallback-v5`,
`openai-takes-test-v2`, `openai-story-test-v2`), source/derived-audio sizes and duration,
stage timings, observed cost/usage, boundary accuracy, failures, output plan identity
and MP4 inspection results. Do not copy the recording, transcript or API key into
the repository or public issues. These workflow checks do not replace EC-18's
separate held-out quality evaluation or grant dataset-purpose permission.

## Authorization queue regression follow-up (2026-09-18)

Explicit Start analysis, Story and corrected-text reanalysis now capture the
authorization generation synchronously before queuing work. Capture checks consent
and validated credentials under one lock; nested stages and transcription batches
retain the captured generation. Revoke/re-grant rejects the old command before
preparation or content dispatch.

Four new deterministic tests cover queued cloud commands, nested stages, missing
credential validation and queued desktop analysis. Temporarily restoring the old
generation recapture behavior made the stale-command tests fail, including
unexpected mock HTTP dispatches. With the fix restored, the full Swift suite passed
(155 core, 31 cloud, 8 desktop and 26 reported media tests; the opt-in real-camera
test was skipped). All 7 schema checks and local documentation link checks passed.
These checks use local fixtures and injected transports; no live-media validation
was repeated and no live cloud requests were sent.

### Test23 connection interruption (2026-09-18)

Both reported attempts completed local extraction but failed on their first
transcription upload. macOS network logs recorded `NSURLErrorDomain -1005`
(connection lost), with a TLS `SSLV3_ALERT_BAD_RECORD_MAC` alert after roughly
0.5 seconds. One failure reused the validation connection; the other used a fresh
connection after restarting the app. These were not request timeouts or HTTP
provider rejections. The exact cause of the TLS interruption remains unconfirmed.

Three later synthetic invalid-audio probes through the existing, consent-gated
`OpenAIConnection` reached HTTP 400 audio validation: 8 MB repeated bytes, 8 MB
random bytes, and 23 MB random bytes. No Test23 audio was uploaded by these probes.
This verifies connectivity at diagnostic time, not a successful Test23 analysis.

The live transport now preserves a sanitized numeric URL error and explains
connection loss, timeout, offline, DNS and secure-connection failures. It never
includes raw NSError descriptions or userInfo. A URLProtocol regression replays
the captured -1005 at the actual transport boundary. No automatic retry, TLS
verification bypass, provider fallback, or project-state change was introduced.
A new explicit Start cloud analysis attempt is required to validate Test23 itself.

### Test23 zero-duration segment follow-up (2026-09-18)

The user's next attempt reached transcription output validation and reported
`segment_duration; values=[15, 29959999, 29959999]`. The adapter now handles point
segments at shared neighboring boundaries under
[ADR-097](../decisions/ADR-097-conservative-zero-duration-segments.md), retaining all
text and marking combined alignment unknown. New attempts use
`whisper-segment-fallback-v4`; saved successful results are unchanged. Synthetic
regression tests reproduce the exact endpoint, but successful Test23 completion
still requires the user's explicit retry with the rebuilt application.

Verification for ADR-097: all 44 selected cloud, desktop, and durable uncertain-
alignment tests passed, including the reproduced endpoint, rejected invalid timing,
and prevention of automatic take cuts. The local macOS app was rebuilt.

### Test23 unassigned-word follow-up (2026-09-18)

The user reported `unassigned_words; values=[448,458]`. A synthetic regression
reproduced that exact failure with ten words between valid segment timing ranges.
[ADR-098](../decisions/ADR-098-complete-text-alignment-fallback.md) adds complete-text
fallback: every lexical word must be present in order in the segment text and
full transcript. Timing disagreement then preserves the original segments as
unknown alignment, while malformed timing or missing text still fails. Every
word is validated before fallback, including previously unassigned words.
Configuration is now `whisper-segment-fallback-v5`. The actual rejected response
was not retained, so the synthetic reproduction does not establish the precise
word positions in Test23. No recording was uploaded during this fix.


## Repeated Keychain prompts

Cloud settings now share one versioned Keychain item and an in-memory session
cache. After the initial migration, analysis authorization reads that item once
per app session; transcription chunks, take analysis and status checks reuse it.
The independent denial marker is still checked on each authorization. Revocation
and credential changes from Settings remain immediate. External Keychain edits
require restarting Easycut.

The first launch after this change may still ask for access to each of the three
old items while preserving and consolidating the existing key, consent and
validation. No re-entry of the API key or new consent grant is needed. macOS owns
the password dialogs, so a locked Keychain, migration or a settings write can add
prompts. The local build is an unsigned development prototype; this change does
not establish a stable signing identity across builds.

Offline regression: `analysisAuthorizationReadsKeychainOncePerSession` exercises
operation capture, nested authorization, request-ticket checks and status refreshes.
The same sequence performed 45 protected reads before consolidation and must now
perform exactly one after reopening migrated settings. Additional tests cover
migration, failed persistence, corrupt records, credential changes and revocation
with a warm cache and an unavailable Keychain. Tests use an injected item store;
they do not access the user's real Keychain or dispatch cloud requests.

ADR-098 verification: 54 selected cloud, desktop, and durable uncertain-alignment
tests passed in an isolated source snapshot. Concurrent reference-reconstruction
work introduced tests for not-yet-present types, blocking the shared test build;
only `ReferenceReconstructionTests.swift` and `ReferenceMediaTests.swift` were
excluded from the disposable snapshot (no workspace files were removed). The
normal workspace app build was used for delivery, preserving concurrent work.
