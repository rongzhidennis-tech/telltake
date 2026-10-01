# ADR-030: Separate evaluation consent from improvement consent

- Status: Proposed
- Date: 2026-08-18

## Context

Creator recordings, transcripts, and annotations may be useful for both measuring system quality and improving the system. These purposes create different expectations and different risks of evaluation contamination.

## Decision

Data-use consent is purpose-specific. The product distinguishes at least:

1. **Evaluation and regression testing** — permission to use recordings and annotations to measure performance and detect regressions.
2. **Model/product improvement** — separate permission to use recordings, transcripts, annotations, or derived artifacts for failure analysis, prompt and heuristic changes, threshold tuning, algorithm improvement, or model training/fine-tuning.

Evaluation consent alone never grants improvement consent. Recordings collected for evaluation are evaluation-only by default. A genuinely held-out subset remains excluded from development and improvement use even when other recordings have improvement consent.

## Consequences

- Consent records must be attached to each dataset item and purpose, not only to a creator or project globally.
- Dataset pipelines must enforce purpose boundaries technically, not rely only on documentation.
- Reports should identify whether results come from held-out evaluation data.
- Revocation and deletion behavior must be defined separately for evaluation and improvement copies or derivatives.
