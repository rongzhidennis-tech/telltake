# Take-analysis operations (EC-06)

`ProjectTakeAnalysisCoordinator(store:client:)` performs a single explicit
`analyze(at:configuration:)` request. Supply a `TakeAnalysisClient` and a
`TakeAnalysisConfiguration` with an explicit version, provider/model identity,
locality limits, semantic threshold, and automatic confidence. No live provider,
production defaults, implicit retries, or desktop analysis action is configured.

The project must have a sealed current transcript for its confirmed sequence.
The coordinator persists a new run before invoking the adapter. The adapter
receives chronological recognized text, including intervening utterances,
candidate-pair eligibility and unresolved clip coverage. It must evaluate intent
and progression across the entire group span, not merely match words or chain
pairwise similarities. Every proposed group member pair must be eligible.
Clip distance counts only clips strictly between the earlier take's final clip
and the later take's first clip. Clips occupied by either take do not count
toward this limit, including when both takes span multiple source files.

The coordinator dispatches request, completion, and failure persistence through
`ProjectStoreIO.run`. Public input uses typed run/sequence/transcript identities,
and snapshots expose `TakeAnalysisStatus`. Stored evidence retains its existing
string encoding for these IDs, so older runs remain readable. Canonical utterance
IDs are carried explicitly through review rows rather than parsed from display IDs.
Initial analysis and corrected-text reanalysis share provider evaluation,
cancellation checks, and durable failure handling. Reanalysis then materializes
its Clean Cut as a separate step. `analysisHistory(at:)` exposes a typed
`AnalysisHistoryStatus`, including `awaitingCleanCut` for a sealed run whose Clean
Cut has not committed yet.

Results with sufficient confidence, no progression, complete coverage and an
explicit preferred member produce take-selection recommendations. Uncertainty
produces only Possible alternatives. Meaningful progression and dissimilar
utterances do not form relationships. All returned assessments remain audit
evidence, including those not promoted to recommendations. Malformed/nonlocal
output fails as a whole without partial groups or recommendations.

Use `ProjectPackageStore.takeAnalysisRuns(at:)` for retained run identities and
`takeAnalysis(at:run:)` to inspect request context, status, and recommendations
after reopening. Failed/cancelled stages retain input and generic error codes
without retaining arbitrary provider exception messages. Interrupted running
stages are visible but have no automatic resume policy yet.

`reviewTakeRecommendation(at:run:recommendationID:status:)` supports Ignore,
reject, defer, and reset-to-unreviewed. It appends a review event while preserving
AI output. It cannot accept recommendations or change an already accepted or
cut-linked result, regardless of the link's application state;
acceptance belongs to a future atomic Creator Cut edit. A new run starts with
fresh review state, even for the same hypothesis.

Analysis output does not alter source media, transcript content, current pointers,
or existing cuts. A result finishing after a sequence change remains historical.
EC-07 builds the Clean Cut; EC-11 supplies review UI and applying edits; EC-14
adds corrected-text reanalysis; EC-19 connects the live adapter.

The tests in `TakeAnalysisTests.swift` use synthetic adapter evidence, not
real semantic inference or evaluation-corpus data. They cover cross-file and
three-candidate groups, intervening progression, uncertainty, incomplete coverage,
locality, invalid output rollback, immutable results, review isolation, provider
failure, historical completion, multi-range clip distance, cut-linked review
protection, and evidence-format compatibility.
See [ADR-079](../decisions/ADR-079-versioned-take-analysis.md).
