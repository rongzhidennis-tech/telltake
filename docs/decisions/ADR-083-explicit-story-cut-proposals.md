# ADR-083: Persist explicitly requested Story Cut proposals

- Status: Accepted
- Date: 2026-09-16
- Scope: EC-10, implementing ADR-004, ADR-010, ADR-015, ADR-016 and ADR-025–027
  under ADR-073's exact-parent and result-activation rules.

## Decision

`ProjectStoryCutCoordinator.generate` is called only by an explicit creator action
with a validated target range. The desktop pre-fills 3–5 minutes and permits editing
both bounds. Review, opening, Clean generation and ordinary edits do not invoke it.
Each request creates a new child analysis run of the selected sealed Clean Cut,
copying its sequence, transcript and consumed correction revision. Saved newer text
overlays are not silently consumed. Pending requests leave successful pointers alone.

The provider seam is a text-only `StoryCutClient`, supplied with source-chronological
utterances, Clean inclusion durations, target and versioned provider configuration.
It returns ordered, disjoint contiguous utterance sections, reasons, an explicit
coherence assessment, and an overall explanation. Sections must be independently
safe to omit and coherent together; the core may conservatively retain any section.
No concrete live model, confidence threshold, retry policy or cloud service is chosen
here. Deterministic adapters verify the slice; live adapter/composition wiring is
EC-19. The desktop disables generation and explains why if no adapter is configured,
but can inspect and restore persisted results.

Each section becomes one continuous source-order interval (possibly spanning clips),
intersected with the exact Clean plan. The target member list must contain every
intervening utterance; overlapping or reordered sections and foreign IDs are invalid.
Malformed output fails the request without partially creating an AI result.

Uncertain coherence, incomplete coverage, explicit visual/non-speech overlap, and
unclassified gaps remain preserved. In particular, a gap between spoken ranges is
not presumed disposable merely because it falls inside a proposed story section.
Such a section stays recorded as non-applied rather than being split into hidden
non-contiguous removals. Proposals that would undershoot the requested minimum stay
non-applied. A Clean Cut already at or below the target maximum is preserved.
Within these guards, apply the provider's supported sections in source order. Do
not invent additional removals to force the target. Actual duration, target status,
retained suggestions and a limitation explanation accompany the result.

## Persistence and reversal

Existing schema-v3 tables suffice. A request stores version-1 stage evidence;
completion atomically seals the run, persists an immutable `ai_story` cut with its
exact Clean parent and target, full ordered segments and hash, inherited Clean
applications, normalized `story_removal` recommendations/targets, and unreviewed
review state. Applied means part of the proposal, not creator acceptance or approval.
Successful activation obeys ADR-073: newest successful request for the selected
Clean parent wins; late results from an old parent/sequence remain historical.
Failure/cancellation retains the attempt and does not replace existing results.

Section restoration is one Creator Cut command, not a loop of separately committed
utterance edits. It restores only the section's Clean-baseline ranges, so mechanically
excluded takes remain excluded. The shared first-edit fork, group seeding, plan,
recommendation override, approval invalidation and history transaction applies.
`restore_story_section` uses the existing complete version-1 edit evidence and is
undoable/redoable under EC-09. AI baselines and global review decisions stay immutable.
Arbitrary section removal and visual-context editing remain EC-12.

## Verification boundary

Synthetic short, attainable and unattainable targets verify mechanics, not narrative
quality. Fixtures also cover multi-utterance/cross-file spans, preserved gaps/visuals,
unresolved coverage, exact correction context, immutable baselines, activation order,
failure rollback and section restoration with undo/redo. The persisted plan is ready
for a renderer; actual full-cut and transition playback remain EC-15. Live quality
and provider selection remain the evaluation/integration tickets.
