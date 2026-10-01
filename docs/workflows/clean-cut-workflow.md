# Clean Cut operations (EC-07)

Call `ProjectPackageStore.materializeCleanCut(at:run:)` with a sealed successful
EC-06 analysis run. This synchronous persistence command must run off the UI and
Swift cooperative executor, following the existing `ProjectStoreIO` convention.
It returns an immutable `CleanCutSnapshot`; use `cleanCut(at:id:)` to inspect the
same persisted plan after reopening. No live model, editing command, or export
workflow is introduced here.

Generation begins with every active source range. Only validated high-confidence
take selections can remove exact nonpreferred utterance ranges. Multi-range
utterances remove those ranges individually, preserving intervening content.
Standalone visual spans, hidden non-speech spans, untranscribed material, and
uncertain alternatives remain included. A selection that would overlap protected
content is retained as not applied. Inconsistent analysis relationships fail
without publishing a partial baseline.

Each proposed exclusion is checked against every other utterance, including
other nonpreferred takes in the same group. Any overlap defers the entire group;
ranges that only touch at an endpoint do not overlap. A deferred group retains
all utterances as included and stores no selected candidate on its cut link.

The snapshot includes ordered ranges, total microsecond duration, a deterministic
SHA-256 plan hash, seal timestamp, originating run, and per-utterance
included/selected/excluded states. Hash input includes source IDs, original
fingerprints and algorithms, source durations, range boundaries, and order; moving
a file does not change the hash. Reading a generated plan checks its persisted
duration and hash against those source identities. Missing files do not hide an
existing plan, but unvalidated required sources block new materialization.

Generation writes the cut, ranges, all recommendation application links, completion
stage, and eligible activation atomically. Existing cuts and Creator work are not
modified. Calls for the same run return the original plan without reactivation.
Newest successful request time wins (run ID breaks ties); stale sequence/transcript
results remain in history. Source availability must still be refreshed before
playback/export. Generation never approves the plan for export.

The transcript viewer displays excluded rows dimmed with an explicit AI-excluded
label and keeps their source playback available. Preferred utterances are labelled
AI-selected. The viewer remains read-only. Restore/switch actions require the
Creator Cut workflow in subsequent tickets; arbitrary direct database edits are
not supported and are not an immutability/security boundary.

`CleanCutTests.swift` verifies exact fixture output, independent hash calculation,
uncertain/visual preservation, multi-candidate and multi-range behavior, missing
media, inconsistent evidence, rollback, historical activation, source identity,
and rejected edits of linked recommendations/sealed analysis. These are policy and
persistence tests, not evidence of live-model precision or finished export quality.

See [ADR-080](../decisions/ADR-080-immutable-clean-cut-plans.md).
