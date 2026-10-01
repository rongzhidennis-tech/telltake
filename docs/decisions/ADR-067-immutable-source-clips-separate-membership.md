# ADR-067: Keep source clips immutable and sequence membership separate

- Status: Proposed
- Date: 2026-08-27

## Context

Source clip identity, metadata, and fingerprint must remain stable for relinking and provenance. The creator may reorder, exclude, or restore clips without changing the underlying media record.

## Decision

Store source clips as immutable project entities containing local reference information, source identity, media metadata, and original capture metadata. Store active/inactive status and sequence position in separate recording-sequence membership records.

Reordering, excluding, restoring, or re-including a clip creates a new project-sequence revision but does not mutate the source clip record. Analysis runs reference the exact sequence revision and active clip set they consumed.

## Consequences

- Relinking and source validation remain stable across sequence edits.
- Sequence changes are auditable without rewriting source metadata.
- The SQLite schema can reuse a source clip across sequence revisions while keeping one v1 project scoped to one session.
- Cut and transcript provenance can identify both the immutable source clip and the sequence revision.
