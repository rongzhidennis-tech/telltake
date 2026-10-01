# ADR-043: Keep excluded content visible and reversible

- Status: Proposed
- Date: 2026-08-26

## Context

The product promises that AI decisions are visible and reversible. Hiding excluded candidates or story sections would force the creator to hunt for what changed and would weaken trust in the transcript as the editing source of truth.

## Decision

Excluded transcript content remains visible in the main transcript as a visually secondary, dimmed state. It does not play as part of the current cut by default, but it retains its source link and exposes a direct restore action.

The same visibility rule applies to:

- AI Clean Cut exclusions;
- alternative-take candidates not selected in the current cut;
- AI Story Cut story-level removals; and
- Creator Cut removals.

Collapsed take groups may hide their underlying candidates until expanded, but expansion must reveal the excluded alternatives. Story-level removals must remain discoverable in the transcript without requiring a separate hidden diff mode. AI Story Cut removals appear directly as dimmed contiguous sections with restore actions and context preview from the same surface.

## Consequences

- The transcript visibly communicates kept, excluded, selected, alternative, and suggested states.
- Restore actions can be local and immediate.
- The UI must distinguish “excluded from this cut” from “not in the current canonical sequence” and “removed from a take group.”
