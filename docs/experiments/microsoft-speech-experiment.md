# Test23 first clip: Microsoft LLM Speech

This is a separate operator experiment, not a change to Easycut's production
transcription pipeline. It uses the exact `requests/001.m4a` bytes from the
successful first request in `test23-transcription-baseline-v1-retry2/run`.
The runner verifies the saved SHA-256 and never re-extracts or transcodes media.

Request contract: REST API `2025-10-15`, `enhancedMode.enabled=true`,
`enhancedMode.task=transcribe`, locale `zh-CN`, no custom prompt or phrase list.
Other service options remain default. There is one upload with no automatic
retry. API version is recorded separately from the service-managed model revision;
no unreported model revision is invented. The current request requires an HTTPS
custom resource endpoint ending in `.cognitiveservices.azure.com`.

The endpoint and credential are not configured yet. Set `AZURE_SPEECH_ENDPOINT`
and `AZURE_SPEECH_KEY_FILE` (a local file containing the key), or use the
`AZURE_SPEECH_API_KEY` environment variable. Do not put secrets in commands,
reports, repository files or chat. The runner keeps the credential only in memory,
uses default TLS verification, and rejects redirects. Keyless authentication is
not implemented in this initial operator script.

Prepare only (no credential or network needed):

```sh
PYTHONDONTWRITEBYTECODE=1 python3 scripts/run_microsoft_speech_experiment.py \
  /absolute/saved-baseline/run /absolute/new-private-output
```

After configuring the approved Azure resource, use a **new** output directory and
add `--execute` to make the paid request. The preparation report is explicitly
`awaiting_credentials`, not a transcription result.

Reports retain the full raw response, including `combinedPhrases`, `phrases`,
words, timings, language/channel fields and additional returned metadata. The same
HTML renderer presents phrase times in seconds; raw provider times remain in
milliseconds. Missing timestamps remain unavailable. LLM Speech's documented
confidence placeholder of zero is not interpreted as a calibrated score. No
Easycut project is created or edited, and no production Whisper parser is used
on Microsoft output. Transcript accuracy remains unmeasured until labeled.

Sources checked September 19, 2026:
- https://learn.microsoft.com/en-us/azure/ai-services/speech-service/llm-speech
- https://learn.microsoft.com/en-us/azure/ai-services/speech-service/fast-transcription-create

Offline verification covers enhanced-mode request selection, endpoint restriction,
raw metadata retention, millisecond conversion, missing times and HTML escaping.
Live request and response validation remain pending resource configuration.
