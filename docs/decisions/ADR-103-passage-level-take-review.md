# ADR-103: Detect and review complete passage takes

- Status: Accepted implementation; live quality evaluation pending
- Date: 2026-09-18
- Scope: Improvement point 5; EC-06/07/11/13/19
- Amends: ADR-079 candidate contract, ADR-034/044 local search restrictions for new
  passage analysis, ADR-041 single-utterance candidate representation, ADR-102
  take transport/version. Old versions remain readable under their existing rules.

## Decision

Use `openai-takes-passages-v4` on Luna with medium reasoning and the existing
no-cache-write/usage-accounting policy. Send one complete chronological numbered
transcript, clip ordinals and uncertainty metadata. Do not construct or send the
old eligible-pair list for passage-mode runs. Old evidence retains its pair lists;
Story configuration is unchanged.

Return disjoint groups of two or more complete attempts. Each candidate has
inclusive start/end utterance IDs and a list of unique facts at risk. A group has
a zero-based preferred-candidate index (nullable), a reason, semantic score,
progression assessment and confidence. Short IDs map to the exact input's canonical
IDs. The application expands endpoints into contiguous source-order membership;
unknown, reversed, overlapping or conflicting intervals and invalid preferences
fail the whole output. No generated replacement speech or provider timestamps
become source ranges.

The prompt requests complete multi-sentence/paragraph attempts, including long
paraphrases, multiple restarts and cross-clip retries. It distinguishes elaboration,
negation, corrections and intentional callbacks. Preference uses textual coherence
and completeness; vocal delivery cannot be inferred from text alone.

All new passage recommendations are **non-applied Possible alternatives**. Existing
semantic/progression gates remain; meaningful progression is not proposed as a
retry. Point 6 must validate passage timing and calibrate automatic selection
before any automatic passage removal is enabled. Confidence alone cannot enable it.
Clean materialization validates normalized membership/preference against evidence
and preserves all proposed passage content.

## Persistence and editing

Schema migration 0004 adds `passage_take_candidate` and `passage_take_member`.
Candidates are scoped to immutable recommendations, ordered, and carry a unique
nullable group preference via `is_preferred`; members are ordered foreign keys
to immutable utterances. Evidence retains reasons, unique facts, original boundaries
and provider output. Existing single-utterance groups and Creator Cuts are unchanged.
Opening schema versions 1–3 upgrades transactionally to 4.

Take comparison lists complete passage candidates, original text, inclusion,
recommendation and unique-fact warnings. Play whole take includes source context
between its first/last utterance, across clips. It does not earn cut-approval coverage.
Keep this take explicitly confirms the risk, restores the selected candidate's
speech and excludes other candidates' speech as one reversible Creator operation.
Restore whole take restores its utterances without changing other candidates.
Both preserve intervening visual/context gaps; automatically trimming those gaps
is deferred to point 6. This conservative boundary is stated in the confirmation.

Edits validate source availability, current sequence/transcript, revision and Creator
pointer. They atomically fork if needed, replace the resolved plan, record provenance
and invalidate preview/approval. Undo/redo use the existing versioned plan evidence.
Choosing does not rewrite the AI's preference or remove a prior result.

## Verification and limits

Offline fixtures cover long unequal multi-sentence spans, three candidates,
foreign/reversed/overlapping endpoints, meaningful progression, uncertain coverage,
unique facts, no automatic exclusions, normalized persistence, immutable AI plans,
whole-take selection/restoration, stale revisions, undo/redo, historical decoding
and schema 1/2/3 upgrades. A disposable Test23 UI fixture is explicitly marked
synthetic; its chosen passages are not claimed to be actual repeated takes.

Live Test23 comparison, Luna detection quality, false-suggestion rate and human
review-time measurement are pending. Additional live requests require the pending
user approval; the earlier approval was for one point-4 request. Visual interaction
was blocked because macOS was locked. No point-5 live transcript request has been
sent. Offline tests establish the editing contract, not semantic model quality.

## Point-6 amendment (2026-09-18)

[ADR-104](ADR-104-localized-alignment-and-passage-calibration.md) versions localized
word/segment accounting, records the authorized live development evaluation and
keeps automatic passage selection disabled after the failed quality gate. It
supersedes response-wide uncertainty for new transcription attempts only; old
sealed evidence remains unchanged.

## Latest-completed product-prior amendment

ADR-104 now specifies the accepted “latest successfully completed take wins”
prior for verified retake chains. It supersedes free stylistic preference in the
proposed next architecture: assess relationship, completion, supersession and
essential-information preservation, then derive the Intended take in the core.
The v4/v5 implementation and historical evidence have not yet been migrated to
that structured policy. Automatic passage cuts remain disabled.
