# ADR-063: Persist resolved cut plans alongside edit provenance

- Status: Proposed
- Date: 2026-08-27

## Context

Each cut variant may be derived from an AI baseline and then modified through take switches, restores, removals, grouping changes, text-independent boundary adjustments, or visual-span decisions. Reconstructing the playable sequence through a long chain of diffs would make preview, export, and recovery more fragile.

## Decision

Each `CutVariant` stores a self-contained resolved, ordered source-range sequence used directly for preview and local export. The database also stores the edit operations and provenance that explain how the variant differs from its starting point or prior state.

AI Clean Cut and AI Story Cut are preserved as stable resolved variants. Creator Cut updates produce new resolved state while retaining the creator’s edit provenance and raw differences. No variant embeds source media.

## Consequences

- Preview and export do not need to replay an arbitrarily long edit chain.
- Comparison and audit views can use provenance and resolved-sequence diffs.
- SQLite writes must update the resolved sequence and corresponding operation record transactionally.
- Edit operations are append-only provenance records as defined in ADR-064.
- Storage is slightly duplicated, but the canonical data remains small compared with source video and safer to recover.
