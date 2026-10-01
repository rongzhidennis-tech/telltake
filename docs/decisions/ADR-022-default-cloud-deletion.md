# ADR-022: Delete cloud processing artifacts by default

- Status: Proposed
- Date: 2026-08-18

## Context

The original video should remain local, and cloud processing is used only where it improves v1 quality or development speed. The local project can retain the transcript and edit decisions needed to reopen the work, reducing the need for a persistent cloud copy.

## Decision

After transcription and AI analysis complete, the default behavior is to delete uploaded audio and temporary cloud processing artifacts. The local project retains the timestamped transcript, analysis outputs, cut variants, edit decisions, and rendering plans.

Cloud retention may become an explicit user-controlled option for future cross-device recovery, but it is not the default v1 behavior.

## Consequences

- Cloud processing jobs must return durable outputs before their temporary inputs are deleted.
- Reopening a macOS project should not require re-uploading audio when the local project is intact.
- Cross-device continuation is not guaranteed in v1 unless the user explicitly opts into retaining or reprocessing data.
- Deletion state and failures should be visible enough for the product to make an accurate privacy promise.
