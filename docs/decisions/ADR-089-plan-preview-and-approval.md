# ADR-089: Resolved-plan preview and explicit approval

- Status: Accepted
- Date: 2026-09-17
- Scope: EC-15; ADR-033, ADR-052–053, ADR-063 and ADR-073

## Decision

Full preview assembles the selected persisted ordered range plan, not transcript
rows or inferred selections. Required sources are revalidated and missing ranges
are reported individually. Unused missing clips do not block the selected plan.
An empty plan is not previewable or approvable.

An in-memory coverage tracker is bound to the exact cut ID, revision, plan hash and
source-location snapshot. The trusted local playback adapter reports continuous
normal-speed progress; seeks, failure, backwards movement and unobserved gaps over
two seconds invalidate the session. A 50 ms timing tolerance accounts for callback
scheduling, not missing plan coverage. The full preview has no seeking controls;
Stop interrupts it. Source-row playback never counts as full-plan review.

After coverage reaches the exact plan duration, the store rechecks the captured
plan and sources and writes `previewed_plan_hash`. Approval is a separate explicit
creator command, revalidating readiness and writing matching `approved_plan_hash`
and `approved_at` to `cut_review_state`. AI baselines are never mutated. Completed
preview/approval persist across reopen; incomplete playback is session-local.
All existing Creator edits and undo/redo clear approval through the shared plan
writer. A changed plan cannot reuse an old completion receipt, even after returning
to the same range hash at a later revision. No schema migration is required.

This records observed playback coverage, not proof of human attention. Export
implementation remains EC-16 and must recheck sources and capture the approved plan.

## EC-19 startup correction (2026-09-18)

A user-run Creator preview with opening context removed reported a first position
of 431,668 microseconds after only 97,539 microseconds while the player item was
still unknown/not ready. The adapter had started playback and coverage immediately
after item replacement. Such a pre-ready sample is not valid watched coverage.

Keep the player paused until its item is ready, seek exactly to composition zero,
and preroll the decoder. Verify item identity, readiness and zero position before
installing coverage observers and starting normal-speed playback together. Neither
loading nor preroll credits coverage. Timeout startup after 30 seconds with a
diagnostic; Stop cancels pending startup work and late callbacks cannot restart it.
The two-second observation-gap rule, 50 ms scheduling tolerance, exact-plan receipt,
and seek invalidation remain unchanged. No source ranges or saved approvals change.

## Navigable preview amendment (2026-09-18, improvement point 2)

This amendment replaces the seek-invalidation and Stop-to-discard behavior above.
The window retains one prepared composition/player item and its security scopes,
including while paused and after playback ends. Reuse requires the same cut ID,
revision, plan hash, source-location snapshot and session source-validation
generation. Source validation and composition preparation share the bounded
inspection cache from ADR-054. Resume and navigation recheck current state without
rehashing unchanged local media. Source changes, replacement, relinking, edits,
undo/redo, cut switching, explicit refresh and window closure invalidate reuse.

The coverage tracker stores the union of actually played intervals. An explicit
seek resets its observation anchor and adds no coverage. Replaying intervals does
not count twice. Playback must cover the entire exact plan before a receipt can be
issued; seeking to the end never suffices. Unexpected jumps, invalid rates and
unobserved playing gaps still fail conservatively. Loading, pauses and seek work
are excluded from observation time. A resume precisely repositions to the last
sampled paused frame before starting, so AVPlayer clock settling cannot silently
skip a few microseconds of coverage. Row playback never counts as cut review.

Play/Pause, Resume, a seek bar, ten-second navigation and Restart from beginning
are explicit controls. Cancel loading tears down pending preparation and startup;
late callbacks cannot restart cancelled playback. Source preparation reports
completed source counts, followed by assembly and first-frame loading status.
Elapsed and total time use the current saved cut duration even before preparation.
Completion saves its receipt without discarding the paused frame. Approval remains
explicit and performs authoritative validation; export remains unchanged.
