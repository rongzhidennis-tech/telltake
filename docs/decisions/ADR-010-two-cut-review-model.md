# ADR-010: Review a complete story cut against a clean-cut baseline

- Status: Proposed
- Date: 2026-08-18

## Context

Mechanical cleanup and story-level shortening have different levels of editorial risk. Requiring a creator to approve each story-level suggestion before seeing the shorter result would recreate the repetitive workflow the product is meant to eliminate.

## Decision

V1 produces two reviewable sequences:

### AI Clean Cut

The baseline sequence containing high-confidence mechanical cleanup only. It is the trusted reference for comparison and recovery.

### AI Story Cut

An optional shorter sequence generated from the clean cut using proposed story-level removals. It can be previewed immediately as a complete video, but its story-level decisions remain proposed rather than silently accepted as final editorial choices.

The transcript must expose the diff between the two cuts. Each story-level removal should support at least:

- preview in context, showing the transition across the removal;
- restore; and
- a clear state indicating whether the removal is currently applied in the story cut.

The creator reviews the story cut at the video/story level first, then inspects or modifies individual removals only when needed.

## Consequences

- The edit model must support named or typed cut variants and a non-destructive diff between them.
- Preview and export must be able to target either cut.
- A creator can revert individual story decisions without losing the clean baseline.
- The UI should communicate that “AI Story Cut” is a proposal, not a hidden final edit.

## Open questions

- Are creator modifications saved as edits to the story cut, or as a new variant?
- Should “Keep removed” be a separate explicit state or simply the absence of a removal?
- How should conflicts be handled if a creator changes the clean cut and then revisits the story cut?
