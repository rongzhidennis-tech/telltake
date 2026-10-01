# ADR-094: Guard the small-scale cloud integration with explicit credentials

- Status: Accepted
- Date: 2026-09-18
- Scope: EC-19; supplements ADR-093 and ADR-077

## Decisions approved by the user

Use a user-supplied OpenAI API key in macOS Keychain for this small-scale phase.
Do not assume a key exists, search other applications' credentials, use environment
fallbacks, or ship a shared secret. Settings detects missing/configured/validated
credentials without displaying a stored key. Saving is local only. Explicit
validation, after consent, retrieves the two selected model descriptions without
audio or transcripts. Only successful validation permits content requests; it
does not establish billing/quota availability. Authentication failures invalidate
validation. Changing/removing a key invalidates active work and validation.

Keychain items use a dedicated application service, are device-only and do not
synchronize. Consent version/state/timestamps are user-level, not project-level.
A separate atomic denial marker in the user's Application Support/Easycut directory
survives Keychain outages. Write denial before the descriptive revocation record;
storage failure blocks the running process and reports failure, never success.
Removing denial occurs only after successfully persisting an explicit re-grant.
As with all local persistence, simultaneous failure of every durable storage
medium cannot guarantee persistence; the application must not report it saved.

No automatic inference retries, model fallback or redirect following. Each explicit
Start analysis/reanalysis/Story command creates the relevant durable attempt;
successful transcription is reused when retrying a failed later stage. A failed
transcription attempt may resend previously processed clips on explicit Retry and
may incur another charge. Cancellation/timeouts cannot promise a request was not
billed. Reopening never dispatches cloud work. Interrupted transcription runs are
marked failed before explicit retry/cleanup, without interrupting active work in
the same desktop service. No multi-process concurrent project editing is added.

Check authorization atomically with every HTTP start, and bind an authorization
generation to the whole extraction/transcription/take operation and transcription
batch. Capture it atomically with authorization when the explicit command is
accepted, before queuing asynchronous work; nested stages retain that generation. Revoke/re-grant cannot resume the older operation. Cancel in-flight requests
best-effort and reject late responses from invalidated generations. Cleanup is
independent of consent and never resends content.

Approved test-only take configuration: at most **3 intervening utterances**, **1
intervening clip**, semantic similarity **≥0.95**, combined confidence **≥0.99**.
Version `openai-takes-test-v1`; not calibrated and not evidence of production quality.
EC-18's held-out evaluation gate remains mandatory.

## Keychain access consolidation (2026-09-18)

The three legacy accounts (`api-key`, `consent`, `validated-key`) are consolidated
into one versioned `settings-v2` item in the same dedicated Keychain service.
`KeychainCloudSettings` loads it once per desktop session and keeps the decoded
settings in memory. Each settings mutation persists the whole item before updating
the cache; a storage failure discards the cache. Quit/relaunch requires a fresh
protected read. Changes made externally to the Keychain item take effect on relaunch;
Settings changes take effect immediately. The prototype has one application window
and one shared access service, and does not support concurrent application instances.

This removes repeated protected reads from authorization, status refresh, chunk
processing and downstream stages. Authorization itself is still checked before
each dispatch, including the independent, uncached denial marker and operation
generation. Revocation, key removal/replacement and authentication failure keep
their existing invalidation behavior. The cached key is never written outside
Keychain or included in logs/project files.

On first access after upgrading, read all legacy items, persist the consolidated
record, then remove the old items. A persisted cleanup flag makes interrupted
cleanup retryable; malformed/newer consolidated records fail closed instead of
falling back to legacy grants. Migration can prompt for each old item once.
After migration, normal analysis makes one protected read per app session, rather
than promising a particular number of OS dialogs: macOS controls unlock/access
prompts, and saving settings can require separate write authorization.

## Adapter contract and data handling

- `whisper-1`: direct multipart audio transcription, original-language `zh` hint,
  verbose JSON with word and segment timestamps. Source-local ranges are validated
  conservatively before existing core validation and sealing.
- `gpt-5.6-terra`: text-only Responses, strict JSON schema, no tools, no background
  mode, `store:false`; low reasoning for takes and medium for Story. Existing core
  validators remain authoritative for IDs, ranges, grouping and preservation.
- No Files API resources or persistent provider jobs are created. ASR cleanup is
  therefore a truthful no-op, not an assertion that provider logs were erased.
- API content is not used for training by default. The transcription endpoint lists
  no content retention; Responses abuse-monitoring retention can be up to 30 days,
  with policy/legal exceptions and temporary prompt caching. Do not promise zero
  provider retention. Material disclosure changes require a new consent version.
- The existing AVFoundation decoder gate and local H.264/AAC MP4 encoder from
  ADR-090/091 are unchanged. Original video is never sent to OpenAI.

Official references consulted 2026-09-18: [data controls](https://developers.openai.com/api/docs/guides/your-data),
[file transcription](https://developers.openai.com/api/docs/guides/speech-to-text),
[GPT-5.6 Terra](https://developers.openai.com/api/docs/models/gpt-5.6-terra).

## Deliberate current limits

The initial per-clip size rejection is superseded by
[ADR-095](ADR-095-timeline-preserving-cloud-audio-chunks.md): locally compress
oversized audio, then chunk only when necessary, preserving source timestamps.
There is no 25 MB source-video limit and no silent truncation.
Unknown/incomplete model output fails safely without fallback. No real latency,
cost, model quality, actual Keychain UX, or full desktop media journey is claimed
by injected-transport tests. Dataset-purpose controls are unchanged and separate.

Implementation and offline verification instructions: [cloud workflow](../workflows/cloud-processing-workflow.md).
