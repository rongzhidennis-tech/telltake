# ADR-071: Persist recommendation dismissals per analysis run

- Status: Proposed
- Date: 2026-08-27

## Context

Creators should not repeatedly see the same unhelpful recommendation while reviewing a project. At the same time, a later analysis run may use different transcript, model, or threshold inputs and should not inherit hidden assumptions from an older run.

## Decision

When the creator chooses **Ignore**, persist that review decision against the specific recommendation and analysis run. Leave the immutable recommendation unchanged. Ignored recommendations remain available through history or an explicit show-ignored action.

The dismissal does not automatically change the AI Clean Cut, AI Story Cut, or Creator Cut, and it does not automatically carry to future analysis runs.

Each new analysis run creates new recommendation identities with fresh review state, even when a recommendation appears semantically similar to one from an earlier run. V1 performs no automatic cross-run dismissal matching.

## Consequences

- The current review does not resurface dismissed suggestions.
- New analysis runs remain independently auditable.
- The UI needs a way to recover or inspect ignored recommendations.
