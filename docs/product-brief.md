# Telltake — v1 product brief

## Product promise

Telltake is an AI-assisted, transcript-first rough-cut editor for solo Mandarin-first storytelling creators, shipped as a macOS app. It turns a 20–30 minute talking-head recording session made up of multiple clips into a reviewable, reversible rough cut: the transcript shows what the AI proposes to remove and why, every removal can be restored, and the export is rendered from the original clips.

The AI assists with first-pass editing. It does not silently make irreversible or subjective storytelling decisions, and it never deletes source media.

## Target workflow

The launch creator is a Rednote-style solo storyteller who records chronologically in one session while doing something such as makeup, getting ready, or cooking.

- Input: multiple source clips from one 20–30 minute, single-speaker recording session
- Speech: primarily Mandarin, including natural Mandarin-English code-switching and regional accents where reasonably possible
- Output: a shorter rough cut that keeps the creator's chronology, reviewed line by line in the transcript
- Current pain: manually finding failed starts, retries, redundant takes, and cut boundaries
- v1 success: the creator reviews AI proposals instead of hunting for cuts; the time this saves is a target to measure, not a measured claim (see Safety and quality bar)

## Core workflow

1. Import multiple local source clips. Their order is inferred from capture and creation time; the creator reorders or leaves clips out before analysis.
2. **Check & confirm sequence** runs the media compatibility gate (dimensions, frame rate, audio, orientation, colour format) and freezes the confirmed sequence.
3. **Transcribe with Doubao** extracts audio locally and sends only that audio to Doubao (ByteDance / Volcengine) Turbo, clip by clip, with durable per-clip checkpoints, visible progress and a Stop that keeps finished clips. The result is an immutable, timestamped transcript with word alignment and review notes.
4. The transcript is inspectable at once. Editing waits for a rough cut.
5. **Generate rough cut** sends the transcript text, never audio, to OpenAI GPT-5.6 Sol and receives the **AI Rough Cut**: the continuous passages worth keeping. The app validates every quoted passage against the saved transcript; anything it cannot place exactly is kept and marked **Needs review** with the reason.
6. Gaps between two removed lines are removed by default with a visual-content warning and a restore; all other no-speech footage stays.
7. The creator reviews in the transcript: keep or remove lines and gaps, switch takes, adjust line ends, shorten pauses, correct text, undo and redo. The first manual change creates a **Creator Cut**; the AI baseline stays intact.
8. **Preview full cut**, then **Approve this cut** for that exact plan.
9. **Export MP4…** renders one local file from the original clips, preserving resolution, frame rate, aspect ratio, audio and colour (HDR sources become 10-bit HEVC with the source's colour tags).

A partial or failed stage leaves unaffected parts usable and degrades conservatively rather than silently excluding content.

## Creator-facing editing model

The primary editing objects are:

- **Line** (utterance) — a sentence- or speech-unit-sized transcript row that can be kept or removed. Removed lines stay visible, dimmed, with a direct Keep / restore.
- **No-speech row** (gap) — a stretch of the recording with no transcribed speech, shown with its duration and playable. It may hold useful footage, so it is kept unless the rule in step 6 applies or the creator removes or shortens it.
- **Take group** — repeated attempts at the same thought, potentially crossing clip boundaries. A group collapses to the preferred take with a badge such as "AI picked take 2 of 3 · Show alternatives"; alternatives expand in recording order and are individually playable. Possible alternatives the AI could not group safely stay as separate rows the creator can compare, group or ignore.

Words and word timing remain internal metadata for alignment and boundaries. The creator can adjust the two ends of a line and the edges of an AI removal, both snapped to real frames; arbitrary middle-of-sentence word deletion, splitting or merging lines, and transcript-driven reordering are out of scope.

Every cut preserves the imported source chronology across clips. The transcript is the editing source of truth; the preview player shows the cut and navigates between joins.

## Cut variants

### AI Rough Cut

The analysis baseline the shipped app generates (ADR-107). The model is asked to prefer unique details, the latest successfully completed attempt of a repeated thought, and coherent continuous passages. These are editorial preferences, not a promise of perfect selection: the creator reviews the result, and the app keeps anything the validator cannot place exactly. Each run is an immutable analysis run; a new run creates a new baseline and leaves earlier cuts available.

### Creator Cut

The editable working cut created automatically the first time the creator manually changes the AI baseline they chose. The AI baseline remains intact as a reference. Edits are recorded as append-only operations with persistent undo and session-scoped redo.

### Legacy: AI Clean Cut

Earlier builds generated a precision-first mechanical **AI Clean Cut** from per-utterance take analysis. The shipped app no longer runs that analysis; projects that contain such cuts still open, and their cuts remain reviewable. Retiring the underlying model is scheduled in [post-launch actions].

### Planned after v1: AI Story Cut

A shorter proposal for a creator-supplied target duration (ADR-083), returning its best coherent result when the target cannot be reached safely. It is not generated by the shipped app; its controls are hidden. Story proposals saved by earlier builds can still be reviewed and restored. When it returns, it should be designed on the Rough Cut's passage representation.

## Safety and quality bar

The Rough Cut favours keeping content over removing it:

- missed cleanup is acceptable;
- a wrong take choice is acceptable because the alternatives stay one click away;
- removing content the creator intended to keep is the failure that matters most, which is why every removal is visible and restorable and why validation failures keep the source rows.

**What is measured and what is not.** The only development evidence so far is one creator's session on one development recording, measured from the saved project in [docs/evidence](evidence/README.md): the Rough Cut removed 353 of 607 speech lines, the creator reversed none of them in 32 minutes of editing sessions and spent that time removing 211 no-speech gaps instead, and the cut was never previewed in full or approved, so unreviewed removals are not confirmed correct. There is no held-out evaluation set and no independent benchmark. Real-world cut precision and the review-time saving have therefore not been established. The targets for a future held-out evaluation are roughly 98–99 % precision at the line level with critical false exclusions tracked separately, and 5–15 minutes of active review for a 20–30 minute session. They are targets, not results; product copy and the README must not state them as achieved.

## Platform strategy

### Phase 1 — macOS validation product (shipped as v1)

Import, compatibility gate, local audio extraction, Doubao transcription with checkpoints, the AI Rough Cut, gap removal, transcript editing with undo, full-cut preview and approval, colour-preserving local export, project backup and recovery, and a universal signed build.

### Phase 2 — iPhone product implementation

Reuse the portable editing model and processing contracts. Add Photos import, mobile transcript review, export progress/recovery, and system share-sheet publishing. macOS is the implementation surface, not the permanent product assumption.

Reanalysis creates a new analysis run. The newest run is shown by default, prior runs remain available, and v1 does not merge new results into an existing Creator Cut.

## Data and privacy

- Original video stays local; it is used for preview and export only.
- Doubao receives extracted audio through a direct request; no app-managed hosted file is created. OpenAI receives transcript text with minimal timing, with stored responses turned off. Neither is a promise about provider log retention.
- Both require the creator's agreement in Settings, which covers later requests until revoked. Revoking blocks new uploads and tries to cancel requests in progress; content already sent cannot be recalled.
- API keys are stored in the Mac's Keychain. Charges go to the creator's own provider accounts; the app shows per-request usage estimates.
- Local projects retain the transcript, raw transcription evidence, analysis evidence, edit decisions, cut variants and export records.
- Projects reference rather than duplicate source clips and support relinking when a clip moves or is renamed; a relink must match the original file's fingerprint and media facts.
- Durable backups require `manifest.json` and `state.sqlite`; `exports/` is optional and `cache/` is disposable.
- Evaluation consent and model-improvement consent are separate. Held-out evaluation recordings stay isolated from development and tuning.

## Reopenable project

The `.easycut` package persists source identity, transcript and word alignment, review notes, analysis runs and their evidence, cut variants and plans, edit provenance, preview approvals, processing-stage status and export records. The schema is versioned and migration-driven so macOS projects can later move to iPhone.

## Evaluation

Use a consented corpus of real 20–30 minute Mandarin-first creator recordings with annotations for line boundaries, keep/remove intent, take groups, preferred takes and critical false-exclusion status.

Track separately: Rough Cut precision at the line level; critical false exclusions; take-selection accuracy; active creator review time; total wall-clock time; processing latency; and export latency. Creator Cut changes are feedback by default, not ground truth; raw diffs are preserved for later review without interrupting the creator for mandatory labels.

## Explicitly out of scope for v1

- B-roll selection, captions, music, transitions and effects, color grading
- multi-camera editing; multi-speaker conversations and overlapping speech
- dialect-heavy speech and a Cantonese guarantee
- global non-adjacent duplicate detection; transcript-driven reordering; arbitrary word-level deletion
- direct publishing integration; alternate aspect-ratio export; sophisticated desktop timeline editing
- automatic silence detection or shortening of every pause (pause shortening is manual, one row at a time)
- the AI Story Cut (planned after v1)
- a user interface in languages other than English (a Simplified Chinese catalog is planned after v1)

## Remaining design questions

- Held-out evaluation: number of creators and recordings, and the annotation workflow for disagreements between creator and expert labels
- When and how the Story Cut returns on the Rough Cut's passage representation
- Whether the per-utterance take analysis is retired outright or replaced (post-launch action P1)
