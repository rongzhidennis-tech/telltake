# ADR-012: Remove only restart-associated pauses automatically

- Status: Superseded by ADR-014
- Date: 2026-08-18

## Context

Silence in a storytelling video can be an intentional part of delivery or visual timing. A fixed duration threshold cannot distinguish accidental dead space from emphasis, suspense, facial reaction, or meaningful on-camera action. The strongest evidence for accidental silence is its relationship to a mechanical failure or repeated attempt.

## Decision

This decision has been superseded by ADR-014. V1 retains pause duration and context metadata for internal alignment and take detection, but does not expose standalone pause removal as a creator-facing editing object. A pause may be removed as an internal consequence of excluding an abandoned utterance or selecting another take.

## Consequences

- The AI Clean Cut favors preserving potentially meaningful silence over maximizing duration reduction.
- Pause detection and pause removal remain separate internal concepts.
- A future pacing mode can reuse pause metadata without changing the source transcript or edit model.

## Open questions

- What creator-facing pacing model, if any, should be added after the utterance-centric workflow is proven?
