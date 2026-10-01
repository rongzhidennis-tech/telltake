# ADR-018: Export one locally rendered MP4 for v1

- Status: Proposed
- Date: 2026-08-18

## Context

V1 focuses on transcript-driven rough-cut editing rather than finishing or publishing. The original source remains local, and the reviewed cut is an ordered subset of source ranges.

## Decision

V1 exports one locally rendered MP4. The export preserves the source video’s resolution, frame rate, aspect ratio, and audio. Captions, effects, alternate aspect-ratio exports, and direct publishing integrations are out of scope.

## Consequences

- The export path can remain simple and predictable for the first workflow.
- Local rendering avoids uploading the original high-resolution video solely for export.
- The client must handle source decoding, cut assembly, audio continuity, and export failures locally.
