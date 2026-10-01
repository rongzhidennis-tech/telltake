# ADR-009: Collapse take groups while exposing the AI decision

- Status: Proposed
- Date: 2026-08-18

## Context

Showing every failed and repeated attempt in the main transcript would make a 20–30 minute recording difficult to review. However, hiding the fact that the system selected one take would undermine trust and make mistakes harder to find.

## Decision

The default transcript view collapses a detected take group into one canonical utterance row representing the currently selected take. The row must clearly indicate that an AI take-selection decision occurred and provide an obvious path to expand the group.

The default visible trust signal should use plain language in the form:

> AI selected Take 3 of 3 · Show alternatives

The exact take number is illustrative; the row should communicate which candidate was selected, how many candidates were found, and provide the expansion action.

When expanded, the creator can inspect the underlying attempts, preview or compare them, switch the selected take, and restore an excluded attempt. The collapsed state is a presentation choice only; it must not discard the source attempts or their edit history.

Alternatives expand inline beneath the canonical row, preserving the transcript’s surrounding story context and the group’s relationship to the main sequence.

Within the expanded group, alternatives appear in chronological recording order. The AI-selected take is highlighted, and each candidate is individually playable so the creator can compare and switch versions directly.

## Consequences

- The main review flow stays compact and focused on the proposed story sequence.
- AI-selected take groups need a distinct visual state rather than appearing identical to ordinary transcript rows.
- The collapsed state should communicate the decision without exposing an opaque confidence score as the primary explanation.
- The UI needs a stable relationship between a canonical row and all of its source alternatives.
- Inline expansion should preserve enough source ordering and context to make the retries intelligible.
- Undo, restore, and take switching must work without requiring the creator to return to the traditional timeline.

## Open questions

- Should the collapsed row also show a short reason, or is the selected-take count sufficient?
- Should the creator see a confidence indicator, a human-readable reason, or both?
- How should comparisons work when takes have different durations or wording?
