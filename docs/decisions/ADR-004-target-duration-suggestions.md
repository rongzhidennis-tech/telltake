# ADR-004: Suggest story-level cuts to reach a target duration

- Status: Proposed
- Date: 2026-08-17

## Context

Mechanical cleanup can remove false starts, pauses, and redundant takes, but a 20–30 minute recording may still contain 5–8 minutes of unique spoken content. The intended social-media output is approximately 3–5 minutes. Reaching that duration requires story-level judgment, which is more subjective than mechanical cleanup.

## Decision

After the AI Clean Cut is ready, v1 accepts a creator-selected target duration range and generates a complete optional AI Story Cut to help reach it. The creator should be able to preview this shorter version immediately as a whole rather than approving a long sequence of individual suggestions first.

The creator expresses the desired length as a target range, such as 3–5 minutes, rather than an exact duration. The AI should optimize for story quality within the range and may explain when the range cannot be reached without more aggressive editorial choices.

If the range cannot be reached safely, the system returns the best coherent Story Cut it can, reports the actual duration and explains the limitation rather than refusing to produce a result.

The AI Story Cut must expose its story-level differences from the AI Clean Cut in the transcript. Each removed section remains inspectable and reversible, with actions such as previewing the resulting transition in context and restoring the removed section. The AI Clean Cut remains available as the baseline for comparison and recovery.

The product should distinguish:

1. an automatically applied, mechanically cleaned proposed cut; and
2. an immediately previewable, optional story-level proposed cut; and
3. the individual story-level removals that explain the difference and can be accepted, rejected, or restored.

The AI must not silently remove story content merely to satisfy the target duration.

## Consequences

- The creator can evaluate the story-level result at video/story level first, which avoids turning AI assistance into a checklist.
- The interface needs to show the expected duration impact of the complete story cut and the individual removals that compose it.
- "Preview in context" should preview the transition from the content before a removal to the content after it, rather than only playing the removed segment.
- Suggestion quality should be evaluated by creator acceptance, individual restoration behavior, and time saved, not just by duration accuracy.
- The system needs a working notion of story segment boundaries and importance, even if it does not make those decisions automatically.

## Open questions

- How should the story cut explain its overall narrative changes?
- Should creators be able to maintain multiple manually edited story-cut variants?
