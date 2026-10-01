# ADR-087: Sealed transcript correction snapshots

- Status: Accepted
- Date: 2026-09-17
- Scope: EC-13, implementing ADR-056–057

## Decision

Whole-utterance text correction uses the existing correction revision and overlay
tables. Each actual save or revert creates a complete, sealed snapshot with a
monotonic transcript-local revision number, parent revision, creator attribution
and timestamp. Existing snapshots are never updated or deleted. Reverting removes
that utterance's overlay from the new snapshot, not from history. Empty snapshots
remain valid evidence when the last correction is reverted.

The save transaction checks the current transcript and expected correction pointer,
the sealed transcript, and the existing Clean-ready/source-availability editing gate.
Unknown utterances and visual context rows cannot be corrected. Nonempty Unicode
text is preserved exactly; whitespace-only and NUL-containing submissions are
rejected. Identical text and already-reverted commands are no-ops.

Review reads the display pointer and overlays in one database snapshot. Each row
retains recognized text separately from displayed text and exposes a corrected
badge. The dialog and tooltip show the original; Revert text is a separate action
from Creator Cut undo. Candidate labels consume the same display rows.

Saving changes only the correction pointer and project/state timestamps. It does
not fork a Creator Cut, change approval or range plans, update word alignment or
groups, or request analysis. Existing analysis keeps its exact correction revision.
Explicit corrected-text reanalysis remains EC-14. No migration is needed.
