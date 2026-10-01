# ADR-099: Local reference-cut reconstruction pilot

- Status: Accepted
- Date: 2026-09-18
- Scope: user-requested EC-20 pilot; does not change Creator Cut or dataset rules

## Decision

Use the existing Swift/core/media architecture for a separate local operator
executable, `EasycutReference`. It does not link EasycutCloud, use credentials,
enroll recordings in a dataset or edit project state. The user's selected final
export and raw directory are the only media inputs. Originals remain read-only.
No external service or new model is required; AVFoundation and Accelerate perform
local decoding and spectral analysis. The installed ffprobe utility was used only
for initial read-only inspection, not as a runtime dependency.

The v1 pilot extracts 16 kHz mono PCM at original presentation timestamps using
the existing single-audio/Apple stereo-fallback selection policy. It creates
24 log-frequency-band descriptors from 64 ms windows at 50 ms hops. Normalized
descriptor candidates are checked against 13-frame local context. Final timeline
cells are 250 ms; neighboring cells merge only with identical source-time offsets.
Source order is not assumed, allowing reuse/reordering in the observed reference.
This does not authorize transcript-driven reordering in ordinary editing.

Initial exploratory thresholds are contextual audio similarity >=0.80 and distinct
candidate margin >=0.06. These are uncalibrated reconstruction heuristics, not
probabilities, release thresholds or evaluation labels. Repeated evidence can
remain ambiguous; silence and insufficient evidence remain unmatched. Source
bounds and full explicit final-timeline coverage are required.

Each proposed range receives visual checks at 15%, 50% and 85%, using the unique
largest video track, display rotation and presentation-time image requests. A
16×16 grayscale mean absolute difference <=0.12 at every sample corroborates an
otherwise unambiguous audio proposal. It never confirms it. Similar repeated
scenes are not resolved by images alone; disagreement or extraction failure stays
visible. Sparse image checks do not prove every intervening frame is unchanged.

No frame-exact boundary claim: v1 explicitly reports ±250 ms boundary uncertainty,
and speed changes, edited audio, overlays and transitions may be unresolved.
This value is grid resolution, not a proven statistical error bound. A future
refinement must be verified before claiming accurate edit boundaries. Maximum
input duration is six hours per file to bound in-memory PCM decoding.

The selected 2026-09-18 pilot exposed suspected non-unit timing: strong anchors
across ten source groups advance at a median 1.2 source seconds per final second.
A diagnostic now flags groups with at least 20 strong anchor pairs 1–5 seconds
apart, median rate more than 0.05 from unity, and rate interquartile range <0.04.
Strong anchors require audio score >=0.80 and visual distance <0.08. New runs mark
these groups `unsupportedTiming`, and command-line review refuses confirmation
even for older reports. This conservative group warning neither rescales mappings
nor establishes a rate for every segment. Thresholds remain uncalibrated.

The normal-speed pilot is diagnostic, not a verified reference cut. The user
subsequently authorized constant-speed reconstruction and a local rerun. See the
[workflow](../workflows/reference-reconstruction-workflow.md#selected-pilot-result-2026-09-18)
for measured output and remaining work.

## Authorized constant-speed extension (report v2)

The initial bounded rate search tests 0.5, 0.75, 0.8, 1, 1.2, 1.25, 1.5 and 2
source seconds per final second. This is not arbitrary-rate or variable-speed
support. Audio candidates use 25-frame context with source indices sampled at
each candidate rate. Source-time offsets remain quantized to the 50 ms audio hop.

A second pass fits local affine hypotheses using anchors within 12 timeline cells
on each side (approximately three seconds). At least four anchors spanning 750 ms
must agree within 50 ms. Support chooses a stable rate; each cell must independently
pass the >=0.80 contextual audio check using 13 frames. Competing source/time
proposals retain the >=0.06 margin gate, and existing ambiguity is not promoted
away. Adjacent output cells merge only when status, source, rate and source
end/start agree exactly. These remain uncalibrated proposal heuristics, not proof
of an edit or permission to fill gaps solely from neighboring timestamps.

Report version 2 requires an explicit supported playback rate for every mapped
range and `sourceDuration = finalDuration * playbackRate`, within one microsecond
of rounding. Unmatched ranges have no rate. An endpoint-preserving affine mapping
is shared with visual-sample selection. Source review playback uses the proposed
rate; final playback stays at 1×. Independent controls are not synchronized.
Version-1 reports remain readable with their normal-speed invariant and existing
unsupported-timing confirmation guard. The diagnostic applies to mappings that
still claim normal speed, not those explicitly modeled at non-unit rates.

Synthetic public-seam tests cover known 1.2× offsets/endpoints, mixed 0.8×/1.2×
reused footage, duplicate ambiguity, isolated timing jitter, report review and
legacy compatibility, invalid rate/duration rejection, and local pitch-preserving
audio envelopes converted from 48 kHz to 44.1 kHz. No project SQLite schema changes.
Visual thumbnails use JPEG quality 0.6 and lazy loading to reduce review artifacts;
visual distances still use decoded pixels before JPEG compression.

## Private output and review

### Temporal source disambiguation

The user authorized the next local source-disambiguation step. For ambiguous or
visually disagreeing ranges at least two final seconds long, compare nine samples
at 10% through 90% of the range. Keep the existing proposed rate; this step does
not introduce rate estimation or boundary trimming. Search all supplied source
starts on the 50 ms audio grid at that rate. Require mean nine-point audio
similarity >=0.80 and every point >=0.60. Starts within 250 ms of a retained
same-source hypothesis are treated as the same coarse-boundary hypothesis. The
original proposal is always retained as a candidate, even if the longer audio
test would reject it. At most eight distinct hypotheses receive visual checks;
finding more means the search is incomplete and cannot resolve ambiguity.

Each candidate is decoded as one ordered image batch at its rate-mapped source
times. The core compares nine 16×16 grayscale frames. A machine-corroborated result
requires mean absolute difference <=0.04, worst difference <=0.08, mean distance
advantage >=0.015 over the next candidate (if any), and mean adjacent-frame change
>=0.003 in the final. Static sequences, tied alternatives, incomplete searches and
unavailable frames retain the prior uncertain proposal. These are uncalibrated
heuristics and a search among audio-compatible coarse hypotheses, not proof of
global uniqueness. Shorter ranges retain the existing three-point checks.

This may replace the proposed source when another candidate is distinctly better;
it never changes media, final boundaries, human review states, or dataset consent.
Only unreviewed input is eligible. Reports with temporal evidence use the
`-visual9-v1` configuration suffix and remain format version 2. They preserve the
compared source IDs/ranges and visual mean/worst distances for audit and inspection.
The HTML lists those alternatives; selected illustrative images come from sample
1, 5 and 9. Missing evidence never silently marks a match resolved.

The pre-agreed public matching, media-timestamp and report seams are retained.
Synthetic verification distinguishes differing takes, preserves identical/static
ambiguity, prevents truncated-search promotion, rejects missing/invalid frames,
round-trips candidate evidence, and checks ordered presentation timestamps from
the real media adapter. Original source boundary refinement remains separate.

### Progressive candidate filtering

The user authorized the next candidate-filtering slice. Keep the nine-frame
acceptance criteria unchanged and enlarge the audio-compatible candidate pool to
at most 256 coarse hypotheses. A truncated pool remains incomplete and cannot
produce a resolved proposal. Rather than decode all nine images immediately,
compare sample indices 1/5/9, then 3/7, then 2/4/6/8 (one-based).

For a candidate, the sum of measured frame distances divided by nine is a lower
bound on its eventual nine-frame mean: unseen distances cannot be negative. Prune
only if that bound exceeds 0.055 plus a 1e-9 conservative rounding tolerance.
Such a candidate cannot beat a valid winner (mean <=0.04) or violate its required
0.015 separation. This is a bound on the existing sampled-image criterion, not a
claim about all video frames. Never prune using the mean of observed frames alone.

Every survivor is measured at all nine points. More than eight survivors leaves
the search incomplete; do not rank away or conceal unexamined alternatives.
Static footage, ties, missing images, cancellation and uncertain source identity
retain the prior conservative behavior. The primary proposal is screened just
like every other candidate, and matched final boundaries/rate remain unchanged.

Reports use configuration suffix `-visual9-screening-v2` and retain schema version
2; the previous `-visual9-v1` report remains readable. Screening evidence records
pool completeness/count, survivor count, measured-frame count and each pruned
source range's sampled count/lower bound. Report validation checks bound thresholds,
source bounds, rate consistency and count accounting. The HTML explicitly labels
incomplete filtering. No project/schema migration, cloud work or training is added.

Public-seam TDD checks a true winner beyond the old eight-candidate limit, ties,
a challenger whose first frames look worse but whose remaining frames can tie,
incomplete pools, missing images, mismatched range input, saved proof round-trip
and rejection of invalid pruning bounds. These use the previously approved
matching, media and report boundaries.

### Artifact ownership

Create a new output directory, never overwrite one. JSON stores full-file SHA-256
identities, source/final microsecond ranges, machine evidence and explicit review
states. Check file metadata around extraction and again before publishing results
to detect ordinary concurrent changes. This is not protection against malicious
same-size/same-timestamp replacement. Audio PCM/features are transient; no decoded
audio file is retained.

The local HTML review page contains three paired image samples per proposed range,
source/final local playback controls and explicit confirmation/rejection. Browser
codec/file-URL support may vary; the JSON and command-line review path remain
available. Playback is independent, not synchronized or a substitute for reviewing
uncertain endpoints. Export reviewed JSON to save decisions. Each decision appends
history and advances a revision; proposal revision 1 remains unmodified. Decoded
reports must pass `validate()` before use. Confirmation of a mapping is not
confirmation of keep/exclude intent and does not create training labels.

Pilot output lives outside the repository in `~/Documents/EasycutData/reference/` (never committed), with a mode-0700 output
directory. It contains private paths and visual content and must not be published.
The user owns these local reconstruction artifacts; remove the exact pilot folder
and any separately downloaded review copies when no longer needed. Partial output
after failure is explicitly unverified and is not automatically deleted. No cloud
retention is involved. Evaluation/improvement admission still requires the shared
EC-18A registry, purpose-specific consent and explicit annotation review.
