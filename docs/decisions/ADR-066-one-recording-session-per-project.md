# ADR-066: Scope each v1 project to one recording session

- Status: Proposed
- Date: 2026-08-27

## Context

The v1 workflow assumes one chronological storytelling session represented by multiple source clips. Combining unrelated sessions in one project would make source chronology, transcript assembly, take detection, and duration-aware story analysis ambiguous.

## Decision

One `.easycut` project represents exactly one creator recording session and its ordered active source-clip sequence. A creator starts a separate project for another session.

## Consequences

- Sequence locality and meaningful story progression have one clear scope.
- Target duration and AI Story Cut analysis apply to one session.
- The SQLite aggregate can remain focused without cross-session relationships in v1.
- Multi-session projects can be added later without changing the meaning of a v1 project.
