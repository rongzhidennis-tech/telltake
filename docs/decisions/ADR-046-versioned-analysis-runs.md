# ADR-046: Preserve prior results across reanalysis

- Status: Proposed
- Date: 2026-08-27

## Context

Internal thresholds, prompts, heuristics, and models will evolve during prototype development. Reanalysis may produce different take groups or cut proposals. Existing creator work must not be rewritten by these changes.

## Decision

Each reanalysis creates a new versioned analysis run. A run records its analysis configuration version and produces its own AI Clean Cut and optional AI Story Cut. Existing AI baselines and Creator Cuts remain unchanged and available for comparison or recovery.

All analysis outputs within a run are immutable; creator actions are recorded only in the resulting Creator Cut.

Reanalysis never silently migrates or overwrites a Creator Cut. Applying results from a new run to creator work requires an explicit creator action and a defined migration or comparison flow.

V1 does not merge a new analysis run into an existing Creator Cut. Creator work based on the new run starts as a separate Creator Cut tied to that run.

## Consequences

- Model and threshold experiments are auditable and reversible.
- The project must persist analysis-run identity alongside cut provenance.
- The UI needs a simple current-result concept so creators are not forced to manage a technical history of runs.
- Old runs can be retained as project metadata or pruned according to an explicit retention policy without deleting source media.
