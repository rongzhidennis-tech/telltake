# ADR-031: Treat Creator Cut changes as feedback by default

- Status: Proposed
- Date: 2026-08-18

## Context

A creator may modify the AI Clean Cut or AI Story Cut because the AI made an objectively incorrect decision, because the creator prefers a different style, or because the creator is making a new editorial choice. The final Creator Cut alone does not distinguish these cases.

## Decision

Creator Cut changes are feedback by default, not automatic ground truth. The system preserves the raw difference between the AI proposal and the creator’s working cut, including edit provenance, but does not automatically use that difference to relabel evaluation data or train/improve models.

Promoting a creator override to ground-truth annotation requires explicit review or annotation. A reviewed label should distinguish at least:

- AI error or unsafe automatic decision;
- preferred alternative take;
- creator’s subjective style or pacing preference; and
- other intentional editorial change.

## Consequences

- Model evaluation remains based on explicit intent labels rather than inferred from every final edit.
- Creator edits remain valuable as a feedback queue without silently contaminating the held-out evaluation set.
- The project must preserve enough provenance to compare AI decisions with creator overrides later.
- V1 need not interrupt the editing flow with mandatory feedback questions.
