# ADR-075: Require exact recorded identity when relinking sources

- Status: Accepted
- Date: 2026-09-13
- Scope: EC-03; implementation clarification for ADR-052–ADR-055

## Context

EC-03 needs deterministic validation thresholds so a moved original can be
recovered without accepting a similar recording or a transcoded replacement.

## Decision

A candidate must have the same nonempty fingerprint algorithm and fingerprint
as the immutable source. Duration must match exactly. Every recorded optional
identity field—file size, dimensions, rational frame rate, and audio format—must
also match exactly. A field absent from an older import does not become a new
requirement during relinking. Different fingerprint algorithms are ambiguous;
fingerprint or recorded metadata differences are mismatches.

Successful validation updates the mutable location and appends an audit event.
Rejected manual candidates append an event without replacing the existing path
or source ID. Rechecking remembered paths validates each clip independently;
unreadable sources become missing and identity failures become unresolved.

Refresh results apply only if the inspected path still matches the current location
inside the write transaction. A late success, mismatch, or missing-file result for
a replaced path is discarded without changing availability or appending an event.
The refresh then returns the current stored sequence.

Project inspection remains available. Playback requires an available source and
a range within its recorded duration. Preview and export readiness require all
source IDs requested by the caller to be available; unused missing clips do not
block an otherwise validated selection. These are shared readiness checks for
the later playback, preview, and export implementations.

## Consequences

Relinking accepts relocated originals, not visually equivalent re-encodes.
Availability records the latest inspection, not a guarantee that a file cannot
subsequently change. Source-consuming workflows must refresh it as appropriate.
The existing schema v2 location and audit tables suffice; no migration is needed.
