# ADR-035: Infer clip order, then freeze a creator-confirmed sequence

- Status: Proposed
- Date: 2026-08-18

## Context

Creators may import multiple clips from one recording session. Capture timestamps are often useful, but can be missing or altered by file transfer, export, or other apps. The sequence used for transcript assembly and take detection must therefore be explicit and mutable before analysis, while remaining low-friction in the common case.

## Decision

V1 establishes the recording sequence in four steps:

1. Infer an initial order using the best available capture/creation timestamp metadata.
2. Show the inferred ordered clip list before analysis, with thumbnail, duration, filename, and capture time when available.
3. Allow lightweight manual reordering before transcription or take analysis begins.
4. Allow the creator to exclude accidentally imported clips without deleting their source files.
5. Require an explicit **Start analysis** confirmation.
6. Freeze the creator-confirmed project sequence and active clip set for that analysis run.

The confirmed project sequence and active clip set are the source of truth for transcript assembly, source chronology, alternative-take detection, cut generation, and export. Source-file metadata remains evidence used to infer the initial order, not authoritative editing chronology.

Changing clip order after analysis is a structural project change. It invalidates or recomputes analysis that depends on recording locality before the revised sequence can be used for take detection or cut generation.

## Consequences

- The common case can proceed without manual ordering.
- The creator has a visible correction point before expensive processing begins.
- Analysis never starts against an implicitly changing or unconfirmed clip sequence.
- Projects must persist both original source metadata and the confirmed sequence.
- Analysis outputs need a sequence revision identifier so stale results cannot be applied to a changed project order.
