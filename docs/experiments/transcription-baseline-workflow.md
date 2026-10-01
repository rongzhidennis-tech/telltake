# Current-pipeline transcription baseline

This is a transcription-only operator experiment. It invokes the current
production `ProjectTranscriptionCoordinator`, audio extractor/preparer,
`OpenAITranscriptionClient`, decoder, and project sealing logic. It does not
run take analysis or generate cuts. No model sweep, new VAD, alignment model,
fallback, automatic retry, or acceptance-policy change is introduced.

## Explicit live run

The user must authorize the input's audio upload to the configured provider.
The saved application credential and consent gates remain in force. The command
makes paid API requests; it never displays or stores the credential.

```sh
PYTHONDONTWRITEBYTECODE=1 python3 scripts/run_transcription_baseline.py \
  /absolute/Test23.easycut /absolute/new-experiment-directory
```

The destination must be new and its parent must exist. Use a private, Git-ignored
location such as `~/Documents/EasycutData/reference/`. Keep all experiment artifacts together.
The initial operator uses an explicitly opted-in Swift test to access the existing
internal HTTP transport seam without modifying production code. Ordinary test
runs skip the live experiment. `EasycutCloudTests` depends on `EasycutMedia` only
to compose the same media adapters used by the desktop app.

The run makes a canonical SQLite backup of the actual input project, extracts
fresh audio from its included source clips, then transcribes only that isolated
copy. Original project edits and transcript versions are not changed. The exact
current model/configuration is read from `OpenAITranscriptionClient.configuration`.
Existing preparation and decoder uncertainty handling remain part of this baseline.

## Saved evidence

- `provenance/`: source snapshot, source hashes, Git commit/dirty status, Swift and
  macOS versions. A commit ID alone cannot reproduce an uncommitted workspace.
- `execution.log`, `execution-status.json`: process results, including setup failures.
- `run/manifest.json`: report schema version, ordered source identities and
  fingerprints, sequence hash, duration, model/configuration and request parameters.
- `run/input/`: exact freshly extracted audio and content hashes.
- `run/requests/`: exact prepared upload audio, chunk offsets/hashes, complete
  raw API response bytes, status/request ID, request start and elapsed time.
  Request headers and credentials are never serialized.
- `run/transcript.json`: complete newly sealed system transcript, source-local
  microsecond boundaries, segmentation, word text/times/kind/confidence, unresolved
  clips and transcript version. Present only if the current pipeline seals a result.
- `run/result.json`: transcription completion/failure and elapsed time.
- `run/report.html`: readable raw recognition, segment tables, expandable complete
  metadata and accepted utterances/word timing, plus local upload-audio playback.
- `run/raw-transcript.txt`: plain-text raw recognition and segment times.
- `run/checksums.json`: SHA-256 of report/input/response files, excluding the mutable
  copied project and checksum file itself.
- `run/baseline.easycut`: isolated project with the new run and unchanged prior history.

Provider timestamps are request-local seconds. Input metadata supplies the source
start offset; the report shows source-local seconds. Accepted transcript JSON uses
source-local microseconds. The manifest also records each clip's offset in the
confirmed recording sequence. Unknown alignment remains unknown; no word times
are invented for comparison.

If the current pipeline rejects a response, stops on a network error, or cannot
extract every clip, retain that outcome. Never silently repair or retry it to make
the baseline successful. Raw responses received before rejection remain available;
a failed run is not a complete transcript. Setup failures before authorization may
have only the execution log and provenance, without a transcription manifest.

## Re-rendering and later experiments

Re-rendering is local and makes no API requests:

```sh
PYTHONDONTWRITEBYTECODE=1 python3 scripts/render_transcription_report.py /absolute/experiment/run
```

Future user-selected API adapters should reuse this frozen input manifest and exact
saved audio, preserve raw responses and expose the same normalized report fields.
Unsupported timestamps/confidence must be absent or null, never synthesized.
Changing upload preparation is a separately identified pipeline experiment. This
baseline runner intentionally cannot select another model.

No accuracy score is inferred from execution success. CER/WER and timing accuracy
require reviewed reference labels. Identical audio/configuration does not guarantee
byte-identical responses from a remotely served model.

## Local verification

The recording-wrapper fixture verifies lossless raw response capture and that
Authorization is not written. Renderer checks cover escaping recognized text,
source offsets, extra metadata, unknown alignment, failed runs, and checksums.
The live test is disabled unless `EASYCUT_BASELINE_RUN=1` is explicitly supplied
with project and output paths by the runner.
