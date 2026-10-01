# Selected-cut preview and approval

EC-15 adds full-cut playback to the transcript review window. Select Clean, Story,
or Creator Cut, then choose **Preview full cut**. Playback assembles the persisted
ordered segments from validated original sources, including current take choices.
It does not infer an edit plan from transcript rows.
Source tracks load asynchronously, and the repeated composition insertions run
on a dedicated media queue. The preview window remains responsive while a cut
with many segments prepares; cancellation is checked between insertions.

Required missing/unvalidated ranges appear beside the preview controls, including
the source name, source time range and availability. Full preview is disabled
until those sources are relinked and validated. Missing clips unused by the plan
do not block it. Available transcript ranges remain independently playable.

Full preview runs at normal speed with seeking controls hidden. **Stop preview**,
a seek, player failure, backwards progress or an unobserved gap over two seconds
prevents that session from completing. Reaching the end alone is insufficient:
continuous coverage must span the whole exact plan. The player clock may briefly
overshoot the end; only actual plan duration is credited.

Successful playback records the current plan's preview hash. **Approve this cut**
is a separate explicit action, available only after completion and source
revalidation. This works for unchanged AI baselines without modifying them.
Completed review survives reopen. Creator edits, including undo/redo, clear that
Creator cut's preview and approval; old session receipts cannot approve a later
revision even if its ranges return to the same hash.

Automated tests cover all three cut types, missing required versus unused clips,
partial/invalid playback, stale sessions, reopen, edit invalidation, and real
muted AVPlayer playback and seeking against an assembled media fixture. Playback
coverage is not proof of human attention. MP4 export remains EC-16 and must
revalidate sources and capture the approved plan before rendering.
