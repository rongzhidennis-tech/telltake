# ADR-052: Open projects in review-only mode when source clips are missing

- Status: Proposed
- Date: 2026-08-27

## Context

Durable project state can be restored independently from the original local source clips. A backup may be opened on a machine where the clips are temporarily unavailable, and refusing to open would hide valuable transcript and editing history.

## Decision

If one or more referenced source clips are unavailable, the project opens in review-only mode. The creator can inspect the transcript, analysis runs, take groups, cut variants, and edit provenance. Source-dependent playback, preview, boundary validation, and MP4 export remain disabled until the required clips are relinked.

The app shows a clear relink action and identifies which clips are missing. Relinking validates clip identity and metadata before re-enabling source-dependent operations.

Partial relinking may enable inspection and playback for available ranges, but full-cut preview and export remain disabled until every required source clip is validated.

## Consequences

- Canonical project state remains useful without requiring immediate access to large media files.
- The UI must distinguish missing-source limitations from corrupt project state and missing disposable caches.
- Export cannot silently substitute incomplete media.
