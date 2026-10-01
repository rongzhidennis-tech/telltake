# Transcript corrections (EC-13)

After the Clean Cut is ready, select an utterance and choose **Correct text…**.
The dialog shows the recognized text and lets you edit the full displayed text.
Save preserves the exact nonempty text, including Mandarin/English and newlines.
Corrected rows have a badge and expose original text in their tooltip. Take-group
candidate labels use the same corrected display text. Context rows are not editable.

**Revert text** restores recognized text while retaining all earlier correction
snapshots. It is independent of cut Undo/Redo. Source timing, word alignment,
utterance identity, groups, approvals and rendered media do not change. A text
correction neither creates a Creator Cut nor starts analysis.

Clients call `saveTranscriptCorrection` with the displayed transcript ID, current
correction revision and utterance ID. Pass nil text to revert. Refresh after stale
revision errors; never overwrite a newer correction automatically. Missing required
sources or a pending Clean Cut retain the existing edit lock. Read-only review still
exposes saved display text and recognized text.

Each actual change atomically creates a sealed complete overlay snapshot and updates
the display pointer. No-op commands add no revision. Previous analysis retains its
original correction references; explicit corrected-text reanalysis is EC-14.
See [ADR-087](../decisions/ADR-087-sealed-transcript-corrections.md).
