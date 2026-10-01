# ADR-098: Keep complete segment text when word timing cannot be assigned

- Status: Accepted
- Date: 2026-09-18
- Scope: Test23 transcription fix; supplements ADR-096 and ADR-097

Test23 returned `unassigned_words; values=[448,458]`. The diagnostic establishes
that ten words failed midpoint-based assignment, but contains neither their text
nor timings. A synthetic adapter test reproduces precisely these counts with ten
words in a gap between segment intervals. This is a reproduction of the failure
class, not a recovered copy of Test23's provider response.

Independent word/segment estimates need not nest perfectly. When the existing
assignment would reject an unassigned word, a segment without assigned words, or
a word extending outside its assigned segment, retain the provider's valid
segment ranges only if all three ordered text streams agree: concatenated word
text, concatenated normalized segment text, and the full response transcript.
Comparison uses Unicode canonical composition and ignores only punctuation and
whitespace. Do not fuzzy-match, reorder, deduplicate repeated text, remove digits
or symbols, or silently discard words. Require nonempty lexical content.

On that fallback, mark **every segment in the response** as unknown alignment with
confidence zero under ADR-096. Preserve displayed segment text verbatim and keep
its original endpoints; do not guess missing word timing or expand ranges across
gaps. This may yield fewer automatic Clean Cut suggestions, deliberately. Chunk
source offsets and the existing core protections remain authoritative.

Before considering fallback, validate **every** provider word for nonempty text,
finite and in-bounds time, nonnegative duration, and chronological non-overlap.
Check reversal before microsecond rounding. This includes unassigned words that
the old midpoint filter never inspected. Invalid segment ranges and unanchored
point segments remain rejected under ADR-097. A text mismatch remains rejected.
No success path truncates words simply to satisfy the assignment count.

New attempts use `whisper-segment-fallback-v5`. No schema migration, cloud retry,
model change, or modification of saved successful results is introduced.

Verification covers the exact synthetic 448/458 rejection, crossing boundaries,
segments without assigned words, punctuation and bilingual text, repeated/missing
and reordered content, full-transcript disagreement, invalid unassigned timing,
chunk offsets, and persistence/automatic-cut protection for unknown alignment.
Test23's original response was not stored; real end-to-end completion remains to
be confirmed by the user's next explicit attempt.

## Point-6 amendment (2026-09-18)

[ADR-104](ADR-104-localized-alignment-and-passage-calibration.md) versions localized
word/segment accounting, records the authorized live development evaluation and
keeps automatic passage selection disabled after the failed quality gate. It
supersedes response-wide uncertainty for new transcription attempts only; old
sealed evidence remains unchanged.
