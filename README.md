   # Telltake
   **Turn a talking-head recording into a rough cut by editing its transcript.** Native macOS app · [telltake.com](https://telltake.com)

   Telltake imports multi-clip recordings, transcribes them (Doubao ASR, Mandarin-first), proposes an **AI Rough Cut**
   (OpenAI, strict JSON), and lets the creator review and refine the cut in the transcript before exporting an MP4
   rendered from the original clips. Shipped v1.0.1 in September 2026.

   > **Source availability.** The application source is private (see LICENSE terms on telltake.com). This repository
   > publishes the architecture, the decision records and the evaluation protocol. Source access for interview or
   > review purposes: rongzhi.dennis@gmail.com.

   ## Architecture
   One Swift 6 package, 12 modules, ~19k LOC + 11k LOC tests (431 tests, 5 targets):
   - `EasycutCore` – portable editing model and SQLite project store (33 tables, versioned migrations); no UI deps
   - `EasycutMedia` – AVFoundation: inspection, audio extraction, frame-snapped boundaries, preview, MP4/HDR export
   - `EasycutCloud` – Doubao + OpenAI clients, consent gate, Keychain credentials
   - `EasycutMac` – AppKit UI
   - 5 CLI tools for evaluation and provider benchmarking
   (diagram)

   ## Design principles (see docs/decisions)
   - **Never trust the model blindly** – every LLM-returned span is validated against the saved transcript; anything
     unplaceable is kept and flagged *Needs review* (ADR-023, ADR-107).
   - **Resumable by construction** – per-clip transcription checkpoints; stop keeps finished work (ADR-106, ADR-110).
   - **Measured, not claimed** – written evaluation protocol with precision and critical-error gates and a
     consent-aware dataset registry (ADR-073).
   - **Cost is a feature** – model tiering and per-request usage metering (ADR-100).

   ## Evaluation
   Summary of docs/evaluation-protocol.md and the Test23 evidence numbers (66 min → 34 min AI cut → 29 min creator cut;
   creator reversed 0 of 353 AI removals — development data, one creator).

   ## How it was built
   Solo, Aug–Sep 2026, with Claude Code and Codex working from ADR-governed specs and the test suite.
