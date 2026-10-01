# Corrected-text reanalysis (EC-14)

Save transcript corrections, then explicitly choose **Reanalyze using corrected
text**. It consumes all saved corrections for the displayed transcript. A newer save
does not change an already requested run; stale requests require refreshing.
The desktop button requires an injected provider/configuration. Live provider wiring
remains EC-19; tests use deterministic text-only providers.

`ProjectTakeAnalysisCoordinator.reanalyze` freezes the request, evaluates it, seals
take analysis and materializes a new immutable Clean Cut. Pending, failed and older
late completions cannot displace a newer successful Clean result. Display corrections
saved while processing remain intact. Clean materialization failure leaves the
sealed take result available for retry via `materializeCleanCut`.

Enable **Previous analysis** to add earlier cuts for the current confirmed sequence
and transcript to the cut picker. Selecting one inspects its plan and enables the
ordinary guarded edit workflow, without reactivating its analysis as the default.
An old Creator Cut is labeled **Earlier analysis**. Editing a different AI baseline
creates separate Creator work; it does not overwrite or merge an earlier Creator.
Cut labels also disclose when display corrections differ from the consumed snapshot.

`analysisHistory(at:)` returns all project Clean requests, status, transcript and
correction context, and IDs of their Clean/Story/Creator cuts. Historical IDs can be
read with the existing cut/analysis APIs, including across older transcripts; only
the current transcript/sequence is eligible for editing. Opening/reviewing history
does not write pointers or start analysis.

See [ADR-088](../decisions/ADR-088-corrected-text-reanalysis-history.md).
