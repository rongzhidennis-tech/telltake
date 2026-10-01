# ADR-033: Keep editing transcript-first with read-only timeline context

- Status: Proposed
- Date: 2026-08-18

## Context

Creators need video playback context while reviewing transcript decisions, but direct timeline editing would reintroduce the manual cut-point workflow the product is designed to reduce.

## Decision

The transcript is the editing source of truth in v1. The macOS prototype may show a minimal read-only timeline or waveform for orientation, scrubbing, and playback context. Timeline manipulation is not a v1 editing workflow.

Transcript actions—keeping or removing utterances, switching takes, accepting story-section removals, restoring content, and making limited boundary adjustments—drive the cut plan.

## Consequences

- The creator can inspect source context without maintaining two competing editing models.
- The timeline can remain useful for playback, debugging, and export verification without becoming a second editor.
- The future iPhone interaction can focus on transcript review without needing to reproduce a desktop timeline.
