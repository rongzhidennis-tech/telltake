# ADR-029: Evaluate on consented real creator recordings

- Status: Proposed
- Date: 2026-08-18

## Context

The hardest cases are messy, natural recordings with false starts, pauses, repeated attempts, code-switching, and creator-specific delivery preferences. Scripted or synthetic examples will not adequately represent the launch workflow.

## Decision

The prototype evaluation set should consist of consented, representative 20–30 minute Mandarin-first single-creator recordings. Each recording should have creator- or expert-confirmed annotations for:

- utterance boundaries;
- intended keep/exclude status;
- alternative-take group membership;
- preferred take, where alternatives exist; and
- criticality of any potential false exclusion.

The corpus is divided by permitted use:

### Development / Improvement Set

Recordings may be used for failure analysis, prompt and heuristic adjustment, confidence-threshold tuning, take-detection improvements, and potentially future model training or fine-tuning only when the creator has explicitly consented to model/product improvement use.

### Held-out Evaluation / Regression Set

Recordings are reserved for measurement and regression testing. They must remain isolated from prompt, threshold, heuristic, and model tuning. Consent to evaluation does not imply consent to improvement use.

Evaluation should separately report Clean Cut mechanical-exclusion precision, critical false exclusions, take-selection accuracy, Story Cut usefulness, active creator review time, total wall-clock time, processing latency, and export latency.

Creator Cut changes are captured as feedback, but they do not automatically become ground-truth labels. Explicit review or annotation is required before using an override to relabel data or evaluate a model decision.

## Consequences

- Ground truth captures creator intent rather than treating transcript similarity as editorial truth.
- Data collection requires clear consent, access controls, and retention rules.
- The evaluation set should include Mandarin-English code-switching and regional accents within the supported launch matrix.
- Changes to models or thresholds can be compared against a stable regression set.

## Open questions

- How many creators and recordings are sufficient for an initial regression set?
- How should disagreements between creator labels and expert labels be resolved?
