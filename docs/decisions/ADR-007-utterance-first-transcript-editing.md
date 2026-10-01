# ADR-007: Use utterances for creator edits and words for alignment

- Status: Proposed
- Date: 2026-08-18

## Context

V1 is a rough-cut tool, not a full text-based video editor. Creators primarily need to remove failed takes, choose among repeated takes, remove false starts, and accept or reject story-level suggestions. Arbitrary word-by-word deletion would add complexity without being central to this workflow.

## Decision

The transcript UI presents natural sentence- or utterance-level rows as the primary creator-facing editing unit. Each row can be selected or deselected, and alternative takes can be switched at that level.

The underlying transcript retains word-level timestamps and alignment. Word timing supports precise cut boundaries, take comparison, false-start detection, highlighting, and future fine-grained editing.

V1 may expose limited fine adjustment at the beginning or end of an utterance, including snapping to nearby pauses or natural speech boundaries. Arbitrary deletion of words from the middle of an utterance is not a primary v1 workflow.

Filler words and silence gaps are not first-class creator-facing editing objects in v1. They remain underlying metadata used for alignment, take detection, and natural boundary selection. The meaningful creator decisions are whether to keep an utterance, choose among alternative takes, or remove an utterance or multi-utterance story section.

## Consequences

- Transcript segmentation quality is central to the creator experience.
- The data model must preserve both utterance identity and word-level timing.
- The UI can remain focused and fast while the editing engine retains future flexibility.
- The product avoids turning filler-word cleanup and pause trimming into a separate checklist or micro-editing workflow.
- Export decisions should be represented as source ranges derived from selected utterances and boundary adjustments, not as destructive text mutations.

## Open questions

- What defines an utterance boundary when the speaker pauses, restarts, or code-switches?
- Should a long utterance be split automatically for review, or only when the system detects a meaningful boundary?
- How should an utterance be displayed when its words are spread across multiple source ranges after trimming?
