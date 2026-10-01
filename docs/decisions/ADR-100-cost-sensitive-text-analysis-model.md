# ADR-100: Use GPT-5.6 Luna for cost-sensitive text analysis

- Status: Accepted
- Date: 2026-09-18
- Scope: Take/repetition and Story analysis after EC-19 integration
- Amends: ADR-093 and ADR-094 initial `gpt-5.6-terra` model choice

## Decision

Use `gpt-5.6-luna` for new take/repetition and Story requests. Keep `whisper-1`
for transcription. Keep the existing Responses API contract: text-only input,
strict JSON output, `store:false`, no tools or background mode, low reasoning
for takes and medium reasoning for Story. Increment the take and Story
configuration versions to `openai-takes-test-v2` and `openai-story-test-v2` so
new results are distinguishable from saved Terra results. Prior analysis history
remains readable and is not rewritten.

The user requested this cost-driven model change after a large take-analysis
request incurred long-context cache-write charges. The recorded request repeated
thousands of long utterance IDs; reducing that request is separate follow-up
work recorded in `improve_idea.md`. Luna lowers the model's per-token rates but
does not remove the oversized prompt or long-context pricing threshold.

Saved API-key validation for the previous model set does not establish Luna
access. Bind the validation record to the selected models and require a fresh
Settings validation after this change. Existing cloud-processing consent remains
valid because the provider, data categories, and disclosed retention scope are
unchanged. No automatic inference retries or model fallback are introduced.

Luna supports Responses, structured outputs, and the existing reasoning levels
according to [OpenAI's model documentation](https://developers.openai.com/api/docs/models/gpt-5.6-luna).
The separate EC-18 quality gate remains open; lower model cost does not establish
equivalent take or Story quality.

## Compact transport amendment (2026-09-18)

[ADR-102](ADR-102-compact-analysis-and-usage-accounting.md) advances new take/Story
requests to configuration v3 for compact IDs, explicit no-write caching and usage
accounting. It preserves Luna, reasoning efforts and the existing selection policy.

## Amendment 2026-09-21: validate every model the workflow uses

ADR-107 added GPT-5.6 Sol for the AI Rough Cut, but validation still checked only
Luna, and any HTTP 401 or 403 discarded the saved validation. A key with Luna but
not Sol access therefore validated, failed at the Rough Cut, was de-validated,
validated again, and so on. Validation now checks both models, the validation
record is bound to that list (existing records need one fresh check, as this ADR
already required for Luna), and only a 401 invalidates the key. A 403, or a 404 on
a model lookup, is reported as `modelAccessDenied` naming the model, with the key
left validated.

Later the same day the Luna analysis client was removed from the desktop app
altogether: the AI Rough Cut (ADR-107, GPT-5.6 Sol) is the only analysis the app
runs, so validation now checks Sol alone. Luna remains selectable in the
`EasycutTextCleanup` experiment tool. The Core take-analysis and Story Cut model is
retained for saved projects; its retirement is tracked in `docs/post-launch-actions.md`.
