# ADR-016: Use a target duration range for story-cut generation

- Status: Proposed
- Date: 2026-08-18

## Context

The creator wants a shorter social-media video, but story quality should not be sacrificed to hit an arbitrary exact timestamp. A range such as 3–5 minutes reflects the intended format while leaving the system room to choose a coherent endpoint.

## Decision

V1 accepts a target duration range. The AI Story Cut aims to fall within that range while prioritizing coherent story structure and meaningful speech. It should show the resulting duration and make clear when reaching the range would require more aggressive editorial choices.

## Consequences

- The creator does not need to predict an exact final runtime before seeing the AI proposal.
- Story-cut evaluation should consider both range compliance and creator-perceived story quality.
- Platform-specific presets may be added later as conveniences that resolve to a duration range.
