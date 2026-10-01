# ADR-086: Conservative utterance boundary adjustments

- Status: Accepted
- Date: 2026-09-17
- Scope: EC-12A; ADR-007, ADR-017, ADR-063–065

## Policy (defined before implementation)

Only the start of the first immutable utterance range and end of its last range
may move, within those original ranges. Every range must remain nonempty; interior
ranges and gaps remain unchanged. A fully excluded utterance must first be restored.
A plan with interior holes cannot be reshaped by this command. No word, alignment,
group, sequence or original media mutation is permitted.

The local media adapter revalidates source identity, valid sample timing and
track coverage. [ADR-090](ADR-090-camera-recording-compatibility.md) removes the
original constant-frame restriction and selects Apple stereo fallback audio. Requested endpoints snap to the nearest actual video sample
boundary in output/playback time (including MP4 edit-list offsets) inside the original range, with ties toward retained content (earlier
start, later end). Microseconds use nearest rounding. Original immutable endpoints
are also candidates so exact restoration remains possible even when transcript
timing is between frames. No pause/word inference or silence detection is added.

Audio is decoded to PCM to validate continuous sample coverage of the original
range. Video cut times map to the nearest audio sample, within one sample of the
microsecond boundary; silent sources need no audio validation. Audio does not move
the video boundary onto a conflicting grid. Invalid, inverted, empty, out-of-source
or unsupported coverage requests fail without writing.

Inspection runs before the write transaction. Commit rechecks the displayed cut
revision, Creator pointer, transcript, sequence and exact source-location snapshot.
The resolved plan, duration/hash, approval invalidation, recommendation overrides
and version-1 before/after provenance commit together. Undo/redo reuse those exact
ranges; original endpoints restore without changing immutable transcript timing.
No schema migration is needed. The operation kind is `adjust_utterance_boundary`.
