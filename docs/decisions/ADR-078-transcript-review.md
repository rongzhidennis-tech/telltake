# ADR-078: Project a read-only transcript review with preserved context

- Status: Accepted
- Date: 2026-09-16
- Scope: EC-05; implements ADR-007, ADR-033, ADR-060, ADR-062

## Decision

Review reads the current transcript and confirmed sequence without requiring a
completed analysis. Rows follow source chronology, including utterances that span
multiple source ranges. Stored non-speech spans respect their shown/not-shown
curation. On clips with explicitly complete transcription coverage, uncovered
gaps of at least two seconds are also displayed as speechless context. This is
an internal display default, not an edit threshold. Hidden shorter gaps remain
preserved; the review projection never changes a cut plan or sequence membership.
Incomplete or legacy unknown coverage never implies silence.

A Clean Cut is ready only when the current sealed Clean analysis and ready Clean
cut match the selected transcript and sequence. Editing eligibility additionally
requires validated sources used by that cut. EC-05 exposes this gate but adds no
cut-edit commands: those are later tickets. The desktop review itself remains
read-only, with no word deletion, text correction, row reordering, or timeline
editing controls. It explains when editing is locked pending Clean Cut readiness.

Playback is source context, not a rendered-cut preview. Each row retains clip-local
bounds. Playback validates all of its sources again before opening them, then
plays its ranges in order. Missing sources disable affected playback, not transcript
inspection. Reload refreshes current transcript, analysis readiness, and source state.

## Consequences

No schema migration is required. The persisted transcript, source-range,
non-speech, coverage, analysis, and cut tables already carry the needed evidence.
Two-second display curation is deterministic and testable; tuning it must not
change preservation or editing semantics. Word timing remains internal metadata.
