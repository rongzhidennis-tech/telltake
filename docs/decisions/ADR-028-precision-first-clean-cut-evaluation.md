# ADR-028: Evaluate AI Clean Cut with precision-first safety metrics

- Status: Proposed
- Date: 2026-08-18

## Context

The AI Clean Cut is presented as high-confidence mechanical cleanup. Creators need to trust that automatically excluded content is genuinely failed, redundant, or mechanically unwanted. The costs of errors are asymmetric:

1. missed cleanup is low severity;
2. an incorrect take recommendation is moderate severity because alternatives remain available; and
3. exclusion of intended story content is critical severity.

## Decision

V1 evaluates AI Clean Cut with precision over recall. When uncertain, the system keeps the content or surfaces it separately rather than automatically excluding it.

The initial prototype target is approximately 98–99% precision at the utterance/edit-decision level on representative evaluation footage. This aggregate metric is not sufficient by itself: critical false exclusions of intended story content must be tracked as a separate metric and treated as near-zero tolerance.

AI Story Cut decisions may accept more editorial risk because the Story Cut is explicitly optional, previewable, and reversible. Its evaluation should therefore be separate from Clean Cut safety metrics.

## Consequences

- Automatic exclusions need decision-level provenance so evaluation can distinguish mechanical cleanup from take selection and story removal.
- The evaluation set must contain creator-intended keep/remove labels and alternative-take preferences, not only transcript similarity.
- A model improvement that increases recall but causes critical false exclusions is a regression for Clean Cut.
- Product reporting should show trust and safety measures, not only total removed duration.

## Open questions

- How many representative recordings are needed for the first evaluation set?
- Who provides intended-keep labels and preferred-take judgments?
- What exact definition and review process qualifies a false exclusion as critical?
