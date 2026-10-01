# ADR-044: Use sequence distance only as a candidate-search guardrail

- Status: Proposed
- Date: 2026-08-26

## Context

Alternative attempts may cross source-file boundaries and may contain abandoned fragments or restart markers between complete attempts. A fixed time window is not an adequate semantic definition, but comparing every utterance in a long recording session is inefficient and creates unnecessary false-positive opportunities.

## Decision

V1 uses a small configurable sequence-distance guardrail as a secondary candidate-generation and efficiency filter. The guardrail may consider:

- the number of intervening utterances;
- the number of intervening clips; and
- recording-time distance as a weak additional signal.

Initial values are conservative and tuned against the representative evaluation corpus. They are not hard-coded as the meaning of “alternative take.” Non-progressing fragments, restart markers, and failed attempts must be eligible to occur inside the candidate window.

The decision hierarchy is:

1. **Sequence distance:** should these utterances be compared?
2. **Semantic similarity:** do they express the same underlying thought?
3. **Progression gate:** did meaningful story development occur between them?
4. **Confidence threshold:** may the relationship affect AI Clean Cut automatically?

Passing the distance guardrail only makes a pair eligible for evaluation. It does not establish an alternative-take relationship. If a plausible relationship falls outside the guardrail, v1 may miss it rather than expanding the search aggressively.

## Consequences

- Candidate search remains computationally bounded without conflating proximity with editorial meaning.
- Guardrail values should be changeable for experiments and evaluation, ideally without changing the stored transcript or edit model.
- Guardrail values are internal in v1; creators see resulting relationships rather than search parameters.
- The system can miss distant retries while preserving the precision-first safety bar.
- The candidate-generation stage must report enough provenance to explain why a pair was or was not evaluated.
