# ADR-096: Preserve segments with zero-duration word alignment

- Status: Accepted
- Date: 2026-09-18
- Scope: EC-19; supplements ADR-077, ADR-079 and ADR-095

An authorized user-run transcription was rejected because Whisper supplied a
word starting and ending at 2.740 seconds. The user approved conservative handling
that preserves text, invents no timing and prevents unsafe automatic cuts.

For an otherwise valid segment containing a zero-duration word, preserve the
provider's complete segment text and original segment range. Replace that
segment's word alignment with one explicitly `unknown` alignment entry covering
the same segment, confidence zero. It is segment-level evidence, **not** a timed
word; no synthetic positive word duration is manufactured. The existing SQL
`token_kind = 'unknown'` supports this representation without a migration.

Point words at shared segment endpoints belong to the first containing segment
in chronological order; each provider word is accounted for once. Chunk offsets
apply unchanged to both the segment and its unknown alignment entry. Reversed,
out-of-bounds and overlapping timing, malformed responses and empty segment text
still fail. This narrowly handles zero-duration words, not arbitrary ASR errors.

New take-analysis inputs freeze `uncertainAlignmentUtteranceIDs` from the stored
alignment. Any candidate group whose complete chronological span contains one
of these utterances can only produce a non-applied Possible alternatives
suggestion, regardless of model confidence. This also covers uncertain intervening
utterances and corrected-text reanalysis. Existing evidence without this field
decodes as an empty list; prior sealed results are not changed. Explicit Creator
edits and optional Story proposals still use the original segment boundaries,
never fabricated word boundaries.

Transcription configuration becomes `whisper-segment-fallback-v3`. Explicit retry
of an older failed configuration starts a new configured attempt; it may incur
another charge. No automatic retries, consent changes or live calls are introduced.

**Historical implementation checkpoint:** Offline tests reproduce the exact reported 2.740/2.740 timing, segment-edge points,
chunk offsets, durable alignment kind, and preservation of the full Clean Cut when
uncertainty is at either candidate or between them. At that checkpoint EC-19
remained in progress, awaiting the user's explicit retry of their selected project.

**Current status (2026-09-18):** The user subsequently confirmed successful
transcription, take analysis and Clean Cut generation, and the remaining EC-19
integration checks are complete. See the [final evidence and limitations](../workflows/cloud-processing-workflow.md).
This completion does not satisfy EC-18's separate quality gate.

## Point-6 amendment (2026-09-18)

[ADR-104](ADR-104-localized-alignment-and-passage-calibration.md) versions localized
word/segment accounting, records the authorized live development evaluation and
keeps automatic passage selection disabled after the failed quality gate. It
supersedes response-wide uncertainty for new transcription attempts only; old
sealed evidence remains unchanged.
