# Changelog

All notable changes to Telltake. Dates are the day the work landed in the
repository; the version is the app's `CFBundleShortVersionString`.

## 1.0.1 — 2026-09-23

The first downloadable build, with a redesigned workspace. 1.0.0 was the source
freeze and was not distributed.

- **New look.** A shared navy and teal theme with a sidebar using the app icon and
  system symbols, applied to the project and review windows.
- **Review window layout.** Preview on the left, transcript on the right, equal by
  default with an adjustable divider that is remembered.
- **Grouped transcript.** Contiguous lines are grouped under the name of the clip
  they come from; the headers are presentation only, and a line that spans two
  clips stays one edit target. Inline Restore on removed lines.
- **Reorganized controls.** Filters and actions moved into the toolbar and
  popovers; AI Rough Cut, Line ends and Text & rough cut are disclosure sections.
- No change to editing rules, saved projects, cloud requests, approval or export.
  429 tests pass, including new tests for the grouped transcript.
- Distributed as an ad-hoc signed DMG; see the first-launch note on telltake.com.

## 1.0.0 — source freeze, 2026-09-22 (not distributed)

The first release: a macOS app that turns a multi-clip talking-head recording
into a reviewable rough cut by editing its transcript. Earlier history (before
the first commit on 2026-09-18) lived outside version control; the decisions it
produced are ADR-001 to ADR-105 in `docs/decisions/`.

### Editing workflow

- Import clips, order them by capture time, leave clips out without deleting
  anything, and confirm the sequence through a media compatibility gate
  (dimensions, aspect ratio, frame timing, audio, orientation, colour format).
- Transcribe with Doubao Turbo, clip by clip, with durable per-clip
  checkpoints, up to two clips at a time, saved progress with an estimate, and
  a Stop that keeps finished clips (ADR-106, ADR-110; 2026-09-19).
- AI Rough Cut: the transcript text goes to GPT-5.6 Sol, which proposes the
  continuous passages to keep; every quotation is validated against the saved
  transcript and anything that cannot be placed exactly is kept and marked
  Needs review with its reason (ADR-107; 2026-09-19).
- Gaps enclosed by removed speech are removed by default with a warning and a
  restore, including gaps under two seconds; Remove enclosed gaps applies the
  rule to a saved cut without another request (ADR-109; 2026-09-19).
- Transcript review: keep or remove lines and gaps, take groups, line ends
  snapped to real frames, AI cut edge adjustment, text corrections with revert,
  manual pause shortening, previous/next join playback, persistent undo and
  session-scoped redo, search and filters, playback highlight that follows the
  cut (ADR-078 to ADR-088, ADR-108).
- Full-cut preview with coverage tracking, explicit approval of the exact plan,
  and export of that captured plan to an MP4 rendered from the original clips
  (ADR-089, ADR-091).
- Project backup of canonical state, recovery status, and relinking of moved
  clips by fingerprint (ADR-092, ADR-075).

### Release hardening (2026-09-20 to 2026-09-22)

- Cloud: response waits sized from clip duration; key validation bound to the
  shipped model; model-access denial keeps the key and names the model; the
  GPT-5.6 Luna analysis client removed and Story Cut generation hidden;
  experiment-only provider clients moved out of the app.
- Reliability: all project database work serialized on one queue; damaged
  database columns and unmigrated projects reported instead of trapping; a
  current cut that fails validation reported instead of hidden; audio
  extraction failures recorded per clip; every Creator edit tied to an open
  editing session.
- Desktop: standard menu bar with Undo and Redo; confirmation before closing or
  quitting during transcription or export; the review window reused while
  open; sanitized diagnostic codes with Save Diagnostics…; the review window
  split into focused controllers; export ownership moved to the project window.
- Copy and localization: every user-visible string in plain English through a
  string catalog, with Core carrying codes instead of sentences; errors from
  every module explained in plain language; Chinese planned after v1.
- Media: HDR and 10-bit sources exported as 10-bit HEVC with the source's colour
  tags, and HDR never mixed with SDR in one sequence; verified on generated HLG
  footage and one real iPhone HDR recording (schema migration 7).
- Packaging: renamed to Telltake with an app icon; the `.easycut` document type
  registered so projects open from Finder; universal release build, inside-out
  signing, smoke test and notarization script; bundle identifier
  `com.telltake.app`, version 1.0.0, build number from the commit count.
- Documents: CONTEXT, product brief, glossary, ADR index, ticket file with named
  verification, provider and schema statements, these terms, this changelog and
  the privacy document brought in line with the shipped product.

### Known limits at release

See "Current scope and limitations" in the README. In short: one speaker, one
camera, Mandarin-first; English interface; no Story Cut; quality figures are
targets for a future held-out evaluation, not measured results.
