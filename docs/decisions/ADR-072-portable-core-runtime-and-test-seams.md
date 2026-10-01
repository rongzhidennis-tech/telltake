# ADR-072: Establish the portable-core runtime and test seams

- Status: Accepted
- Date: 2026-08-28

## Context

Easycut needs a portable core that can move from the macOS validation prototype
to a later iPhone implementation without being owned by either UI. The first
implementation slice must also allow later media, transcription, analysis, and
rendering work to be tested without choosing concrete providers prematurely.

## Decision

- Implement the portable core as a Swift 6 library built with Swift Package
  Manager. The core target does not import AppKit, SwiftUI, AVFoundation, or a
  provider SDK.
- Use Swift Testing through `swift test` as the baseline test runner.
- Isolate local media, transcription, analysis, and rendering behind `Sendable`
  asynchronous interfaces. Stage-specific artifact and identifier types prevent
  the transcription interface from receiving original source-media references.
- Keep deterministic test doubles in the core test target. The baseline workflow
  uses only those doubles and verifies that a failed stage does not start later
  stages.
- Leave concrete cloud providers and model names unresolved. Later tickets must
  supply adapters and configuration identities without changing the portable
  interfaces solely to accommodate an SDK.
- Leave retry policy and retry cardinality unresolved. EC-00 adds no implicit
  retries; a later decision must define which failures are retryable and how
  attempts are persisted.

## Consequences

- Core orchestration can compile and run independently of macOS UI and media
  frameworks.
- Tests are deterministic and do not need local media files, cloud credentials,
  or rendering software.
- Provider selection, model selection, retry behavior, persistence, and concrete
  application wiring remain outside EC-00.
