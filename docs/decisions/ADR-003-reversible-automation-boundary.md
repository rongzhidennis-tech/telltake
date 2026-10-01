# ADR-003: Automate high-confidence mechanical cleanup, suggest creative edits

- Status: Proposed
- Date: 2026-08-17

## Context

The product should reduce rough-cut work quickly, but creators must remain in control of meaningful storytelling decisions. Raw recordings contain both mechanical recording errors and subjective editorial material. Treating both categories the same would either make the product too timid to save time or too aggressive to trust.

## Decision

V1 uses a two-tier decision boundary:

### Automatically applied to the proposed cut

Only high-confidence mechanical decisions, such as:

- clearly abandoned false starts;
- an obvious failed attempt immediately followed by a complete retry;
- repeated takes that confidently express the same thought; and
- accidental dead space directly associated with a restart.

When a take group is high confidence, the system may select a recommended take, often the final complete take or the take with the strongest delivery, and exclude the alternatives from the proposed cut.

### Suggested for creator confirmation

Subjective or creative judgments, such as whether a story segment is boring, unnecessary, off-topic, too long, or should be shortened for pacing.

Automatic exclusion is non-destructive: the source media remains untouched, and every decision is visible and reversible from the transcript. The creator can restore excluded content or switch to another take with minimal effort.

## Consequences

- The editor needs explicit visual states for kept, automatically excluded, creator-excluded, recommended take, and alternative take.
- Confidence alone is not sufficient; the system must expose enough context for the creator to understand why a segment was excluded or selected.
- Low-confidence cases should degrade into visible suggestions rather than silent edits.
- Clean Cut automation should optimize for precision over recall; when in doubt, preserve the utterance.
- Evaluation must separately measure mechanical cleanup accuracy and take-selection quality.

## Open questions

- What evidence must the UI show for a creator to trust a take recommendation?
- How should borderline cases be ranked and presented?
- What is the cost of a wrong automatic exclusion compared with leaving extra material in the cut?
