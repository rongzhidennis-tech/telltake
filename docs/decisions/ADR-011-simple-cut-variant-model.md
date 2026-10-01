# ADR-011: Preserve two AI baselines and one creator working cut

- Status: Proposed
- Date: 2026-08-18

## Context

Creators need to experiment with story-level suggestions without losing the mechanically cleaned reference or the AI’s original shorter proposal. Exposing full version-control concepts would add unnecessary cognitive load to v1.

## Decision

V1 presents three simple cut variants:

1. **AI Clean Cut** — preserved baseline containing high-confidence mechanical cleanup only.
2. **AI Story Cut** — preserved original AI proposal for a shorter, tighter story.
3. **Creator Cut** — editable working version derived from whichever AI cut the creator explicitly chooses as the editing starting point.

The Creator Cut is created automatically the first time the creator manually changes the chosen AI cut. The creator may start from either the AI Clean Cut or the AI Story Cut. Subsequent restores, removals, take switches, and boundary adjustments update the Creator Cut only. The AI Clean Cut and AI Story Cut remain intact and available for comparison or recovery.

All variants are non-destructive edit decisions over the same underlying source media; creating a variant must not duplicate the original video file.

Preference learning from creator overrides is out of scope for v1, though the edit model should preserve enough event history to support it later.

## Consequences

- The UI can stay simple: two preserved AI references and one current editable cut.
- Export and preview must allow the creator to target any of the three cuts.
- The system needs provenance for each edit so it can distinguish AI decisions from creator overrides.
- A creator can compare a 4:32 Creator Cut against the original 4:26 AI Story Cut without losing either reference.

## Open questions

- Should Creator Cut creation be visible as a one-time state change or remain implicit?
- How should a regenerated AI Story Cut interact with an existing Creator Cut?
