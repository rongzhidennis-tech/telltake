# ADR-025: Generate the AI Story Cut only after explicit target input

- Status: Proposed
- Date: 2026-08-18

## Context

The AI Story Cut requires additional story-level analysis and makes more subjective recommendations than the AI Clean Cut. Creators may want only the mechanically cleaned result, and target duration is a meaningful input to story selection.

## Decision

After the AI Clean Cut is ready, the creator explicitly starts AI Story Cut generation by providing a target duration range. The AI Story Cut is not generated automatically with a hidden or assumed target.

The creator can review and export the AI Clean Cut without generating an AI Story Cut. Once requested, the Story Cut is generated as a preserved proposal derived from the AI Clean Cut and can be previewed as a complete alternative.

## Consequences

- The creator controls when additional story-level analysis runs.
- Processing cost and latency are avoided when the creator only needs mechanical cleanup.
- The UI needs a clear “Generate AI Story Cut” action with a target-range input.
- The AI Story Cut’s provenance must identify the Clean Cut and target range it was generated from.
