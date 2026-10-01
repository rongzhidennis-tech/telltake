# Local reference-cut reconstruction

EC-20 is an operator pilot, not an automatic evaluation/training pipeline. It
reconstructs possible source ranges from one final export and a directory of raw
clips. [ADR-099](../decisions/ADR-099-local-reference-cut-reconstruction.md) records
the implementation and uncertainty limits. No original or `.easycut` project changes.

## Run

Build the Swift package's `EasycutReference` executable in release mode. Use the
repository's writable compiler/cache paths if needed. Then invoke:

```sh
EasycutReference /absolute/final.mov /absolute/raw_directory /absolute/new_output_directory
```

The raw directory is nonrecursive and accepts MOV, MP4 and M4V files. The final
itself is excluded. All processing is local. Unsupported/independent audio tracks
fail rather than being arbitrarily mixed. The output directory must not exist and
must not be inside the raw directory. Create its parent first. No media is copied
into Git or registered as evaluation data.

## Review

Open the generated `review.html` locally. Every range starts **unreviewed**:

- **corroborated**: audio proposal plus three agreeing visual samples, not certainty;
- **audioProposal**: audio evidence only;
- **ambiguous**: a competing source/time is too similar;
- **visualDisagreement**: imagery disagrees or a frame could not be read;
- **unsupportedTiming**: source/final timing suggests a speed change; confirmation is blocked;
- **unmatched**: no acceptable source range was established.

Each range lists final and original times in seconds; JSON stores microseconds.
Version-2 reports also record source seconds per final second (`playbackRate`).
For example, a 10-second final segment at 1.2× maps to 12 seconds in the original.
The initial search supports 0.5×, 0.75×, 0.8×, 1×, 1.2×, 1.25×, 1.5× and 2×;
other rates and variable-speed ramps are not guaranteed. Rate is a proposal too.

Longer uncertain ranges now receive a nine-frame temporal comparison. The review
page's **Compared alternatives** section lists candidate source clips, source
times and visual differences (lower is closer). A configuration ending in
`-visual9-v1` records that evidence. This can change a proposed source, but never
marks it human-confirmed. Static/identical sequences, missing frames and searches
with more than eight plausible coarse candidates stay uncertain. Ranges shorter
than two seconds retain their existing checks. This is source disambiguation at
the current rate and boundary precision, not a frame-exact boundary pass.

The progressive filter now considers up to 256 audio-compatible hypotheses before
requiring a complete search. It checks a few frames first, excluding a candidate
only when its measured differences already prove it cannot challenge a valid
nine-frame winner. Reports retain each exclusion's source/time and lower bound.
This does not loosen the visual acceptance thresholds. More than eight survivors,
an incomplete candidate pool or missing evidence leaves the range uncertain.
The page shows filtering counts and explicitly labels incomplete searches.
Paired images show final on the left and original on the right. Load local videos
to inspect the proposed range; source playback uses the proposed rate while the
final plays at 1×. Use their independent playback controls. Normal
browser media restrictions still apply. Confirm only after inspecting source and
final content, especially endpoints. Reject questionable matches for later
correction; v1 does not provide arbitrary manual remapping or frame-exact refinement.
Unmatched ranges cannot be confirmed without a future corrected mapping.

Choose **Download reviewed JSON** to retain decisions as a separate revision. The
page does not silently write to disk, and refreshing without downloading loses
unsaved decisions. Keep the downloaded copy private alongside the original report.
The command-line alternative (zero-based segment index) is:

```sh
EasycutReference review /absolute/reference.json 0 confirmed /absolute/reviewed-r2.json
```

Use `rejected` or `unreviewed` for the other decisions. The output must be new.
This path validates report invariants and preserves prior decisions/history.

## Limits and next step

The grid is 250 ms, not frame-exact; the stated boundary uncertainty is not an
empirically guaranteed accuracy bound. Images sample three points, not every frame.
Unsupported/variable speed changes, music/dubbing, repeated takes, transitions and cropping can defeat
matching. No unsupported range is silently promoted to verified ground truth.

Review the pilot's coverage and incorrect matches first. Only then consider
boundary refinement and intent annotation. Using these examples to improve the
reconstructor makes them development examples, not independent held-out evidence.
Confirmed source mappings still need separate creator-intent review before EC-18
scoring, and separately granted dataset-purpose consent before corpus admission.

The private `~/Documents/EasycutData/reference/` pilot output, kept outside the repository, contains private image samples,
paths and fingerprints. Deleting its exact run folder removes those generated
artifacts, not originals; separately downloaded copies must also be removed if
cleanup is desired. PCM/features are kept only in memory during the run.

## Selected pilot result (2026-09-18)

The authorized local run processed all 31 raw clips and a native final duration of
609.664 seconds. The normal-speed prototype produced 2,242 ranges: 188.75 seconds
visually corroborated, 216 seconds ambiguous, 163.5 seconds visually disagreeing,
and 41.414 seconds unmatched. These are machine-status totals, **not accuracy or
verified coverage**. Every range remains unreviewed.

Strong anchors in ten source groups have a median of 1.2 source seconds per final
second, suggesting a speed-up. The normal-speed assumption therefore does not
produce a usable continuous reference timeline. Do not approve the fragmented
pilot output as labels. The user subsequently authorized constant-speed-aware
matching, including 1.2×, and rerunning the selected media. This implementation
uses the revised report-v2 timing invariant and synthetic tests in ADR-099.

The diagnostic uses audio scores >=0.80 and visual distance <0.08, with at least
20 anchor pairs separated by 1–5 final seconds. A median rate more than 0.05 away
from 1 and an interquartile range below 0.04 flags suspected non-unit timing.
This is an uncalibrated warning, not proof that an entire clip has a single rate.
New runs mark affected source groups `unsupportedTiming`; command-line review
also blocks confirmation of detected groups in older reports. Diagnose an existing
report without rereading media:

```sh
EasycutReference diagnose /absolute/reference.json /absolute/new-timing-diagnostic.json
```

Private artifacts are in `~/Documents/EasycutData/reference/8.24-pilot-v1/`. The initial JSON and
approximately 301 MB HTML predate the timing warning and remain unchanged as
diagnostic artifacts, not ready-for-approval results. The subsequent
`timing-diagnostic.json` records the warning evidence. This pilot also demonstrates
that per-fragment embedded imagery needs size reduction before routine review.

Verification: nine reconstruction/media test functions (including parameterized
presentation-time checks), the full Swift regression suite, and all seven schema
checks passed. The optional real-camera fixture test remained skipped; the selected
local pilot was run separately. EC-20 remains in progress, and EC-18's independent
held-out evaluation and consent requirements remain unchanged.

## Authorized rate-aware rerun (2026-09-18)

The final continuity-aware run is `~/Documents/EasycutData/reference/8.24-rates-consensus-v2/`.
It contains `reference.json`, `review.html` (approximately 71 MB), and
`timing-diagnostic.json`. An intermediate rate-only run is retained separately in
`~/Documents/EasycutData/reference/8.24-rates-v2/`; neither overwrites the first pilot.

| Machine result | Original normal-speed pilot | Rate-aware continuity run |
| --- | ---: | ---: |
| Proposed/unresolved ranges | 2,242 | 725 |
| Unambiguous, visually corroborated | 188.750 s | 68.500 s |
| Ambiguous, visual checks agreeing | 216.000 s | 409.500 s |
| Visual disagreement | 163.500 s | 108.250 s |
| Unmatched | 41.414 s | 23.414 s |

The new run proposes 1.2× timing over 495.5 seconds. Visual samples agree over
478 seconds (78.4%), **not a measured accuracy rate**. Only 68.5 seconds (11.2%)
also meet the unambiguous machine status. The continuity pass deliberately retains
ambiguity from supporting anchors, so fewer fragments and more visual agreement
do not imply stronger source certainty. Other proposed rates are tentative, not
verified evidence that the editor used those speeds.

All 725 ranges remain unreviewed. All 32 source/final SHA-256 identities match the
first pilot. No original, project, cloud settings, or dataset registry changed.
The report validates its full final coverage and rate-aware source bounds. Its
normal-speed drift diagnostic reports no additional flagged groups; this does not
prove the rates or mappings are correct.

Verification now includes 17 reconstruction/media test functions (one with three
frame-cadence cases), plus the full Swift regression suite and seven schema checks.
The optional real-camera fixture test remains skipped. The selected-media runs
above are separate local validations, not held-out evaluation.

The speed-aware implementation is ready for diagnostic inspection, **not a finished
human reference cut or training input**. Remaining work is to disambiguate sources
using longer temporal evidence, refine cut boundaries beyond the 250 ms grid, and
present a focused human review before any mapping is accepted. EC-20 remains
in progress; the independent EC-18 gate is unchanged.

## Temporal disambiguation pilot (2026-09-18)

The new local run is `~/Documents/EasycutData/reference/8.24-temporal-v3/` (third pilot iteration,
not report schema version 3). Its JSON remains schema version 2 with configuration
`local-audio24-context25-rates8-consensus-hop50ms-grid250ms-v2-visual9-v1`.

Seventy-one longer uncertain ranges were eligible. Six completed the bounded
candidate search and passed the nine-frame comparison, resolving 23.75 seconds
at the machine-proposal level. The other 65 exceeded the eight-candidate budget
and were not promoted. The six completed searches compared 1, 6, 2, 3, 4 and 3
coarse source/time hypotheses respectively; their identities and distances are
retained in the report and exposed under **Compared alternatives** in the HTML.

Final output: 727 ranges covering 609.664 seconds, comprising 93.25 seconds
machine-corroborated, 384 seconds ambiguous, 108.75 seconds visually disagreeing,
and 23.664 seconds unmatched. The previous run had 68.5 seconds corroborated;
the isolated temporal-stage gain in this run is 23.75 seconds, not the full
between-run difference. Raw matching/visual sampling also changed slightly on
rerun. These are machine-status totals, never measured accuracy or human approval.

All 32 media SHA-256 fingerprints match the first pilot, and all 727 ranges remain
unreviewed. Originals, project packages and cloud settings are unchanged. JSON and
approximately 71 MB HTML are private, separate outputs. No dataset admission or
learning occurred. The input guard added after the media run only rejects malformed
proposals; the run used valid generated ranges and its matching policy is unchanged.

The gain is limited: candidate-search capacity is now the explicit bottleneck.
The next source-disambiguation step should reduce candidates with additional
temporal evidence before costly full comparisons, while preserving genuinely
plausible alternatives. Do not bypass the incomplete-search guard to manufacture
confidence. Boundary refinement and focused human review remain necessary afterward.

Verification includes 20 reconstruction/media test functions, the full offline
Swift regression suite and seven schema checks. The optional real-camera fixture
test remains skipped; this selected-media run is separate local validation. EC-20
remains in progress and EC-18's held-out evaluation gate is unchanged.

## Progressive filtering pilot (2026-09-18)

The new private output is `~/Documents/EasycutData/reference/8.24-screening-v4/` (fourth pilot
iteration, still report schema 2). Configuration ends `-visual9-screening-v2`.
The preceding temporal report was successfully decoded and validated by the new
executable; `previous-report-compatibility.json` contains its drift diagnostic,
not new approval or altered mappings.

Sixty-nine longer uncertain ranges were eligible in this rerun. Thirteen candidate
pools completed; 56 exceeded the 256-hypothesis pool limit and remained unresolved.
Across completed pools, 1,042 hypotheses were excluded by recorded lower bounds.
The stage decoded 4,321 candidate source frames instead of the 9,495 required by
full nine-frame comparisons of those same complete pools (about 54.5% fewer).
This excludes final-video frames and the initial three-point pass; it is not an
end-to-end latency or accuracy claim.

The thirteen resolved machine proposals cover 50.5 seconds in this run. Final
output contains 730 unreviewed ranges over 609.664 seconds: 122.25 seconds
machine-corroborated, 354.75 seconds ambiguous, 109.25 seconds visual disagreement,
and 23.414 seconds unmatched. The prior pilot had 93.25 seconds corroborated.
Base matching/sampling also differed slightly on rerun; the within-run stage
effect and between-run total difference must not be conflated.

All 32 recorded media fingerprints match the original pilot. No recording or
project was changed, uploaded, trained on or enrolled in a dataset. JSON stores
each pruning proof, and the approximately 72 MB HTML displays completeness and
filtering counts. The post-run input/defensive-validation guards only reject
malformed inputs; the run's valid-input matching policy is unchanged.

Twenty-one reconstruction/media test functions, the full offline Swift suite and
seven schema checks pass. The optional real-camera fixture remains skipped;
the selected local run is separate validation, not held-out evaluation.
EC-20 remains in progress: the remaining pool-limit bottleneck, frame-accurate
boundary refinement and human review are still outstanding. Do not use this draft
as learning labels or silently discard alternatives to improve its status totals.
