# ADR-026: Prefill the Story Cut target with 3–5 minutes

- Status: Proposed
- Date: 2026-08-18

## Context

The initial workflow targets Rednote-style short storytelling videos, commonly around 3–5 minutes. Requiring creators to enter a target every time adds friction, while a fixed target would overconstrain story quality and creator preference.

## Decision

The AI Story Cut generation flow pre-fills the target duration range as 3–5 minutes. The creator can edit the lower and upper bounds before starting generation. The prefill is a convenience, not a permanent platform preset or a requirement for all future content.

## Consequences

- The common v1 workflow starts quickly with a reasonable target.
- Creators can adapt the range for longer or shorter stories without changing the core model.
- The project stores the actual range used for each AI Story Cut generation request.
