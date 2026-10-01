# ADR-105: Narrow retake rough cuts with reversible boundaries

Status: Accepted for development-only use, September 18, 2026.
Related: ADR-086, ADR-099, ADR-103, ADR-104. Scope: improvement Point 6 only.

## Decision

Content selection and boundary usability are separate decisions. A verified local
retake chain defaults to its latest successfully completed individual attempt.
A failed middle or final attempt does not displace the latest completed take.
Supersession is not permission to remove: earlier essential information must be
preserved in the final take. Similarity, callbacks, summaries and new explanations
are not sufficient to establish a retake. There is no stylistic preferred-index
or confidence threshold in this development path.

Discover bounded candidate windows from adjacent transcript restarts, with 12
preceding and 18 following rows. Supply explicit candidate attempt breaks so the
model cannot bundle obvious adjacent restarts. The model supplies relationship,
individual completion states, local episode resolution, full verbatim row evidence,
and preservation evidence directly against the latest completed attempt. Validate
row identities, chronology, exact quotations, attempt membership, preserved target
membership and contradictory/null evidence. Reject bundled or invalid output;
never repair it silently or invent intra-row alignment. An unresolved window edge
or completion state withholds the chain. A continuing recording alone does not
mean that a local retry episode is unresolved.

Initial automatic eligibility is deliberately narrower than detected chains:
literal normalized equality, or an abandoned literal prefix, at least six
characters, in one source clip, with the final retry within 45 seconds and no
unaccounted intervening speech. Whitespace/punctuation normalization does not
remove negation, quantities or other words. Grounded paraphrases and shorter
fragments may be superseded while remaining ineligible. This is a development
precision precaution, not a general definition of a retake.

## Conservative default boundaries

Only semantically eligible removals reach the media adapter. Decode local 1.2 s
windows around each transcript endpoint, search at most 250 ms, protect all other
speech and stored non-speech context, and validate source identity before/after.
Missing PCM is never treated as silence. Find quiet or low-activity boundaries:
every 20 ms frame over a 160 ms guard must be below -40 dBFS RMS and at least
12 dB below nearby activity, with a peak ceiling. Search uses an additional timing
and energy margin before frame snapping; the snapped endpoint is checked again.
Alternatively, known aligned word envelopes with conservative outer margins can
support the transcript default in non-quiet background. Unknown alignment alone
is not permission to clip adjacent content. Continuous PCM and actual video
sample timing are checked. These are rough-cut safeguards, not a speech recognizer
or proof of phoneme-perfect timing. Silence alone never creates a removal, and
the intended final take's following transition is preserved.

## Persistence and editing

`EasycutRetakes` is an explicit development executable, not normal Start analysis.
Its session creates a new project backup, revalidates canonical text/ranges and
current transcript/sequence/corrections, and materializes a separate unapproved
sealed AI Clean Cut. It retains the prior Creator Cut unchanged. Applied removals
have grounded evidence and normalized recommendation targets; full rejected
responses, reasons and API usage are retained in separate development artifacts.
Broader passage and Story automation remains unchanged. Saved responses can be
replayed locally without network requests.

The creator can change a removal's start/end within 500 ms of the AI default,
limited by source bounds, intended-take start and other removals. Restoration
returns excluded source media without reconstructing the cut. Changes fork a
Creator Cut, preserve the immutable AI baseline, invalidate approval, and support
undo/redo and stale-edit rejection. The desktop Boundary editing section exposes
“Adjust AI cut edges”, numerical source-time handles and full restoration.
Ambiguous neighborhoods created by other edits are withheld rather than guessed.

Boundary review events preserve the original and adjusted times, unchanged-default
acceptance and restoration, separately from content recommendations. Optional
interaction elapsed time measures the boundary dialog, including possible idle
time; it must not be reported as measured active human review time. An unchanged
acceptance does not create a spurious Creator edit or revoke an unchanged plan.

## Evaluation and release limits

Report content correctness, default-boundary usability and creator adjustment
amount separately. Absence of a human label is unknown, not a correct removal.
Record API calls/cost, rejected evidence, withheld candidates, saved-cut agreement,
and source/reference correspondence. Development examples, synthetic fixtures and
an unreviewed source reconstruction are not held-out quality evidence.

The implementation and one real cut are demonstrated in the
[development report]. High precision,
clipped-speech rate, recall and active human review time remain unestablished.
Point 6's quality validation is not closed and Point 7 has not started.

## September 19: normal passage-analysis failure isolation

The normal app passage adapter now uses `openai-takes-passages-v6` and asks for
latest-successfully-completed selection, with unknown completion/supersession
withheld. It remains review-only; this prompt update does not make it equivalent
to the structured bounded-retake development pipeline or enable automatic cuts.

Provider response bodies are retained in local processing-stage request evidence
before decoding and validation. Per-group validation diagnostics are also saved
and shown in the analysis usage report. Invalid groups are withheld; overlapping
claims withhold every involved valid group, including overlaps with invalid
ranges. Unknown row IDs conservatively claim the whole input for conflict checks.
Independent valid groups survive. Invalid JSON/envelopes still fail the request;
raw evidence remains available. Existing failed responses cannot be recovered.

Doubao formatting-only entries are excluded from lexical alignment, as before.
They no longer generate per-utterance timestamp warnings; matching historical
warnings are suppressed in transcript presentation without changing sealed data.
Raw provider responses and lexical timing safeguards remain intact.

### Possible-retake visibility checkpoint

The transcript window exposes a read-only Possible retakes report scoped to the
latest analysis of the active transcript and source sequence. It includes raw
candidate context mapped through the saved request-local IDs to original rows
and source ranges. Rejected candidates stay diagnostic-only; valid candidates
retain the existing comparison/playback controls. Failed or old unevidenced runs
must not be presented as zero detected retakes. UI wording distinguishes candidate
attempts and model-proposed intended takes from verified completion. This does
not broaden automatic eligibility or replace the structured development policy.

### Continuous analysis and word-addressed discovery (September 19)

Normal passage analysis v7 uses the complete creator-ordered transcript with
optional immutable source ranges and word anchors in its saved input. Compact
transport v2 supplies source-local intervals, zero-based word indices and known
same-source inter-row gaps. Gaps and clip changes are context, not attempt
boundaries. Unknown time between source files is not inferred; a transcript gap
is not proof that visual material is expendable. Original rows, words, pauses,
and sealed transcript identities are not rewritten.

Candidates may specify inclusive startWordIndex/endWordIndex at their original
endpoint rows. Nil means a whole endpoint row. The mapper requires full ordered
lexical agreement before using word coordinates, validates supplied index bounds,
and preserves separate source intervals across clips. Unsupported or uncertain
word timing yields no supposedly exact range. Corrected text that disagrees with
saved words cannot borrow their alignment. Provider timing trust is retained;
this adds no mandatory acoustic alignment pass.

Sub-row candidates remain diagnostic-only in Possible retakes, with source text,
supported intervals, and an explicit withholding reason. They cannot enter the
whole-row membership or manual-removal path, which would otherwise remove more
speech than the candidate identified. This deliberately enables discovery before
introducing sub-row editing. Existing whole-row comparison remains available.
The separate bounded v2 development executable is unchanged. Neither a new
response format nor valid coordinates establishes correct retake detection.

Verification: core and cloud regression suites passed; synthetic cases cover two
attempts inside one row, preserved long gaps, cross-file intervals, unknown timing,
invalid indices, corrected-text disagreement, and legacy input decoding. A fresh
live Test23 comparison and native UI inspection remain pending. No API calls were
made for this implementation.
