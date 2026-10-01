# ADR-104: Localize alignment uncertainty; keep uncalibrated passage cuts withheld

- Status: Accepted implementation; automatic-selection quality gate not passed
- Date: 2026-09-18 (live measurements continued September 19 UTC)
- Scope: improvement point 6; amends ADR-096, ADR-098 and ADR-103

## Alignment evidence

New transcription attempts use `whisper-local-alignment-v6`. Continue requesting
Whisper word and segment timestamps. Validate every timestamp and word before
accepting any output. Require complete ordered lexical agreement among words,
segments and the full transcript, including the normal timing-success path.
Comparison ignores punctuation/whitespace and normalizes Unicode composition;
it never drops repetitions or negation, reorders text, or fuzzy-matches.

When all three streams agree, map tokens to segments using exact cumulative
lexical offsets. Retain original word times only when every contributing token
is wholly contained in that segment's text and time intervals, has positive
duration, and no foreign token timing intrudes. A word spanning two segment text
intervals marks both uncertain; do not invent subword timings. Point segments
and point words remain uncertain. Unaffected segments retain their known word
alignment instead of inheriting response-wide uncertainty. Invalid global timing
or incomplete text still rejects the response. Original segment boundaries and
chunk offsets never change.

This establishes consistency, not acoustic correctness. It neither recovers
Test23's missing original responses nor rewrites sealed transcripts. No automatic
retranscription, audio upload or alignment model is introduced. Existing unknown
alignment remains unknown. A future audio-alignment pass requires an explicitly
selected alignment method and separately measured evidence, linked to the
immutable source/transcript, before it can authorize any automatic cuts.

## Passage screening and calibration

`PassageCalibration` compares 0.93, 0.95, 0.96 and 0.99 without modifying evidence,
production thresholds or cuts. Confidence-qualified and text-qualified counts are
screening counts, never precision or calibrated probabilities. Text qualification
requires equivalence, no progression, a preference and no reported unique facts
in excluded candidates. Source coverage, uncertain endpoint utterances, uncertain
interior utterances and uncertain intervening speech are reported separately.
Even a fully word-aligned endpoint is not declared acoustically validated.

All passage cuts remain withheld pending boundary and quality validation. The UI
reports zero automatic passage cuts, zero automatically saved duration, specific
withholding reasons and potential speech removal separately. Speech removal
estimates union original utterance intervals; they do not count retained visual
gaps. Empty results still show zero. Creator choices remain explicit, reversible,
and separate from automatic approval.

Two authorized Test23 development requests exposed unreliable attempt grouping,
unique-fact attribution and preferred-take choices. The second prompt version,
`openai-takes-passages-v5`, explicitly requests individual attempts, in-span
supporting quotations and comparison of shared facts. This did not establish a
quality improvement or sufficient accuracy: confidence 0.99 still accompanied
repeated restarts, and another explanation contradicted the selected index.
Consequently no tested threshold qualifies for automatic release. This is an
observed failed quality gate, not a completed calibration or a reason to lower
confidence. Historical v4 evidence and Creator edits remain readable.

## Accepted product prior: latest successfully completed take wins

For a **verified retake chain expressing substantially the same intended content**,
the default Intended take is the latest successfully completed attempt. Earlier
attempts normally become removal candidates. This is a strong product prior,
not an unconditional latest-in-time rule and not permission to apply a cut.
Do not ask the model to freely rank stylistic quality once the retake relationship
is established. A cleaner-sounding earlier take does not override a successfully
completed later retake merely on stylistic grounds. Creator choice remains an
explicit override.

This amends ADR-103's free completeness/coherence preference and the deployed
v5 prompt's instruction to prefer fewer restarts or an earlier stylistically
cleaner candidate. The product rule is accepted; the structured contract and
selection policy below are **proposed, not yet implemented or evaluated**. The
existing v4/v5 measurements are historical and do not test this rule.

### Proposed assessment contract and deterministic policy

The model supplies evidence, not a free preferred-candidate index:

1. **Relationship:** assess whether the passages are genuine attempts to deliver
   the same intended thought. Return verified retake / non-retake / uncertain,
   the intended-content description, and source-ID/quotation support. Semantic
   similarity alone is insufficient. Review intervening context and later context
   before claiming the chain is complete. Callbacks, summaries, ordinary repeated
   explanations, elaborations and new information do not become retakes merely
   because their words or topics recur.
2. **Completion:** label each chronological attempt completed / failed or
   abandoned / uncertain, with source-grounded evidence. Completion means the
   intended thought is successfully expressed; being fluent, long, latest or
   ending a file is not proof. Preserve failed attempts in the chain evidence
   rather than omitting them and accidentally treating the immediately next take
   as the winner. Boundaries must identify individual attempts, including a
   successfully completed restart inside a previously overbroad passage.
3. **Supersession:** record forward-only links to later attempts at that same
   intended thought, and evidence that the available later context was examined.
   Do not invent links across progression boundaries. A failed later attempt does
   not supersede the last completed one. Incomplete source coverage or an uncertain
   later attempt prevents claiming a verified final completed take.
4. **Essential-information preservation:** for each earlier attempt, identify
   essential facts, qualifications, negation and causal/setup information; map
   their preservation to the final completed take's source IDs and quotations, or
   mark missing / uncertain. Compare directly to the final take, not just adjacent
   pairs: a fact surviving Take 1 → Take 2 can still disappear in Take 3. Novel
   wording is not necessarily essential new information. Do not assume absence
   of a model-generated uniqueFacts entry proves preservation.

The portable core validates IDs, chronology, non-overlap, evidence references and
forward-only chain links. With a verified relationship, sufficient later context
and resolved completion assessments, it derives the latest completed candidate
from source chronology. For Take 1 → failed Take 2 → completed Take 3, choose
Take 3. For completed Take 1 → failed Take 2, retain Take 1 as the default. With
no completed take, or unresolved completion/supersession, abstain and request review.
Do not infer completion from a confidence score or let a contradictory model
preference replace this policy. A model relationship claim is evidence to validate,
not by itself a product-level verification of the chain.

Intended-take selection and removal permission remain separate. The final completed
take may remain the default Intended take while an earlier attempt with essential
unpreserved information remains included and flagged for review. Missing or
uncertain preservation withholds the affected earlier removal; do not silently
switch the Intended take for style, stitch rewritten sentences, or remove essential
content. Uncertain relationship keeps the passages separate. Existing source,
progression, boundary, protected-context and calibration gates still govern cuts.
A failed tail attempt can be reviewed separately; the prior does not silently
remove it merely because it was classified as failed.

Version the new prompt, assessment schema, persisted evidence and core policy
together when implementing. Store relationship, completion, supersession and
preservation separately from the derived Intended take and per-attempt removal
eligibility/reasons. Do not reinterpret old preferredCandidate indexes as verified
completion evidence; old runs and Creator edits retain their original semantics.
The UI should explain “Latest completed take: Take 3,” identify failed/superseded
attempts, and distinguish removal candidates from withheld removals and actual cuts.
Automatic passage cutting remains disabled until this policy passes evaluation.

## Verification

See [point-6 development evaluation].
Offline tests cover localized uncertainty, bilingual text, repetition, negation,
point timings, token/segment crossings, pauses, chunk offsets, invalid text and
timing, threshold boundaries, unique-fact/progression protection, boundary versus
interior/intervening uncertainty, zero-cut display, durable recommendations,
Creator edits, undo/redo and unchanged AI baselines.

Official contract: [Whisper timestamps](https://developers.openai.com/api/docs/guides/speech-to-text#timestamps).
The API offers word/segment estimates; that contract does not certify edit accuracy.
