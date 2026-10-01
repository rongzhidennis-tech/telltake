# ADR-088: Explicit corrected-text reanalysis and non-merging history

- Status: Accepted
- Date: 2026-09-17
- Scope: EC-14, implementing ADR-046–048 and ADR-058–059

## Decision

An explicit corrected-text request carries the displayed transcript and correction
revision. Inside one transaction, validate those optimistic identities and the
existing editing-readiness gate, then freeze all current corrected utterance text
and its sealed correction revision in a new `reanalysis` run and take-stage evidence.
Ordinary initial analysis consumes recognized text with no correction revision.
Legacy evidence without the optional correction ID still decodes.

The text-only provider evaluates that frozen input; successful take analysis is
followed by immutable Clean Cut materialization. The existing atomic activation
rule selects the newest successful request by request time and ID, not completion
order. Pending/failed requests do not displace usable cuts. If Clean materialization
fails after take analysis seals, history reports `awaiting_clean_cut`; the public
materialization command can retry without rerunning or mutating analysis.

Saved display corrections remain separate and may advance while a request runs.
The consumed correction context is the immutable selected run reference, not a
replacement for newer saved display text. Prior AI plans, correction revisions and
Creator plans are never rewritten. New Creator work forks the explicitly selected
AI baseline. A late Story child can update only its currently selected Clean parent.

The current-context Previous analysis view exposes earlier valid Clean, Story and
Creator cuts without changing the default pointer. Labels distinguish earlier-run
Creator work and mismatched display/analysis correction contexts. A newly activated
Clean result becomes the default visible AI result; a same-run Creator Cut can be
resumed on reopen. Project-wide read-only history groups Story children and Creator
derivatives beneath each Clean request, including historical transcripts/sequences.
Current-context editing guards remain in force; history is not a cross-run merge.

Desktop reanalysis accepts an injected text-analysis provider/configuration and is
disabled when absent, just like Story generation. Live provider composition remains
EC-19. No provider, model or retry policy is invented by this slice. No migration is
needed; normalized run correction references and existing stage evidence suffice.
