# ADR-079: Persist conservative, versioned take-analysis evidence

- Status: Accepted
- Date: 2026-09-16
- Scope: EC-06; implements ADR-034–ADR-045 and ADR-069–ADR-071

## Decision

Use a dedicated asynchronous `TakeAnalysisClient` receiving chronological
recognized text and bounded candidate pairs, never source media. The adapter
assesses semantic intent, progression across the **entire** candidate span,
and preferred-take confidence. It may propose multi-candidate relationships;
every pair in a proposal must pass the configured locality guardrails. The
model must assess the whole group, not infer it transitively from pair matches.

Configuration explicitly supplies version, provider/model identity, maximum
intervening utterances/clips, semantic threshold, and automatic confidence.
No production thresholds or provider are chosen by this slice. Test values
are synthetic, not evaluated production defaults. Runtime thresholds require
development-set tuning and the existing held-out quality gate before release.

Automatic grouping requires sufficient semantic similarity, explicit absence
of meaningful progression, complete transcript coverage across the candidate
span, sufficient combined grouping/selection confidence, and a preferred member.
Uncertain progression, unknown coverage, low confidence, or a missing preferred
member produces only Possible alternatives. Meaningful progression or insufficient
similarity creates no relationship. The raw assessment is still retained.
Duplicate, foreign, unordered, nonlocal, invalid-score, or overlapping automatic
memberships reject the output atomically. Locality alone never establishes intent.

Each request creates a distinct `analysis_run` and running `take_analysis`
processing stage against a sealed transcript and confirmed current sequence.
`processing_stage.output_ref_json` holds a versioned-by-configuration evidence
envelope: exact request configuration, chronological text snapshot, eligible
pairs, unresolved coverage, and (after success) raw model assessments. This
is audit evidence, not canonical membership; run IDs, groups, candidates,
preferred takes, recommendations, and targets remain normalized SQL records.
Existing schema v3 suffices. Successful output and the run seal commit together.
Failed/cancelled requests retain their stage and input; there are no implicit
retries. Interrupted running requests remain visible in history; automatic
recovery/retry policy is deferred, not silently assumed.

EC-06 uses recognized text only and records no correction revision. Corrected-text
reanalysis belongs to EC-14. Results can finish against an older context and
remain historical; this stage does not activate current pointers or construct
cuts. EC-07 owns Clean Cut materialization and activation. EC-11 owns applying
accepted recommendations with Creator Cut provenance.

Review status and append-only review events are separate from sealed output.
Ignore, reject, defer, and reset-to-unreviewed are non-applying commands scoped
to an exact run/recommendation. Acceptance is deliberately unavailable here;
already accepted/cut-linked recommendations cannot be changed by this API.
New runs receive fresh identities and unreviewed state, without dismissal carryover.

## Consequences

The deterministic adapter fixtures verify policy and persistence without making
claims about real-model semantic accuracy. Live adapter selection, UI wiring,
and corpus quality measurement remain the existing later tickets. No edit,
source deletion, automatic visual-span removal, or cut change occurs in EC-06.

## Passage-mode amendment (2026-09-18)

[ADR-103](ADR-103-passage-level-take-review.md) replaces pair enumeration with
complete passage proposals for new passage-mode runs. Older runs keep the above
policy. New passage candidates remain review-only until point 6; schema 4 stores
their ordered memberships separately from single-utterance groups.
