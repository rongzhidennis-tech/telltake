# ADR-073: Reconcile the v1 product and persistence contracts

- Status: Accepted
- Date: 2026-09-11
- Scope: documentation-review fixes requested by the project owner
- Amends: ADR-014, ADR-018, ADR-028–ADR-032, ADR-042, ADR-045–ADR-049, ADR-063

## Context

The documented v1 workflow is adopted as the implementation baseline, but several
historical Proposed ADRs and persistence examples disagree with that workflow.
This decision resolves those conflicts. Existing Proposed records remain historical
proposals; only the behavior incorporated into the current context/product brief
or an Accepted decision is an implementation requirement. It does not adopt every
unresolved question or incidental statement in those records.

## Decision

### Analysis and correction lifecycle

A `clean_analysis` or `reanalysis` run produces one immutable AI Clean Cut.
Each explicitly requested `story_cut_generation` run references that Clean run
through `parent_analysis_run_id` and produces one AI Story Cut whose parent is
the exact Clean Cut. Its transcript, sequence, and correction revision match the
parent; new corrected text requires explicit Clean reanalysis first. A changed
Story target creates another Story run. History groups Story runs under the Clean
run rather than presenting them as unrelated generations of the whole project.

Saving or reverting text creates a complete correction snapshot only. Requesting
analysis creates pending work without changing current successful-result pointers.
Only successful completion can activate results. Select the newest successful Clean
run for the current sequence by request time (ID breaks ties); an older run that
finishes late cannot replace it. Successful Story results change the Story pointer
only when their parent remains the selected Clean run, and the newest successful
Story request for that parent wins. Other results remain in history. Changing the
confirmed sequence clears incompatible AI/transcript/correction pointers while
preserving all previous runs and Creator Cuts in history; the active Creator Cut
pointer is cleared when changing sequences so old work is not presented in the new
sequence context.

`current_analysis_run_id` identifies the selected Clean run, never a pending job or
Story child. `current_correction_revision_id` identifies saved display corrections
for the selected transcript; analysis retains its own immutable consumed revision.
When switching transcripts, restore the newest saved correction snapshot for that
transcript (or NULL). Selecting prior history must switch the associated AI and
transcript context together. Existing Creator Cuts remain run-bound and require an
explicit choice before editing; selection never merges or overwrites creator work.

### Creator take groups

Persist Creator Cut group identities, current members, and preferred utterance
separately from immutable AI groups. Seed these current rows when forking an AI
baseline. A confirmed group requires at least two members and an explicit preferred
member before collapse. Membership removal does not restore media into the cut.
Removing the preferred member requires choosing a replacement in the same action;
a group with fewer than two members dissolves without changing cut inclusion.
An utterance belongs to at most one current group per Creator Cut. Group edits,
resolved segments, recommendation state, revision, and audit operations commit
atomically. Reopen reads group state directly, without replaying edit history.

### Preview approval and export

Any selected cut—unchanged Clean, unchanged Story, or Creator—can be previewed,
approved, and exported. Approval is separate from immutable AI output and records
the exact plan hash. Manual edits invalidate approval; playback approval is never
inferred from AI generation. “Complete preview” means successful playback coverage
of the entire selected plan at its current revision, with no unresolved ranges.
Approval then requires an explicit creator action. No manual content change is
required just to export an AI cut.

Each export snapshots the ordered source ranges and plan hash when requested.
Editing can continue, but the export renders its captured plan. Before rendering,
required sources must still validate; a changed source causes failure, not silent
substitution. Completed outputs keep their captured plan identity. Missing imported
clips unused by the selected cut do not block that cut's full preview/export.

The original restriction below is amended by [ADR-090](ADR-090-camera-recording-compatibility.md): variable/mixed frame timing and Apple stereo/spatial fallback pairs are supported using original timestamps and selected stereo audio.

For the initial macOS renderer, active source clips must have compatible display
dimensions/orientation, aspect ratio, constant rational frame rate, and audio track
presence/sample rate/channel count. Varying frame rates or mismatched properties
are rejected before analysis with the offending clips and properties identified.
The creator can exclude incompatible clips or prepare compatible copies and import
them as new sources. V1 does not silently resize, rotate, resample, or normalize.
Encoding may change to create the MP4; preserving audio means preserving included
source audio content and timing, not bit-identical encoded bytes. Decoder/encoder
format support is selected and documented in EC-19 before real-media validation.

### Evaluation and consent

Tune only on improvement-consented development data. Evaluate a frozen candidate
on a held-out corpus whose source recordings and creators are disjoint from tuning
data. Never move a held-out failure into tuning while reporting that set as held-out;
retire contaminated items and replace them before the next release gate.
Purpose-specific consent and dataset isolation must exist before real recordings
enter either dataset. Synthetic fixtures do not establish product quality.

The initial prototype gate is at least 98% mechanical-exclusion precision (99% is
a stretch goal), zero observed critical false exclusions, and at least 500 automatic
exclusion decisions across 20 held-out sessions from at least 10 creators. Insufficient
data is reported as inconclusive, not passing. These are provisional prototype
acceptance thresholds, not a claim of a population error bound; report counts and
uncertainty alongside percentages. Report code-switching and accent subsets too.

Count one automatic utterance-exclusion decision per utterance, including nonselected
takes; attached restart silence is part of that decision. Precision is verified
correct exclusions divided by all automatic exclusions. Report take-selection accuracy
separately as groups with a creator-approved preferred take divided by adjudicated
selected groups. A delivery preference mismatch between equivalent takes is a take
error; loss of unique intended story meaning is critical and also a false exclusion.
Creator intent is authoritative for keep intent; an expert reviews disputed labels
with the creator and unresolved labels are reported separately, not scored as correct.
Freeze labels before scoring a candidate.

Use the same representative timed sessions for the 5–15 minute review target: report
median and 90th percentile active time, with median <=15 minutes as the prototype
time gate. Time includes review playback and interaction after usable results, pauses
when the app is inactive or explicitly waiting on processing, and stops on approval
of the current plan. Record idle pauses after 60 seconds without playback/interaction.
Resume measurement if the cut is edited again. Export and total wall-clock time remain
separate. Story usefulness is the proportion of requested Story Cuts creators judge
usable as a starting point; report that alongside restorations and duration compliance.

## Consequences

The schema needs current creator groups, plan-specific approval, and export snapshots.
Schema version 2 adds these without rewriting migration 0001. Automatic constraints
protect duration ranges; service transactions enforce cross-context and lifecycle
rules. The roadmap includes early consent, boundary edits, and real adapter/application
integration with a complete local-video acceptance run. No future UI or provider
implementation is implied by adding its persistence contract.
