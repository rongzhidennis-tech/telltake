# ADR-061: Allow explicit manual removal of visual-only spans

- Status: Proposed
- Date: 2026-08-27

## Context

Standalone visual-only spans may be meaningful, but the creator may know that a particular silent action or reaction is unwanted. The AI should not make this judgment from transcript absence, but the transcript-first interface should not prevent explicit creator control.

## Decision

V1 allows the creator to manually remove a non-speech context span from the current cut. The action is explicit, reversible, and recorded as Creator Cut provenance. It does not make the span eligible for AI Clean Cut or AI Story Cut automation.

The span remains linked to its source clip and timing and can be restored directly from its visible dimmed row.

## Consequences

- Visual-only content has a clear preserve-by-default, creator-controlled lifecycle.
- The Creator Cut model must support source ranges that are not transcript utterances.
- AI evaluation must not count creator-removed visual spans as automatic model decisions.
