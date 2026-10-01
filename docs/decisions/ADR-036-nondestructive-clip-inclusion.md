# ADR-036: Make source-clip inclusion nondestructive

- Status: Proposed
- Date: 2026-08-18

## Context

An imported batch may contain an accidental clip, an unrelated recording, or a duplicate. The creator needs to correct project inputs without deleting or modifying source media.

## Decision

Before analysis, the creator may remove a clip from the project. “Remove from project” means mark the clip inactive for transcript assembly, take detection, cut generation, preview, and export; it never deletes the original file.

The project retains the imported clip record and allows it to be restored or re-included. Any change to active clip membership after analysis is a structural project change that creates a new sequence revision and invalidates or recomputes dependent analysis.

## Consequences

- Input cleanup remains reversible and non-destructive.
- The project distinguishes imported clips from active project clips.
- Analysis outputs must identify the clip-membership and sequence revision they depend on.
- The pre-analysis setup stays lightweight: infer order, reorder if needed, exclude accidental clips, then confirm.
