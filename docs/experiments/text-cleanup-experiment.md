# Text-first cleanup experiment

This development command compares a source-grounded cleaned transcript with a
saved analysis baseline. It does not replace normal app analysis, transcribe
media, train a model, or create/edit a cut. User authorization is required for a
paid run with private transcript text; preparation and replay are local.

## Contract

`OpenAITextCleanupClient` sends the full readable transcript with row IDs and
segment-local times, omitting all word arrays. GPT-5.6 Luna (medium reasoning,
16,000 output-token cap) returns retained passages with original row references
and verbatim text, plus a short summary. Scope is false starts, retakes and
redundant explanations; unique information and uncertain material should remain.
No target duration, confidence score, word timing or competing-group output is
requested. Latest successfully completed take is a semantic instruction, not
proof that a returned selection obeys the rule.

`TextCleanupValidator` permits only whitespace/composition normalization. It
requires an unambiguous contiguous source quotation inside exactly the named
rows, chronological nonoverlapping selections, and valid row IDs. It rejects
invented or silently spliced text. Partial-row times are resolved separately from
saved word anchors; partial words, unknown alignment and ambiguous source matches
never produce guessed intervals. A failed passage makes the whole proposal
ineligible for further cut materialization. Valid quotations alone do not prove
semantic correctness or acoustic accuracy. No experiment result is applied.

## Usage

Build `EasycutTextCleanup` with Swift Package Manager. Use a saved canonical
`TakeAnalysisInput` JSON, such as one exported from baseline processing evidence.
Keep input, transcript, response and reports in a private ignored directory.

```
EasycutTextCleanup prepare INPUT.json NEW_OUTPUT_DIRECTORY
EasycutTextCleanup run OUTPUT_DIRECTORY
EasycutTextCleanup replay OUTPUT_DIRECTORY
python3 scripts/render_text_cleanup_report.py OUTPUT_DIRECTORY
```

Preparation saves the exact request body, prompt and readable input. Running uses
Easycut's existing Keychain/consent/revocation path, makes one request and saves
raw provider output before parsing. A dispatch marker prevents accidental repeat
billing, even after an uncertain failure. No automatic retry is performed. A new
executable may require the user to approve its macOS Keychain dialog. Replay
revalidates the saved response without network access.

Artifacts include usage, proposed cleaned transcript, source mapping/validation,
Markdown notes and an HTML comparison. Only a fully valid source-text proposal
gets a source-validated-transcript file; this is not approval for cutting.

## First Test23 result (September 19)

One authorized run used the same 607-row snapshot as the v7 baseline. Input tokens
fell from 293,465 to 24,300; estimated cost fell from $0.1269458 to $0.0130812.
API wall time was 33.276 seconds versus 40.995. These are two different prompts
and output contracts, not an isolated performance benchmark.

The result contained 71 proposed passages; 45 failed source-text/reference checks.
The inspected retry sequence was more broadly shortened, but a restart remained
and separate information was omitted. Therefore the experiment does not justify
production integration or automatic cuts. Human quality review remains pending.
Exact private evidence and findings are in the local
`~/Documents/EasycutData/reference/test23-text-cleanup-v1/` directory.

Five offline tests cover ambiguous repeated quotes, negation changes, chronology,
noncontiguous splicing, cross-row preservation, partial-word timing, request
simplicity and raw-response retention before failure. The HTML was generated;
native browser inspection was blocked by the browser's local-file URL policy.

## Model/reasoning comparison

Preparation optionally accepts a model and reasoning effort:

```
EasycutTextCleanup prepare INPUT.json NEW_OUTPUT_DIRECTORY gpt-5.6-sol high
```

Supported experiment choices are Luna/Sol with medium/high reasoning. The prompt,
input, schema and output cap are held unchanged; run/replay read saved request
settings. Usage records the requested/returned model. Sol short-context standard
cost estimates use $4/M input, $0.40/M cached input and $20/M output, verified from
https://developers.openai.com/api/docs/models/gpt-5.6-sol on September 19. Unknown
cache-write pricing or unverified long-context conditions leave cost unknown.
This does not change the default normal app model.

Use `scripts/compare_text_cleanup_runs.py BASELINE_DIRECTORY CHALLENGER_DIRECTORY`
to compare saved outputs. This reports both passage and character coverage;
passage counts alone are not a quality metric or a count of video cuts. A model
plus reasoning comparison changes two settings and cannot isolate either effect.

## Long-response diagnostics

The experiment executable opts into a 600-second response wait and resource
limit; normal app connections retain their previous limits. Each dispatched run
saves `transport.json`. If the request or parsing fails, `failure.json` records
only a typed category, optional numeric code and elapsed time. Arbitrary error
messages/userInfo are never serialized. An interrupted request without a usage
receipt remains unconfirmed, with unknown billing. Dispatch markers still block
repeat execution in the same directory; a separately authorized retry uses a
new directory and retains the failed attempt.

The first Sol/high attempt returned no captured response; its old runner did not
retain the error, so timeout is a hypothesis, not a diagnosis. The authorized
retry preserves the exact request bytes and changes only client waiting and
failure reporting. Nine offline checks passed, including unchanged comparison
request fields, safe failure serialization and the extended request wait. These
checks establish harness behavior, not live model quality.

### Sol/high retry outcome

The user-authorized retry returned HTTP 200 after 216.533 seconds, with provider
status `incomplete` and reason `max_output_tokens`. Of the 16,000 output tokens,
12,740 were reasoning. Input usage was 24,300 tokens; estimated retry cost was
$0.41720, excluding the first attempt's unknown billing. The partial response is
preserved and displayed as incomplete, never converted to a completed proposal.
The HTML renderer supports this incomplete-response path.

The local foundation sequence preserves a unique detail Luna omitted and selects
a later source excerpt without its opening restart. Other restarts remain.
Full-transcript quality and mapping coverage cannot be measured from truncated
output. The next proposed experiment changes only the output cap to 32,000;
it has not been run. Paragraph-continuity prompting remains a separate test.
Private evidence: `~/Documents/EasycutData/reference/test23-text-cleanup-sol-high-v1-retry1/`.

## Explicit output budget

Preparation accepts an optional final output-token cap (16,000 or 32,000):

```
EasycutTextCleanup prepare INPUT.json NEW_OUTPUT_DIRECTORY gpt-5.6-sol high 32000
```

The default remains 16,000. Run verifies the saved request against its model,
effort, cap and input before dispatch; 32,000-token usage configurations carry
an explicit cap suffix. Prompt text and source mapping rules are unchanged.
The larger cap is an experiment setting, not a change to the normal app.

### Completed Sol/high 32k experiment

The subsequent authorized 32k run completed. The saved request differs from the
16k Sol/high retry only in max_output_tokens. It returned 101 passages: 95 passed
exact source checks and six failed (four noncontiguous splices and two punctuation
changes at trimmed boundaries). Validated passages contain 92.6% of proposed
characters, versus 24.2% for Luna; this measures source compliance, not edit quality.
The result still omits distinct information and does not consistently establish
the latest-completed preference. The whole proposal remains ineligible for cuts.

Usage: 24,300 input, 14,867 output including 7,296 reasoning tokens; estimated
current-call cost $0.39454. Client elapsed was 186.734 seconds and may include
credential access; provider-only compute latency is unavailable. Because output
usage was below even the old cap, this one completion does not isolate the cap's
effect from run variability. Ten offline checks passed. Reports, exact artifacts
and six-failure diagnostics are under the private ignored directory
`~/Documents/EasycutData/reference/test23-text-cleanup-sol-high-32k-v1/`.

Next: address explicit source pieces and punctuation comparison locally against
these failures, preserving occurrence ambiguity checks. Test unique-information,
latest-completed and paragraph-continuity prompting separately. No additional API
request or normal-app model change was made after this completed experiment.

## Continuity v2 and lexical validation

The next user-directed experiment retains Sol/high, the 32k output budget, the
full Test23 snapshot and the existing passage schema. Only prompt instructions
change in the API request. Prompt `text-cleanup-continuity-v2` prefers useful
unique details, the latest successfully completed attempt, and coherent continuous
passages with fewer cuts. A useful reversible rough cut is the goal; preserving
every potentially useful aside is not a hard acceptance condition. Small internal
omissions normally give way to keeping the continuous passage or choosing a
larger complete alternative. Genuinely necessary internal cuts still require
separate contiguous passages, never a concealed splice. No source-representation
redesign, normal-app change or automatic cut application is part of this trial.

Validator `text-cleanup-lexical-v2` shares punctuation/whitespace/Unicode-composition
normalization with the existing word mapper. Matching and source offsets use that
same coordinate system; original transcript rows, words and timestamps are never
rewritten. It still rejects skipped words, negation/digit changes, ambiguous
occurrences, unrelated row references, overlap, reordering and unsupported timing.
Punctuation-only content is not retained speech. Whole-source and partial-word
boundary checks remain intact. Legacy v1 prompt/request generation is retained;
replay identifies the saved prompt and records the current validator separately.

A separate local replay of the completed Sol/high v1 output fixes both
punctuation-only failures, but reveals one new repeated-phrase ambiguity that
punctuation previously distinguished. Thus 96/101 passages validate, with four
noncontiguous splices and one ambiguous occurrence remaining. No paid request was
needed for that replay. The original 95/101 report remains unchanged. Comparing
the fresh v2 output against this replay uses the same validator for both prompts.
Thirteen offline tests passed, including normalized partial-row timing, changed
negation/digits, punctuation-only content, Unicode composition, ambiguity,
noncontiguous text, and legacy request preservation.

### Continuity-v2 live outcome

One authorized Sol/high 32k run with the v2 prompt completed. All 55 passages
passed lexical-v2 source validation, with zero uncertain saved-timing mappings.
Compared with the previous response under that same validator: 101→55 passages,
5→0 source failures, average passage length 76.1→127.9 characters, and passages
under 20 characters 12→1. These are continuity indicators, not counts of final
video edits or measured user time saved. Some restarts and earlier-than-latest
choices remain. Useful-detail omissions are review choices under the updated goal.

New-call usage: 24,560 input tokens, 12,688 output including 6,368 reasoning;
estimated $0.352, client elapsed 132.05 seconds. Only API instructions differ from
the previous Sol/high 32k request. No source representation change, fresh ASR,
normal-app change or applied cuts. Private output and examples:
`~/Documents/EasycutData/reference/test23-text-cleanup-sol-high-continuity-v2/`.
Use this as the next experiment baseline for creator review.

## Reuse in the local app

The accepted integration is documented in ADR-107. Generate rough cut uses
Sol/high and the frozen continuity-v2 request. Load saved rough cut in the
Text correction & analysis panel reads `input.json` and `raw-response.json`
without a network request; the input must match the current transcript exactly.
The model's source failures become localized kept regions with review notes.

For an offline disposable integration copy:

```sh
EasycutTextCleanup apply-saved SOURCE.easycut SAVED_REPORT_DIRECTORY NEW_COPY.easycut
```

This writes only a new backup and saves `rough-cut-validation.json` and
`rough-cut-summary.json` alongside its canonical project files. Existing output
paths are refused. Keep all private evaluation folders ignored by Git.
