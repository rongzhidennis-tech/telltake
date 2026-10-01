# ADR-093: Require one-time user-level cloud processing consent

- Status: Accepted
- Date: 2026-09-18
- Scope: EC-19 small-scale testing phase; integration validation complete; EC-18 quality gate separate
- Amends: ADR-072's unresolved provider/model choice; clarifies ADR-006,
  ADR-022 and ADR-077 cloud authorization and deletion boundaries

## Decision

Use OpenAI `whisper-1` for original-language transcription with word timestamps
and `gpt-5.6-terra` for take/repetition and Story analysis. This is the accepted
initial integration choice, subject to later authorized quality validation, not
a claim that the models meet the release quality gate. [ADR-094](ADR-094-cloud-credentials-and-test-integration.md)
records the approved credential, retention, retry and uncalibrated test settings.

Cloud processing requires one explicit, user-level consent. It is not scoped to
a recording or project. A valid grant covers existing and future recordings and
subsequent transcription, take/repetition analysis, Story analysis and explicit
reanalysis within the disclosed scope, without repeated authorization prompts.
Consent permits cloud execution of requested workflow operations; it does not
automatically upload the user's library or remove Start analysis, explicit Story
generation, or corrected-text reanalysis commands.

## First-use disclosure and decision

Before the first cloud AI operation sends any content, show a blocking notice
that clearly explains:

- Audio may be sent to OpenAI for transcription.
- Transcripts and minimum necessary timing/context may be sent to OpenAI for
  take/repetition and Story analysis.
- Original video stays local in this integration.
- Agreement applies to subsequent recordings and cloud AI operations, until
  revoked in Settings; there is no per-recording authorization.
- Applicable provider retention and deletion limits, including that deleting
  Easycut-managed temporary artifacts is not a promise to erase provider logs.

Offer explicit Agree and Not now/Decline actions. No preselected agreement,
implicit acceptance, or authorization inferred from import, local testing,
sequence confirmation, cloud credentials, dataset consent, or this design's
approval is valid. Dismissal and failure to save agreement leave processing
disabled. Declining keeps local project inspection/editing/preview/export
available wherever their existing requirements are satisfied.

## User-level persistence and enforcement

Persist consent in the current user's application settings, outside `.easycut`
packages and the dataset registry. For the macOS prototype this means the local
OS user/application profile; this decision adds no account service or cross-device
consent synchronization. Opening, copying or restoring a project cannot grant
consent to another user.

The record includes a consent version identifying the exact disclosed scope,
explicit state (`granted`, `declined`, or `revoked`), decision timestamp in
RFC 3339 UTC, and the grant timestamp when applicable. Preserve the last grant's
version/time when recording revocation and its timestamp. No record means no
consent. Missing, unreadable, malformed or incompatible records fail closed.
Only a successfully persisted explicit grant enables cloud dispatch.

Ordinary recordings, operations and app restarts must not trigger consent again
while the accepted scope remains unchanged. A material expansion of provider,
data use or retention scope requires a new disclosure/version and explicit
agreement before that changed scope can execute; an unrelated app update does
not invalidate consent.

Enforce the current consent state at the shared live-provider dispatch boundary,
not only in the UI. Cover audio uploads and transcript requests, every stage,
chunk, queued task, retry, resumed job, and reanalysis. No existing or future
recording or derived transcript may be sent before consent is granted. A queued
job's historical grant snapshot cannot override current revocation. Serialize
revocation and dispatch authorization so a stale check cannot start another
request after revocation has taken effect. Any backend dispatch must honor the
same boundary rather than continuing independently of the user setting.

## Settings and revocation

Settings shows the current state, accepted consent version and grant timestamp,
with a clear Revoke cloud processing action. Revocation immediately closes the
dispatch gate and is durably recorded before reporting success. If saving fails,
keep the running application fail-closed and surface the failure rather than
claiming revocation was saved; restart must not silently restore a stale grant.

Revocation blocks future uploads and cloud inference, including downstream stages,
pending retries and recovered work. Cancel in-flight requests where supported
and stop sending further content, but clearly explain that already-transmitted
content cannot be recalled and remote processing may already have occurred.
Existing local transcripts, edits and exports are not deleted by revocation.
Privacy cleanup/deletion requests remain permitted after revocation, using only
the identifiers needed for cleanup, never resending recording content. Preserve
durable pending/failed cleanup status under ADR-077.

Re-enabling processing requires a new explicit grant with a fresh timestamp.
Revocation is not undone by reopening a project or restarting the app. It does
not silently resume cancelled work after re-grant; use existing explicit workflow
or retry commands.

## Separate dataset purposes

This grant is solely for the user's cloud-assisted editing workflow. It does
not admit any recording to an evaluation corpus, permit product/model improvement
or training, or replace the purpose-specific per-item controls in ADR-030,
ADR-073 and ADR-076. Dataset use still requires those permissions; cloud
processing of dataset content additionally requires the cloud-processing gate.
This explicitly distinguishes ordinary user operations from dataset admission;
it does not introduce per-recording cloud authorization for ordinary editing.

## EC-19 verification requirements

Before any real-media cloud test, use deterministic spies/fakes to verify:

1. Fresh installation, dismissal, decline, malformed records and failed grant
   persistence cause zero audio/transcript content dispatches.
2. Agreement persists its version and timestamp; restart and another project or
   recording reuse the grant without a new prompt. Pre-existing recordings are
   equally blocked before the grant and eligible after it.
3. Take analysis, optional Story and reanalysis all pass through the same gate;
   granting consent itself does not start unsolicited processing.
4. Settings revocation blocks queued/chunked work, retries, downstream stages and
   reopen recovery, including revocation racing dispatch. In-flight cancellation
   is best-effort and no future content request starts after revocation.
5. Revocation survives restart; persistence failure is fail-closed. Cleanup still
   runs without content uploads, and local review/export remain usable.
6. Explicit re-grant records a fresh timestamp; unchanged scope does not re-prompt,
   changed scope requires agreement, and project transfer cannot transfer consent.
7. Cloud consent cannot bypass the separate dataset purpose gates.

Only after the consent implementation passes these checks and the testing user
explicitly grants consent in Easycut may real recordings be processed. Design
acceptance alone is not an operational grant.

**Historical implementation checkpoint:** Guarded adapters and Settings were added
without a project schema migration. At that checkpoint, verification was offline
only; live credential validation and recording uploads had not been performed.

**Current status (2026-09-18):** EC-19 integration validation is complete, including
the tester's real-media workflows and revocation/restart/local-preview confirmation.
See the [final evidence and limitations](../workflows/cloud-processing-workflow.md).
EC-18 is dependency-ready; its separate quality gate has not passed.
