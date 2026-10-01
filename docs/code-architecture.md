# Code architecture: current state and growth plan

## Current implementation

The repository is a Swift package with portable `EasycutCore`, a `CSQLite`
system-library bridge, an `EasycutMedia` AVFoundation adapter, and a small
native `EasycutMac` validation application. Local captured-plan rendering is
implemented. `EasycutCloud` holds the guarded Doubao and OpenAI adapters; live
integration (EC-19) is complete. See [cloud workflow](workflows/cloud-processing-workflow.md).

- `EasycutCloud` owns the Keychain-backed user credential/consent gate, independent
  denial marker, single guarded HTTP boundary, the Doubao transcription client and
  strict Responses adapters. The Whisper-era transcription client, the raw
  transcription comparison client and the retake experiment client live in
  `EasycutCloudDev`, which only the command-line tools link; the app never ships them.
  `EasycutCloudTestSupport` holds the in-memory settings store and recording
  transports shared by both cloud test targets. The GPT-5.6 Luna take/Story analysis
  client was deleted on 2026-09-21; the app's only text model is Sol. The Core
  take-analysis and Story Cut types remain for saved projects (see
  `docs/post-launch-actions.md`). Core remains provider-independent. The macOS composition root injects
  these into existing domain ports; Settings never starts inference automatically.
  The core's `TranscriptionAudioPreparationClient` is implemented by the local
  AVFoundation preparer, injected into the cloud transcription adapter. It compresses
  oversized extracted audio and only then chunks if needed, preserving absolute
  source offsets and silence (ADR-095). Cloud adapters never import AVFoundation.

- `LocalExport.swift` defines immutable export jobs, outputs, lifecycle and the
  local MP4 rendering port. `ProjectPackageStore+Export` atomically captures
  approved plans and manages durable outcomes using existing export tables.
  `AVFoundationMP4Renderer` shares source assembly with preview, preserves sample
  timestamps through H.264 or, for HDR and 10-bit sources, HEVC Main 10 with the
  source's colour tags (checklist E11), plus AAC audio; validates originals and output,
  and publishes without replacing files. Desktop export runs independently of editing. See
  [export workflow](workflows/local-export-workflow.md) and ADR-091.

- `WorkflowArtifacts.swift` provides typed stage identifiers and minimal artifacts.
- `TranscriptReview.swift` projects chronological utterance and curated visual-context
  rows with readiness and source-playback gates. The store's transcript-review
  extension reads a consistent SQLite snapshot; `TranscriptReviewWindow` provides
  a desktop viewer and revalidated, bounded source playback (ADR-078), with
  whole-utterance Creator editing added by EC-08.
- `ProjectStoreIO.swift` dispatches synchronous project database and cache work
  onto a dedicated serial queue for async coordinators and the desktop service.
- `ProjectPackageStore+TranscriptCorrections.swift` saves complete sealed overlay
  snapshots, validates transcript-scoped provenance, and atomically advances the
  optimistic display pointer. Transcript review reads recognized/display text and
  the correction revision together; desktop correction/revert controls do not
  mutate cut history or analysis (ADR-087).
- Corrected-text requests freeze their full text/overlay context in take-stage
  evidence, then reuse Clean materialization and request-ordered activation.
  `AnalysisHistory.swift` groups Clean requests and their Story/Creator derivatives;
  editing review exposes earlier current-context cuts without changing selection
  pointers. Desktop provider injection and Previous analysis controls implement
  the EC-14 workflow (ADR-088); the desktop composition root wires the live providers.
- `WorkflowClients.swift` defines asynchronous, Sendable media/transcription/analysis/rendering seams.
- `TakeAnalysis.swift` defines EC-06's dedicated text-only adapter, explicit internal
  configuration, conservative grouping policy, and coordinator. The store's
  take-analysis extension persists request evidence, sealed output, normalized
  groups/recommendations, and separate run-scoped review history. Cut
  materialization is EC-07. The shipped app no longer runs this analysis: the AI Rough
  Cut (ADR-107) replaced it, and retirement is post-launch action P1 (ADR-079).
  See [take-analysis operations](workflows/take-analysis-workflow.md).
- `CleanCut.swift` constructs the conservative resolved source-range plan and
  its versioned hash. `CleanCutRecommendations.swift` verifies normalized take
  relationships against sealed evidence. The store's Clean Cut extension commits
  metadata, segments, recommendation applications, and eligible activation together.
  Transcript review retains excluded rows with explicit states. See
  [Clean Cut operations](workflows/clean-cut-workflow.md) and ADR-080.
- `CreatorCut.swift` supplies immutable editing snapshots and whole-range algebra.
  `CreatorCutPersistence.swift` validates ancestry, inherited recommendations and
  plan identity; the store's Creator Cut extension owns atomic first-edit forking,
  current group seeding, recommendation overrides, approval invalidation and
  append-only provenance. Desktop controls invoke it through `ProjectStoreIO`.
  EC-12 extends this transaction to Story sections and visible context rows,
  resolved from the authoritative transcript snapshot, with range-based row
  inclusion and the existing version-1 undo evidence (ADR-085).
  See [Creator Cut operations](workflows/creator-cut-workflow.md) and ADR-081.
- `EditHistory.swift` resolves per-cut undo/redo stacks from append-only provenance;
  the store's edit-history extension manages explicit UI sessions and atomic inverse
  operations. Ordinary edits and reversal share materialized-plan/provenance writers.
  Current-state reads do not replay history (ADR-082).
- `UtteranceBoundary.swift` owns the endpoint-only shape policy and asynchronous
  validation/commit coordinator. `AVFoundationBoundaryClient` validates original
  identity, output sample timing (including edit lists) and decoded PCM coverage
  off the UI executor. The Creator transaction rechecks the inspected sequence and
  location snapshot and writes version-1 reversible evidence (ADR-086).
- `StoryCut.swift` defines explicit target requests, the text-only provider seam and
  source-chronological section mapping. `StoryCutPlan.swift` conservatively validates
  proposals; the store's Story extension commits immutable plans/recommendations and
  activates only eligible results. Section restoration reuses the Creator transaction
  and undo evidence. Generation is deferred past v1; saved proposals remain
  reviewable. See [Story Cut operations](workflows/story-cut-workflow.md) and ADR-083.
- `TakeGroupEditing.swift` projects chronological groups and Possible alternatives,
  validates normalized Creator membership, and supplies collapsed/expanded rows.
  The take-group store extension owns atomic choice/confirmation/membership commands
  and separate run-scoped Ignore. Version-2 undo evidence restores groups as well as
  plans; legacy range-only edits remain compatible. `TakeGroupControls` routes desktop
  actions and source playback through the existing service (ADR-084).
- `ProjectTranscriptionCoordinator.swift` is EC-04's durable service workflow,
  using dedicated audio-only extraction/transcription ports. The store's
  transcription extensions persist progress, sealed transcripts, explicit clip
  coverage, and cleanup ownership. `AVFoundationAudioExtractor` supplies local
  audio extraction. See [transcription operations](workflows/transcription-workflow.md).
- `MinimalProjectWorkflow.swift` is an EC-00 test-seam demonstration: extract,
  transcribe, analyze, render. It is not the product workflow and must not bypass
  creator confirmation, review, or export approval in the application.
- `ProjectPackageModels.swift` defines project identities and current-state pointers.
- `ProjectPackageStore.swift` implements package creation, explicit opening and
  migration, plus non-mutating reads for ordinary commands and read-only packages.
- `ProjectRecovery.swift` creates canonical-only backups through SQLite's online
  backup API, then verifies standalone rollback-journal storage. It projects
  disposable-cache and export-reference status using read-only, streaming file
  identity checks. Desktop open/Recovery status revalidates originals through the
  existing coordinator; no recovery check reconstructs edits or starts processing.
  See [recovery workflow](workflows/project-recovery-workflow.md) and ADR-092.
- `SQLiteDatabase.swift` owns read/write and read-only SQLite connections,
  transaction primitives, foreign-key enforcement, and a bounded busy timeout.
- `RecordingSequence.swift` exposes immutable source and sequence snapshots;
  `ProjectPackageStore+Sequence.swift` owns atomic import, membership revision,
  confirmation, and history reads. Media descriptors come from an inspection adapter;
  import alone never marks a location validated (ADR-074).
- `Resources/` bundles the numbered migration contract; `Tests/` verifies seams and package behavior.
- `DatasetRegistry.swift` and its withdrawal, annotation, and manifest extensions
  implement EC-18A's operator-facing corpus boundary. A separate registry database
  enforces cross-project creator/source isolation; controlled artifacts have
  purpose-specific consent and deletion tracking. See [registry operations](dataset-registry.md).
- `EvaluationReport.swift`, `EvaluationScoring.swift`, `EvaluationSecondaryMetrics.swift`
  and `EvaluationReviewClock.swift` implement EC-18's offline operator reports and
  monotonic review-event measurement. Reports read reviewed frozen labels within
  the registry's authorization transaction; no telemetry, automatic enrollment or
  uncontrolled report storage is added. Real held-out measurement is still pending.
- `SourceRelinking.swift` validates candidate identity and exposes source-range
  availability checks; `ProjectPackageStore+Relinking.swift` updates locations
  and appends audit events transactionally (ADR-075). The desktop app refreshes
  remembered sources on open and offers a selected-clip relink action.
- `EasycutMedia/AVFoundationMediaInspector.swift` reads local movie identity,
  timing, dimensions, orientation, and audio properties, including a complete
  SHA-256 fingerprint. Blocking sample reads and hashing run on a dedicated queue,
  outside Swift's cooperative executor. Since migration 7 it also records the video
  codec, bit depth and colour tags (`VideoFormat`).
- `EasycutMac` separates window orchestration (`ProjectWindow`, `TranscriptReviewWindow`),
  layout (`ReviewWorkspaceLayout`), table and playback controllers, and package commands;
  it delegates import, revision and confirmation rules to the core coordinator. A
  presentation layer (`ReviewPresentation`, `ErrorPresentation`, `CompatibilityPresentation`)
  turns Core codes and errors into plain-language text through the English string catalog
  in `Resources/Localizable.xcstrings` (`scripts/sync_string_catalog.py` keeps it in step
  with the code); `ReviewDiagnostics` logs and reports failures as codes without paths or
  transcript text. `scripts/build_macos_app.sh`, `scripts/smoke_app.sh` and
  `scripts/notarize_app.sh` package, check and notarize `dist/telltake.app`.

These are useful foundations: platform UI does not own the domain, interfaces are
small, dependency injection makes fixtures practical, and SQLite writes have a
transaction boundary. Whole-utterance and take-group editing and undo/redo are implemented;
preview approval, local export, backup and recovery (ADR-092) and durable
transcription progress (ADR-110) are implemented.

## Recommended boundaries

`EasycutReference` is the EC-20 local operator executable. It links only core and
media, not cloud. `ReferenceReconstruction` owns deterministic matching proposals;
`ReferenceReport` validates versioned source/final ranges and explicit review
history. `ReferenceMediaAnalyzer` owns presentation-timed PCM descriptors and
rotated video samples. The command writes a private JSON report and local HTML
review artifact, separate from project packages and the dataset registry. See
[reference reconstruction](workflows/reference-reconstruction-workflow.md).

`ReferenceVisualResolver` searches audio-compatible source/time hypotheses at a
fixed proposed rate and compares nine-frame sequences without importing platform
media APIs. `ReferenceMediaAnalyzer.images` batches presentation-timed frames;
the executable orchestrates those reads. Versioned reports retain compared
alternatives and conservative temporal evidence, never automatic human approval.

Grow toward four responsibilities inside one repository. This is a code organization
proposal; do not create empty frameworks or refactor the working package merely to
match a diagram. Extract targets when the corresponding implementation is introduced.

```text
Sources/
  EasycutCore/          portable values, editing rules, commands, service ports
    Domain/            source ranges, sequence, transcript, groups, cuts, approval
    Application/       confirm, analyze, edit, undo, approve, request export
    Ports/             persistence and external-operation interfaces
  EasycutPersistence/  SQLite, migrations, package IO, transaction repositories
  EasycutMedia/        Apple media inspection, extraction, preview, rendering
  EasycutCloud/        transcription/analysis providers and artifact cleanup
  EasycutMac/          application entry point, UI state, composition root
Tests/
  EasycutCoreTests/
  EasycutPersistenceTests/
  EasycutIntegrationTests/
```

The core owns its service contracts. Persistence/media/cloud implement them and
can depend on core values; the core must not depend on those concrete adapters.
The application composition root constructs adapters and supplies them to services.
Keep database rows, provider SDK objects, local bookmarks, and UI models at their
respective boundaries. Typed project snapshots returned to callers should not expose
raw database handles or require UI code to coordinate SQL transactions.

SQLite currently lives in EasycutCore. That is manageable at this size, but before
platform/provider code grows, move persistence to its own target and relocate package
integration tests with it. Keep one Swift package unless an actual distribution or
build requirement justifies more. ADR-072's Sendable/async seams remain the baseline;
blocking database/media work should run outside the cooperative executor and UI path.

## Design the workflow around durable commands

Replace application use of the one-shot MinimalProjectWorkflow with explicit commands:
confirm sequence, request transcription, seal/activate analysis, request Story Cut,
apply creator edit, undo/redo, approve preview, request export. Each command has a
clear expected revision and atomic state transition. A UI event requests a command;
it does not advance durable state optimistically without the transaction succeeding.

An edit transaction owns group state, selected ranges, revision, duration/hash,
recommendation application/review, approval invalidation, and append-only provenance.
Avoid independent repositories that each commit a fragment of one user action.
A narrow editing-store port can commit the validated aggregate update atomically.
Retain current state and history separately; do not reconstruct the open project
by replaying every edit.

Use immutable job inputs and persisted attempts for long-running work. Provider work
runs outside a database transaction; successful output is validated and committed
with a revision/context check. A completion from an older request may be retained in
history but must not overwrite the currently selected newer result. Cancellation,
retry, cleanup, and failures are explicit job states, not ad hoc UI flags. No paid
request is retried automatically; an explicit retry reuses saved checkpoints (ADR-094,
ADR-110).

## Make rendering consume a real plan

The current RenderRequest contains original media references and an AnalysisArtifact.
That proves the seam but does not represent the product contract. Rendering should
receive a validated immutable ordered plan of clip IDs and source ranges, a plan hash,
compatible output settings, and resolved access to the required media. It should not
interpret transcripts, choose takes, or query whichever mutable cut happens to be
current. Export uses its persisted snapshot; preview uses the selected cut plan.

Keep IDs strongly typed, and extend that discipline to validated media ranges,
duration ranges, revisions, and lifecycle transitions as those slices are built.
Do not create a Swift model per SQL table by default: domain values should express
editing rules, while storage mapping handles relational layout.

## Verification strategy

EC-15 adds `CutPreviewSnapshot` and continuous playback coverage in EasycutCore.
`ProjectPackageStore+CutPreview` reads persisted range plans and transactionally
records preview completion and explicit approval separately from AI baselines.
EasycutMedia assembles revalidated originals into an AVFoundation composition;
the desktop `CutPreviewPlayback` owns player observers, coverage and cleanup.
See [preview workflow](workflows/cut-preview-workflow.md) and [ADR-089](decisions/ADR-089-plan-preview-and-approval.md).

- Core fixtures test editing semantics and conservative failure behavior.
- Real SQLite package tests verify migrations, rollback, reopen, relationships,
  source identity preservation, and complete atomic edits.
- Adapter integration fixtures verify actual media properties and resulting ranges.
- Live sessions exercise transcription, the Rough Cut, editing and export on real
  recordings; that evidence lives in local project data, not in the repository.
- EC-18 evaluates quality on authorized held-out recordings, separately from unit tests.

Run `swift test --disable-sandbox` and `python3 scripts/check_schema.py` for the current
package and schema contract. In an iCloud-synced checkout, run
`sh scripts/setup_build_dir.sh` once so build output lives outside the synced tree;
otherwise File Provider metadata on new directories makes the resource-bundle
code-signing step fail under the default build system. Fixture success cannot establish live provider quality,
actual export fidelity, or the 5–15 minute creator review promise.

If the environment cannot write the default compiler caches, the verified command is:

```sh
env CLANG_MODULE_CACHE_PATH=/private/tmp/easycut-clang-cache \
  SWIFTPM_MODULECACHE_OVERRIDE=/private/tmp/easycut-swift-cache \
  swift test --disable-sandbox --cache-path /private/tmp/easycut-spm-cache
```
