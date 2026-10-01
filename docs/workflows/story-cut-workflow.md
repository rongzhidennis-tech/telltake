# Story Cut operations (EC-10)

Story generation is optional. With a Story provider configured, choose **Generate
AI Story Cut** in transcript review after checking the target range (prefilled to
3–5 minutes). Nothing generates on open, refresh or Clean completion. Without a
configured provider, the button is disabled with an explanation; live provider
selection/wiring remains EC-19. Persisted proposals remain reviewable.

The Story result is a complete alternative, not a list requiring per-section
approval before use. Select AI Story Cut to see the actual duration, requested
range, limitation explanation, source transcript and proposed section removals.
The section selector shows application state, duration impact, rationale and member
text. **Restore section** creates or updates a Creator Cut as one undoable operation.
The Clean and Story baselines remain unchanged. Original-source row playback is
available; full-plan and resulting-transition playback remain EC-15.

## Core integration

Inject a `StoryCutClient` into `ProjectStoryCutCoordinator` and call
`generate(at:cleanCutID:target:configuration:)` only from an explicit request.
Choose/version a provider configuration; the core does not default to a live model.
Story interfaces use `AnalysisRunID`, `CutVariantID`, and `UtteranceID` for their
respective identities. Version-1 evidence still encodes these as strings, preserving
existing packages and adapter payloads.

The client receives chronological text, Clean-included durations and target, never
source audio/video, paths or fingerprints. It returns ordered contiguous sections,
reasons, coherence assessments and an overall explanation. The adapter contract
requires independently safe removals that are also coherent together, since the
core can retain unsupported sections conservatively.

The request records the exact Clean parent, sequence, transcript, consumed correction
snapshot and target. Completion commits an immutable full plan and normalized
recommendations together. Newest successful requests win only under their currently
selected Clean parent. Other results stay historical. Failures/cancellation retain
the attempt; there is no automatic retry. Changed targets create new child runs.

Malformed or noncontiguous output fails atomically. Unsafe sections, visual-context
overlaps, uncertain coverage, unclassified source gaps and removals that undershoot
the minimum stay recorded but non-applied. Short Clean cuts are not shortened further.
An unreachable target returns the best supported proposal and its actual duration;
duration never forces extra exclusions.

Read results with `storyCut(at:id:)`. It also accepts a Creator Cut based on a Story
Cut and reports current section inclusion. Use `restoreStorySection` with the displayed
revision, current Creator pointer and session ID. It restores the section's exact
Clean-baseline ranges, including all of its members in one transaction, without
restoring mechanically excluded takes. Existing undo/redo handles the restoration.

No new schema migration is required. Stage evidence is versioned; canonical section
membership/endpoints use recommendation tables and the current preview/render plan
uses `cut_variant_segment`. Approval is never inferred from generation.

Tests cover the required short/attainable/unattainable fixtures and persisted reopen,
contiguous multi-utterance/cross-file restoration, immutable baselines, safety guards,
exact correction context, request ordering, stale completion, failure rollback and
undo/redo. These tests establish mechanics, not real-world narrative quality.
See [ADR-083](../decisions/ADR-083-explicit-story-cut-proposals.md).
