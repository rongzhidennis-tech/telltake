# ADR-097: Preserve text at zero-duration segment boundaries

- Status: Accepted
- Date: 2026-09-18
- Scope: Test23 transcription bug fix; supplements ADR-095 and ADR-096

Test23 returned a segment with start and end both at 29,959,999 microseconds.
ADR-096 handles point words but deliberately rejects point segments. This fix
extends that rule only where a neighboring positive-duration provider segment
supplies an existing range at the exact shared boundary.

Append a nonempty point segment's text to the preceding segment when its end
matches the point. Otherwise prepend it to the following positive-duration
segment only when its start matches the point. Consecutive points at that same
boundary retain their text in provider order. Preserve text verbatim, including
any provider-supplied whitespace; do not deduplicate possible repetitions.
Mark the combined segment's alignment unknown with confidence zero, reusing the
existing ADR-096 protection against automatic take cuts. Never create a positive
duration for a point or extend a neighbor's original range. Chunk offsets remain
unchanged. The combined row is less precise and must remain conservative.

An empty point segment is an ignorable endpoint marker; every provider word must
still be accounted for by a valid segment. Empty positive-duration segments,
reversed timestamps (including reversals hidden by microsecond rounding), overlaps,
out-of-bounds times, and nonempty points without a shared positive range remain
errors. No guessed gap coverage or whole-clip timing fallback is introduced.

New attempts use `whisper-segment-fallback-v4`. Existing sealed transcripts remain
unchanged. No schema migration, automatic retry, or cloud dispatch is part of this
change. The failed Test23 attempt still requires an explicit user retry.

Verification: a synthetic adapter regression fails on the reported 29.959999
endpoint before the fix. Additional cases cover leading/trailing/consecutive
points, empty endpoint markers, two-chunk offsets, and invalid/unanchored timing.
Existing core tests verify unknown alignment persists across reopen and prevents
automatic Clean Cut removal at candidate and intervening utterances.
