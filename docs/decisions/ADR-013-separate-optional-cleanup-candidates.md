# ADR-013: Keep uncertain mechanical candidates separate from story cuts

- Status: Superseded by ADR-014
- Date: 2026-08-18

## Context

Standalone long pauses may be removable, but duration alone cannot establish that they are accidental. Including them in the AI Story Cut would blur the distinction between narrative shortening and uncertain mechanical cleanup.

## Decision

This decision has been superseded by ADR-014. V1 does not expose a separate Optional Cleanup list for standalone pauses or filler words. The AI Story Cut remains focused on utterance- and story-section-level decisions.

## Consequences

- The creator-facing model remains focused on meaningful speech units rather than micro-edits.
- Future pacing or cleanup modes can be added without changing the v1 utterance model.
