# ADR-049: Use a portable `.easycut` project package

- Status: Accepted
- Date: 2026-08-27

## Context

The project must reopen after long-running processing, preserve multiple analysis runs and cut variants, support source-clip relinking, avoid duplicating original video, and provide a migration boundary from the macOS validation prototype to the future iPhone product.

## Options considered

### Single project JSON file

Simple and highly inspectable, but repeated stage updates and concurrent or interrupted writes increase corruption and migration risk as the project model grows.

### Directory of independent JSON files

Easy to inspect and update incrementally, but cross-file consistency becomes the application’s responsibility. Reconstructing a coherent project after an interrupted write is more complex.

### `.easycut` directory package with a transactional state store

Presented to the user as one project item, but internally stores a manifest, portable structured state, and optional disposable caches. This supports atomic state updates, durable stage progress, schema migration, and future iPhone document handling without embedding source video.

## Decision

Use a user-facing `.easycut` package with:

```text
project.easycut/
  manifest.json       # identity, schema, source refs, sequence/run pointers
  state.sqlite        # canonical portable project state
  cache/              # disposable thumbnails, proxies, extracted audio
  exports/            # optional local outputs; not required project state
```

`state.sqlite` is the canonical editable project state. It contains source-clip metadata and references, the creator-confirmed sequence, transcript and word alignment, utterances, take groups, analysis runs, AI Clean Cut, AI Story Cut, Creator Cuts, edit provenance, target ranges, processing-stage state, and rendering plans.

`manifest.json` contains only lightweight package identity and compatibility metadata, such as package format version, project ID, creation/last-opened metadata, minimum compatible app/schema version, and optionally lightweight source-availability hints. It does not duplicate transcript, analysis, or edit-graph state.

`cache/` contains disposable derived artifacts such as thumbnails, proxies, or extracted audio. Caches must be safe to delete and regenerate. `exports/` contains rendered user outputs or references, but is not canonical edit state. The package does not contain the original high-resolution video.

The SQLite schema is explicitly versioned and migration-driven; SQLite storage alone is not treated as the compatibility strategy.

The package is portable at the logical schema level. macOS and iPhone may use different local cache locations and media-access mechanisms, but they read and write the same versioned project state contract.

## Open questions

- Should exports be copied into the package or remain external output files?
- Which caches are safe to regenerate and therefore excluded from backup/sync?
- Should the package be a macOS Finder package and an iPhone document package with the same extension?
- What project migration policy applies when the schema version is unsupported?
