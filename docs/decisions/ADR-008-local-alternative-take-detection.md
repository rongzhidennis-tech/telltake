# ADR-008: Focus v1 take detection on local retries

- Status: Superseded by ADR-034
- Date: 2026-08-18

## Context

This decision has been superseded by ADR-034. The target creator may stop and start multiple source clips while retrying the same thought, so a single-file time window is not the right primary definition of locality.

## Decision

See ADR-034 for the current cross-file recording-sequence definition.

## Consequences

- The data model should support ordered source clips and cross-file take groups.

## Open questions

- What defines the imported recording sequence when file metadata and user order disagree?
