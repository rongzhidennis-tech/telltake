# ADR-005: Launch with Mandarin-first single-speaker recordings

- Status: Proposed
- Date: 2026-08-17

## Context

The initial creator workflow is a solo storytelling recording for Rednote. The creator speaks primarily Mandarin, but natural code-switching into English is common for product names, brands, internet slang, proper nouns, and short phrases. Regional accents are also expected. Broad language and speaker support would increase launch complexity before the core rough-cut workflow is proven.

## Decision

The v1 guaranteed support matrix is:

- one creator speaking primarily Mandarin Chinese;
- natural Mandarin-English code-switching;
- regional Mandarin accents where reasonably possible; and
- one-speaker storytelling recordings without overlapping speech.

V1 does not guarantee reliable results for dialect-heavy speech, Cantonese or other Chinese language varieties, multi-speaker conversations, interviews, podcasts, or overlapping speakers.

The core editing model must not hard-code Mandarin-only or single-speaker assumptions. Transcript segments, source timestamps, take groups, confidence, language metadata, and speaker metadata should be extensible for future languages, dialects, Cantonese, and speaker diarization.

## Consequences

- Language and transcription quality should be evaluated on code-switched Mandarin, not Mandarin-only samples.
- Product messaging must clearly distinguish supported launch cases from future expansion areas.
- Speaker metadata can be optional in v1, but the transcript model should leave room for it.
- Unsupported or uncertain speech should fail visibly and preserve source media rather than producing confident-looking edits.

## Open questions

- What privacy and retention guarantees are required for uploaded footage and transcripts?
- Should unsupported speech be detected before processing and communicated as a limitation?
- Which code-switched names and slang categories need special evaluation coverage?
