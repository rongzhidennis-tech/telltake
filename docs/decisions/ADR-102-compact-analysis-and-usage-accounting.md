# ADR-102: Compact text-analysis transport and retain usage evidence

- Status: Accepted
- Date: 2026-09-18
- Scope: Improvement point 4; EC-06, EC-10 and EC-19 adapters
- Amends: ADR-100 configuration versions; supplements ADR-079/083 stage evidence

## Decision

New Luna take and Story requests use `openai-takes-test-v3` and
`openai-story-test-v3`. Assign request-local IDs `u1…uN` in source chronology.
Encode utterances as tuples with one column definition, preserving exact text
(including paragraph breaks), clip ordinals, uncertainty, eligible pairs, target
and included durations as applicable. Omit canonical run/sequence/transcript/cut
IDs and repeated configuration metadata from the network payload. Keep canonical
input and configuration in the existing stage evidence. The mapping is exactly
reconstructible from that input's ordered utterances and `compact-utterances-v1`.

Translate response IDs through the exact request's reverse map before existing
core validation or persistence; reject unknown IDs. Keep all pairwise locality,
progression, confidence, uncertainty and Story contiguity rules unchanged.
This does not implement passage-level take detection or relax cut safety.

Use `prompt_cache_options: {"mode":"explicit"}` with no breakpoints. These are
one-off dynamic requests; no reusable prefix has yet justified cache writes.
Keep `store:false`, `background:false`, no tools, and existing reasoning effort.
Request standard service with `service_tier:default`. The
[official caching guide](https://developers.openai.com/api/docs/guides/prompt-caching)
states that this explicit mode without breakpoints neither uses nor writes the
prompt cache. It also defines reads, writes and ordinary input as disjoint prices.

## Durable usage

Each take/Story coordinator binds a run-local recorder. Before dispatch, save an
unconfirmed request record in `processing_stage.output_ref_json.requests`; if
that write fails, do not dispatch. Update that same attempt when an HTTP response
arrives, before validating its output or accepting its authorization generation.
Only billing metadata is retained at this point; invalidated responses still
cannot become accepted analysis output. No automatic retry is added.

Save attempt/time, request and response IDs, requested/returned model, configuration
and transport versions, cache policy, service tier, body/input bytes, latency,
provider status, HTTP status, raw usage fields, input/read/write/output/reasoning
counts, price version and estimate. Missing counts remain unknown, including for
older runs and connections that end without a response. Interrupted attempts may
have incurred charges. Provider `completed` describes the response; the enclosing
stage separately records whether application validation succeeded or failed.

Usage survives complete, failed and cancelled stages and project backup/reopen.
Optional evidence fields keep existing schema-v3 projects/history readable without
a SQL migration. Finalized stage evidence cannot be changed through the recorder.

## Cost accounting

`openai-luna-standard-usd-2026-09-18` uses the
[official price table](https://developers.openai.com/api/docs/pricing): per million
tokens, normal context input/read/write/output rates are $0.20/$0.02/$0.25/$1.20;
above 272,000 input tokens they are $0.40/$0.04/$0.50/$1.80. Estimate:

`(input - read - write) × inputRate + read × readRate + write × writeRate + output × outputRate`

Divide by one million. Reasoning is already part of output; never add it again.
Estimate only for the known model, returned standard tier and complete, consistent
nonnegative billing categories. Missing/contradictory counters or unknown prices
produce no estimate. Retain raw usage for investigation rather than silently
clamping contradictory provider accounting. The report labels estimates, excludes
transcription charges, and exposes request IDs for invoice reconciliation; it does
not claim to be the provider's final bill.

## Verification

All 288 offline tests passed, including ID round trips, preserved constraints,
unknown-ID rejection, Story durations, non-overlapping cost categories, long-context
rates, missing/malformed usage, invalid/incomplete responses, HTTP/network errors,
pre-dispatch persistence failure and completion/failure/reopen persistence.

Test23's exact saved input: 1,627 utterances and 6,498 eligible pairs. Adapter input
shrunk from 892,153 to 194,724 UTF-8 bytes (78.2%); no transcript/pairs were dropped.
The live request body, including schema/instructions and JSON escaping, was 231,942
bytes. One explicitly authorized live request on a disposable backup took 8,337 ms:
83,285 input, zero cached input, zero cache writes, 1,080 output (427 reasoning),
estimated $0.017953. Output also passed unchanged core validation. This proves
transport/accounting integration, not model-quality equivalence. The reopened
local app report was visually checked against the saved live counts and estimate;
it also correctly marked the historical run as usage unavailable.

Historical Test23 usage was not recorded, so exact old token totals and billed-cost
reconciliation cannot be reconstructed. The reported historical $2.239 Terra charge
is not a like-for-like Luna measurement; no extra large baseline request was sent.
