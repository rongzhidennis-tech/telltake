# Prototype evaluation protocol

The normative scoring, sample, consent, and timing decisions are in
[ADR-073](decisions/ADR-073-review-contract-clarifications.md). EC-18A implements
data admission/isolation before real-data collection; EC-18 evaluates the fully
integrated workflow after EC-19.

The implemented [dataset registry workflow](dataset-registry.md) governs admission,
purpose-authorized reads, label review, frozen manifests, and withdrawal cleanup.
All collection adapters must use that shared registry before handling corpus data.

## Before a measurement run

1. Verify per-item, per-purpose consent and exclude revoked or unresolved records.
2. Freeze a dataset manifest containing source/creator identities, intended use,
   split, annotation revision, and consent references. Keep source and creator
   identities disjoint between tuning and held-out data.
3. Adjudicate labels with creator intent authoritative for meaning. Keep unresolved
   cases visible and out of scored denominators; report their number and reason.
4. Freeze provider/model, prompt/configuration, and search thresholds before accessing
   held-out results. Held-out failures do not become prompt/threshold tuning examples.
5. Record app version and media/processing configuration with each report.

## Required report

| Measure | Denominator / gate |
| --- | --- |
| Mechanical-exclusion precision | Correct automatic utterance exclusions / all scored automatic utterance exclusions; >=98%, 99% stretch. Include exclusions caused by take selection. |
| Critical false exclusions | Count loss of unique creator-intended meaning separately; zero observed required. A critical loss is also an incorrect exclusion in precision. |
| Minimum safety evidence | >=500 scored automatic exclusions, >=20 sessions, >=10 held-out creators; otherwise inconclusive. |
| Take selection | Groups with an approved selected take / adjudicated groups with an AI selection; report separately, including delivery-only errors. |
| Active review | Median and 90th percentile from usable results to approval; median <=15 minutes. Include active playback, exclude idle/processing/export as defined in ADR-073. |
| Story usefulness | Creator-rated usable starting points / adjudicated requested Story Cuts; report counts, restorations, and target-range compliance. No unsupported usefulness pass threshold is implied. |
| System time | Processing, export, and total import-to-export wall-clock times separately. |

Report counts, uncertainty, language/accent subsets, and unresolved labels alongside
percentages. Zero observed critical errors is a measured outcome, not a guarantee
of zero future risk. An empty exclusion set cannot pass by vacuous precision.

## Regression response

A candidate that introduces a critical false exclusion fails the prototype gate.
Improve using authorized development data, then evaluate a frozen candidate.
If held-out examples influenced tuning, retire those examples/creators from the
held-out pool and replenish it before claiming a new independent result.
Purpose-specific withdrawal blocks further use immediately; delete controlled copies
and derived data for that purpose and track incomplete deletion until resolved.

## Implemented EC-18 operator API

`DatasetRegistry.evaluationReport(manifest:configuration:)` produces an in-memory,
JSON-encodable report from the exact reviewed annotation revisions in a frozen
manifest. It loads the manifest, checks all members' current evaluation consent,
reads authorized labels and calculates the report inside one registry transaction.
Withdrawal therefore cannot interleave with part of a report read. A withdrawn
member invalidates the whole report request. No generic held-out label read,
automatic feedback promotion, cloud request or project import is added.

The registry remains an operator boundary, not protection against a dishonest
operator with filesystem access. The candidate reference must identify an immutable,
already frozen provider/model/prompt/threshold configuration before any held-out
results are viewed. The supplied `EvaluationConfiguration` records that reference,
app version, processing configuration and media configuration. Both the manifest
and each session annotation must match the candidate reference. Actual content
integrity and representativeness remain the operator's responsibility.

### Session annotation contract (version 1)

Store a JSON-encoded `EvaluationSessionLabel` through the existing explicit
`reviewFeedback` command, with creator intent confirmed. One evaluation item is
one complete recording session; a multi-clip session must not be counted repeatedly
as separate sessions. Intake must reconcile canonical session/source identity and
creator aliases. Do not independently admit its clips as other evaluation sessions.

- `sessionReference`: unique opaque session identity within the manifest.
- `candidateReference`: the frozen candidate being adjudicated.
- `evidence`: `synthetic` or `real`; fixture reports must use synthetic. Any scored
  synthetic session makes a passing safety/time gate impossible.
- `subset`: an explicit language/accent stratum (including combined code-switching
  and accent strata when appropriate). Safety counts are reported for every stratum.
- `exclusions`: one verdict per automatically excluded utterance, including
  nonselected takes. Attached restart silence is not another decision. Outcomes
  are correct, incorrect, critical or unresolved; unresolved requires an opaque
  reason code. Critical counts as an incorrect exclusion as well as a critical loss.
- `takes`: one entry per group with an AI selection; `approved` is true, false or
  absent for unresolved. A delivery-only preference mismatch belongs here, not
  automatically in critical errors. Unresolved requires a reason code.
- `stories`: one entry per requested Story result with creator usefulness verdict,
  restoration count, requested minimum/maximum seconds and actual saved-plan seconds.
  Target compliance includes all supplied Story results; usefulness excludes
  unresolved ratings and reports them separately. No usefulness pass threshold.
- `reviewEvents`: the complete monotonic elapsed-seconds event stream described below.
- `systemTime`: optional processing, export and total import-to-export elapsed seconds.
  These are measured elapsed spans, not sums of overlapping tasks; each must fit
  within total wall time. Missing values remain missing, not zero.

Reference/reason strings are bounded opaque identifiers, not transcript text,
filenames, contact details or private explanations. Full disagreement evidence stays
in its controlled annotation records. Duplicate decision/group/Story/session IDs,
unsupported payload versions, malformed JSON, invalid targets and negative/nonfinite
measurements fail closed. Missing, unreviewed and unresolved annotation revisions
remain counted by state but their contents are not read or scored. Later reviews
cannot change an earlier frozen manifest's report.

The report returns numerators and denominators, precision and take/Story ratios,
critical/unresolved counts and reason counts, eligible session/creator counts,
subset safety counts, restoration/target counts and count/median/p90 timing summaries.
Median averages the middle pair; p90 uses nearest rank. Unresolved lower/upper
precision bounds describe the extremes if all supplied unresolved decisions were
incorrect/correct. They are **not confidence intervals or population guarantees**;
unreviewed whole items have unknown decision counts and are reported separately.

Safety fails immediately on an observed critical loss. Otherwise fewer than 500
scored exclusions, 20 contributing sessions or 10 creators is inconclusive. With
adequate real evidence, precision >=98% passes (99% remains the stretch target).
The time gate requires the same minimum evidence and completed review measurements
for every manifest session; missing/unapproved/unreviewed sessions make it
inconclusive. Median <=900 seconds passes. Safety and timing gates are reported
separately; passing one does not override failure or incompleteness of the other.

### Review event recording

`EvaluationReviewClock.measure` consumes operator-recorded events; this ticket does
not silently enable desktop telemetry or infer activity from old edit timestamps.
Start with `usable`, then record interaction, playbackStarted/playbackStopped,
inactive/active, waitingStarted/waitingEnded, approved and edited events. Supply
every transition, in order, using one monotonic clock. The observer must associate
approval and later edits with the current plan; the timer does not grant approval.

Playback counts continuously while the app is active and not waiting. Other active
time stops 60 seconds after the last interaction. Background and explicit processing
wait time do not count. Approval stops counting; an edit resumes the accumulated
session. A final unapproved plan returns no completed time. Processing/export/wall
time are separate observations, not added to active review. Existing project edits
remain raw feedback; they are never inferred to be verified labels.

### Offline fixture report (not product-quality evidence)

The secondary-metric regression fixture produces:

| Measure | Expected result |
| --- | --- |
| Exclusion precision | 1 / 1 scored; 1 unresolved; 0 critical |
| Unresolved sensitivity bounds | 50%–100%, not a statistical interval |
| Take preference | 1 / 2; 1 unresolved |
| Story usefulness | 1 / 1; 2 restorations; 0 / 1 within target |
| Active review median / p90 | 40 s / 40 s |
| Processing / export / total wall time | 12 s / 8 s / 90 s |
| Safety and review gates | Inconclusive: one synthetic session |

Reports are returned in memory and are not automatically saved. Do not retain
real reports or decoded labels as untracked files: EC-18A does not yet support
cross-item derived artifacts. Recompute through the authorized registry and discard
the returned data after use; any future durable report export needs a separately
governed retention/withdrawal workflow. The report API cannot recall bytes already
handed to a caller. No changes to project or registry schema are required.

### Remaining real-evaluation boundary

The operator must supply a purpose-consented, creator/source-disjoint held-out
corpus with reviewed labels and complete timed sessions. The EC-19 recording is
not automatically admitted: editing consent is not dataset consent, and recordings
used for diagnosis or tuning must not be presented as independent held-out evidence.
Cloud processing remains revoked unless explicitly granted again; offline report
calculation needs dataset evaluation consent but no cloud credential. Until real
measurement and coverage review are performed, EC-18 remains in progress and no
prototype quality pass is claimed.

### Implementation verification (2026-09-18)

TDD red/green cycles covered exclusion scoring, active review timing, the
manifest-authorized report, exact evidence/quality thresholds, secondary metrics,
and invalid input rejection. Eight evaluation tests include parameterized threshold
and malformed-input cases. Frozen-revision reopen, withdrawal, unreviewed-feedback
exclusion and duplicate decisions are covered. Existing registry tests separately
verify invalid admission and denial of held-out data to improvement workflows.

The full Swift regression suite passed with local macOS media-service access;
the opt-in real-camera test was skipped. All seven schema checks and whitespace
checks passed. No project/registry migration was added. Only synthetic evaluation
payloads, temporary registries and simulated timing events were used. No private
recording, API key, user consent setting or live cloud endpoint was accessed.
