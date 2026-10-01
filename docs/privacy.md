# Privacy: what leaves your Mac and what stays

Telltake edits video by editing its transcript. Two steps use cloud services,
both only when you ask for them and only with your own accounts. Everything else
happens on your Mac. This page states exactly what is sent, what is kept, and
how to stop.

## Nothing leaves without your agreement

Cloud processing is off until you open **Cloud settings…**, read the disclosure
and choose **Agree**. The agreement is stored on this Mac and covers later
requests until you revoke it. Saving a key, opening a project, importing clips
and confirming a sequence send nothing. Each upload is started by a button you
press (**Transcribe with Doubao…**, **Start analysis** / **Generate rough
cut…**) and confirmed in a dialog that says what will be sent.

## What is sent, to whom

| Step | Recipient | What is sent | What is not sent |
| --- | --- | --- | --- |
| Transcription | Doubao speech service (ByteDance / Volcengine, `openspeech.bytedance.com`), under your Doubao key | The audio of each confirmed clip, extracted on your Mac and encoded as 16-bit PCM WAV (native sample rate, or 16 kHz mono when the clip would exceed 100 MB), one request per clip, with a fixed user id `easycut`, punctuation on, speaker identification off | Video frames, file names, project names, your name, other clips |
| AI Rough Cut | OpenAI Responses API (`api.openai.com`), under your OpenAI key, model GPT-5.6 Sol | The transcript text of the confirmed sequence, one line per row, each prefixed with a row number, clip number and start/end time; the fixed editing instructions | Audio, video, file names, project names, anything from other projects |
| Key validation | OpenAI, under your key | The key itself, to check it can use GPT-5.6 Sol | Any recording or transcript |

OpenAI requests are sent with `store: false`, so the provider is asked not to
retain them for its dashboard. Doubao receives the audio inside the request
itself; the app creates no hosted file and therefore has nothing it could delete
afterwards. **Neither statement is a promise about provider log retention.**
What each provider keeps, for how long, and where, is governed by that
provider's own terms and your agreement with it. Telltake cannot recall or
delete content once it has been sent.

Charges for both services go to your own provider accounts. **AI usage &
cost…** in the review window shows the saved per-request usage and a list-price
estimate; it is not your invoice.

## What stays on your Mac

- **Your video** is never uploaded. It is read for import checks, playback,
  preview and export only.
- **Your keys** are stored in the login Keychain, service
  `com.easycut.cloud.openai.v1`, one item per provider. They are never written
  to a project, a log or a diagnostics report.
- **Your agreement** is stored in the Keychain with the version you agreed to;
  a revocation marker is also written at
  `~/Library/Application Support/Easycut/cloud-processing-denied`, so a
  revocation survives even if the Keychain is unavailable.
- **The project** (`Name.easycut`) holds `state.sqlite` with the transcript,
  word timing, the raw provider responses kept as evidence, the AI proposals
  and their reasons, your edits and history, preview approvals and export
  records; `cache/` holds extracted audio that can be deleted and is recreated
  when needed; `exports/` is optional. Original clips are referenced by path and
  fingerprint, not copied. **Back up project…** copies the project data only.
- **Exports** are written where you choose, never over an existing file.
- **Diagnostics** are written only when you choose **Save Diagnostics…** from
  the Help menu. The report contains error codes and where they happened; no
  transcript text, file paths or provider responses. Telltake has no telemetry,
  analytics or crash reporting.

## How to stop, revoke or delete

- **Revoke cloud processing** in Cloud settings blocks every new upload and AI
  request and tries to cancel requests in progress. Queued work does not resume
  if you agree again later; you start it again yourself. Content already sent
  cannot be recalled.
- **Remove key** and **Remove Doubao key** delete the keys from the Keychain.
- **Stop transcription** keeps the clips already transcribed and sends nothing
  more.
- To delete your data, delete the `.easycut` project and any backups and
  exports you made. Telltake never deletes a project itself.
- To ask a provider to delete what it received, use that provider's own
  account tools and terms; Telltake cannot do it for you.

## Development and evaluation data

The people who record footage used to develop Telltake give purpose-specific
consent; editing consent is not consent to evaluation or model improvement, and
a held-out evaluation set is kept apart from development. No recording,
transcript or provider response is in this repository, and the terms in
`LICENSE` grant no rights to them. Test fixtures are generated tone and colour.

## Where this is enforced in the code

`Sources/EasycutCloud/CloudAccess.swift` (agreement and revocation),
`KeychainCloudSettings.swift` and `RevocationProtectedSettings.swift` (storage),
`DoubaoTranscriptionClient.swift` and `OpenAITextCleanupClient.swift` (exactly
what each request contains), `Sources/EasycutMedia/DoubaoAudioPreparer.swift`
(the audio that is sent), and `Sources/EasycutMac/ReviewDiagnostics.swift`
(what a diagnostics report may contain). Tests in `Tests/EasycutCloudTests`
check that revocation stops queued and in-flight work and that no request is
sent without agreement and a key.
