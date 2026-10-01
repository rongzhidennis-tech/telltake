# ADR-090: Import camera spatial audio and variable frame timing

- Status: Accepted
- Date: 2026-09-17
- Scope: User-requested compatibility correction to EC-02A, EC-04, EC-12A and EC-15; export contract for EC-16
- Amends: ADR-073 media compatibility and ADR-086 constant-frame restriction

## Decision

Default-camera recordings must import without manual conversion. Keep original
files and their full-file fingerprints unchanged, including spatial audio and
metadata tracks. For an Apple audio pair, select the AAC stereo compatibility
track when the other track is four-channel APAC and explicitly names that stereo
track through AVFoundation's audio-fallback association. Track order and enabled
flags are not sufficient evidence. A single audio track or silent clip retains
existing behavior. Reject other multiple-audio configurations with an actionable
message; they may represent independent microphones and must not be discarded or
mixed by inference.

Inspection, transcription extraction, source-row playback, full-cut preview and
boundary validation share this selection. Audio-only extraction explicitly builds
a composition from the selected track rather than exporting every original track.
Extraction encodes silence at empty audio edges when necessary so the provider
retains the video clock; it does not shift speech toward zero or truncate the clock.
Source-row playback also uses that selection rather than device-dependent spatial
audio defaults. The original APAC track remains available for future spatial/Audio
Mix support; ordinary stereo output does not preserve those capabilities.

Accept constant and variable frame rates, including different rates across clips.
All ranges, playback, and boundary snapping use source presentation timestamps and
sample durations, never a nominal-fps grid. Composition insertion preserves source
and target interval durations and audio offsets, including empty audio/video edges
within the movie duration; no automatic retiming or video conversion
is introduced. Inspection still rejects invalid/non-increasing presentation times.
The existing rational frame-rate field remains descriptive identity evidence (the
reciprocal of the first observed interval), unchanged for existing source records;
it is not the clock for playback or a cross-clip compatibility constraint.

Dimensions, orientation, audio presence/sample rate/channel count, source identity,
and coverage checks remain enforced. No persistence migration is required.

EC-16 is still pending. Its renderer must use this same audio selection and preserve
source timestamp spacing and synchronization in the captured range plan; it must
not restore the old constant-rate gate or sum the alternate stereo/spatial tracks.

## Evidence and verification

Apple documents the AAC stereo compatibility track and four-channel APAC spatial
representation in [WWDC25 session 251](https://developer.apple.com/videos/play/wwdc2025/251/)
and [TN3177](https://developer.apple.com/documentation/technotes/tn3177-understanding-alternate-audio-track-groups-in-movie-files).
The supplied IMG_8685.MOV has audio track 3 falling back to track 2 and variable
video intervals around 60 fps. Synthetic regression tests cover variable-rate and
mixed-rate sequence confirmation, original-time preview mappings, actual-sample
boundary edits, audio extraction and rejection of independent audio tracks.
Optional local tests use EASYCUT_REAL_MEDIA_DIR to exercise creator recordings
without adding them to fixtures or uploading them.

Verification on 2026-09-17: 164 Swift tests passed, including all 31 supplied
IMG_*.MOV files, full-length and discontiguous preview ranges, stereo extraction,
VFR frame snapping, preservation of audio offsets/tails, and actual AVPlayer
playback with seek rejection. The test run used the native Swift build system,
an isolated build directory and macOS media-service access. Original media stayed
local and unchanged.
