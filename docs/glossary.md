# Product glossary

| Term | Working definition |
| --- | --- |
| Storytelling creator | A creator who speaks to camera while performing an activity and uses the footage to tell a story or explain an experience. |
| Raw footage | The original recorded video before transcript-based selection or cutting. |
| Transcript segment | A time-bounded piece of recognized speech linked to its source media range. |
| False start | Speech that begins but is abandoned before the intended thought is completed. |
| Verbal stumble | A delivery problem such as a mispronunciation, restart, filler-heavy phrase, or broken sentence that may be worth removing. |
| Alternative take | A later or earlier attempt to express substantially the same thought, treated as a selectable option rather than a duplicate to delete automatically. |
| Intended take | The candidate version of an idea the system recommends keeping. Under the accepted Point-6 prior, a verified retake chain defaults to its latest successfully completed attempt; removal eligibility is a separate decision (ADR-104). |
| Rough cut | A first-pass sequence created by selecting and ordering usable source ranges, without final polish. |
| Transcript-first editing | Editing through transcript selections that drive the corresponding video cuts. |
| Reversible edit | An edit whose source media and prior decisions remain recoverable and can be changed without re-recording or destructive media changes. |
| Rough-cut accelerator | A tool that reduces the time needed to produce a reviewable first-pass sequence while leaving final editorial control with the creator. |
| Cleanup candidate | A segment the system believes may be removable, such as a false start, pause, or abandoned sentence. |
| Take group | A set of alternative source segments that express substantially the same thought and can be compared or switched. |
| Mechanical edit | A high-confidence cleanup operation tied to recording mechanics, such as removing an abandoned restart or directly associated dead space. |
| Editorial suggestion | A non-automatic recommendation about story relevance, pacing, length, or emphasis that requires creator confirmation. |
| Proposed cut | The non-destructive sequence generated for review; excluded source ranges remain available for restoration. |
| Target duration | The approximate final length the creator wants the reviewed cut to reach. |
| Target duration range | A lower and upper duration bound, such as 3–5 minutes, used to guide AI Story Cut generation. |
| Source chronology | The original time order of the recording session across its ordered source clips, preserved by all v1 cuts. |
| Recording sequence | The ordered list of source clips that together represent one recording session. |
| Recording session | The single chronological creator session represented by one v1 `.easycut` project. |
| Sequence membership | The versioned relationship that determines whether a source clip is active and where it appears in the project chronology. |
| Project sequence | The creator-confirmed recording order used as the canonical chronology for a specific analysis run. |
| Sequence revision | The version identifier for a project sequence; changing it invalidates dependent locality analysis. |
| Active clip set | The imported source clips currently included in the project’s confirmed recording sequence. |
| Remove from project | A reversible, nondestructive action that excludes a source clip from analysis and export without deleting the file. |
| Read-only timeline context | A playback and orientation view that does not create or modify edit decisions. |
| Local MP4 export | The v1 output: one MP4 rendered on the creator’s device while preserving source media characteristics. |
| Validation surface | The platform used to prove the workflow and stabilize the system; macOS in Phase 1. |
| Product direction | The intended long-term creator-facing platform; iPhone in the current strategy. |
| Portable core | The platform-neutral transcript, take, edit, cut-variant, AI-contract, and rendering-plan logic intended to move from macOS to iPhone. |
| Reopenable project | Persisted edit state that can restore analysis, cut variants, and creator decisions without duplicating the original source clips. |
| Source-media reference | The identity and location information used to reconnect a project to its original local clip. |
| Cloud processing artifact | Uploaded or intermediate data used temporarily by a cloud processing stage, such as extracted audio or model inputs. |
| Default cloud deletion | The v1 policy of deleting uploaded audio and temporary cloud artifacts after durable outputs are returned. |
| Conservative degradation | Preserving affected source content and reducing automation when analysis is incomplete or uncertain. |
| Processing stage | A durable step in the pipeline, such as audio extraction, transcription, take analysis, or cut generation, with its own status and output. |
| Progressive result | An intermediate project result made available before all later processing stages complete. |
| Story-cut generation request | Planned after v1: the creator action that supplies a target duration range and starts AI Story Cut analysis. |
| Default target range | Planned after v1: the editable 3–5 minute range prefilled for AI Story Cut generation. |
| Best-effort Story Cut | Planned after v1: a coherent proposed story edit returned when the target range cannot be reached safely without aggressive removals. |
| Critical false exclusion | An AI removal of content the creator intended to keep; the failure tracked most closely, and the reason every removal stays visible and restorable. |
| Precision-first automation | A policy that prefers missing some removable material over incorrectly excluding intended content. |
| Evaluation corpus | A consented set of representative recordings and intent annotations used to measure model and editing quality. |
| Ground-truth annotation | Creator- or expert-confirmed labels for utterance boundaries, keep/exclude decisions, alternative-take groups, and preferred takes. |
| Development / Improvement Set | Consented recordings permitted for failure analysis, tuning, algorithm improvement, or model improvement. |
| Held-out Evaluation / Regression Set | Recordings reserved for measurement and kept out of development and tuning. |
| Purpose-specific consent | Consent scoped to a declared data use, such as evaluation or model/product improvement, rather than one blanket permission. |
| Creator feedback | A Creator Cut change preserved as evidence about an AI decision or creator preference, without automatically being treated as ground truth. |
| Verified ground truth | An explicit reviewed annotation approved for evaluation or model-development use. |
| Active creator review time | Time the creator actively spends reviewing and adjusting usable AI results, excluding idle, processing, and export time. |
| Total wall-clock time | Elapsed time from import through processing, review, and export. |
| Story-level suggestion | A recommendation to remove or shorten content based on narrative relevance, redundancy, pacing, or duration; it requires creator confirmation. |
| Story section | A contiguous range of one or more utterances that can be proposed for removal from the AI Story Cut. |
| Mandarin-first | A launch scope centered on Mandarin Chinese, while treating natural English insertions as supported content. |
| Code-switching | Switching between Mandarin and English within an otherwise Mandarin spoken recording. |
| Supported speech matrix | The explicitly guaranteed combinations of language, accent, and speaker conditions for a release. |
| Data minimization | Sending and retaining only the smallest data representation needed for a particular processing stage. |
| Stage-oriented pipeline | A processing architecture in which transcription, analysis, and rendering exchange explicit outputs and can be moved between cloud and device independently. |
| Local render | Generating the edited video on the creator’s device using the original local source media. |
| Utterance | A natural sentence- or speech-unit-sized transcript row used as the primary creator-facing editing unit. |
| Word alignment | The mapping from each recognized word to its source timestamp and transcript position. |
| Boundary trim | A limited adjustment to the beginning or end of an utterance’s source range, without unrestricted middle-word deletion. |
| Local retry | An alternative attempt at the same thought occurring consecutively or nearly consecutively in the ordered recording sequence, potentially across source clips. |
| Meaningful story progression | New content between two candidate utterances that advances, changes, or intentionally revisits the story rather than merely representing failed attempts or restarts. |
| Progression boundary | An intervening span treated as meaningful story advancement; it prevents automatic alternative-take grouping across the span. |
| Possible alternatives | A non-applied suggestion that two separate utterances may be alternative takes even though the system cannot safely group them automatically. |
| Possible-alternatives badge | A visible relationship marker connecting separate transcript rows that may represent alternative takes without collapsing or changing them. |
| Creator-confirmed take group | An alternative-take group explicitly formed by the creator from a Possible alternatives suggestion. |
| Preferred take | The candidate the creator explicitly chooses to represent a confirmed alternative-take group. |
| Take candidate | One utterance within an alternative-take group, identified by its source clip and source time range. |
| Group membership edit | A creator change that adds or removes a candidate from a take group without changing the underlying source media. |
| Sequence-distance guardrail | A configurable bound used to limit which utterance pairs are compared as possible alternatives; passing it does not establish a take relationship. |
| Analysis configuration version | The version of internal thresholds and search settings used to produce a project’s transcript analysis and AI cuts. |
| Analysis run | One complete execution of transcript analysis and AI cut generation under a specific analysis configuration. |
| Immutable analysis output | A model finding or proposal preserved exactly as produced by one analysis run, independent of later creator edits. |
| Recommendation review status | A separate creator-facing state such as unreviewed, accepted, rejected, ignored, or deferred, attached to an immutable AI recommendation. |
| Run-scoped dismissal | A persisted Ignore decision that suppresses a recommendation within its originating analysis run without hiding future-run results. |
| Transcription version | An immutable timestamped transcript result produced by one transcription execution and referenced by downstream analysis. |
| Version-scoped utterance | An immutable utterance identity belonging to one transcription version. |
| Transcript correction overlay | Creator-authored display text layered over recognized transcript text without changing source timing or media. |
| Corrected-text reanalysis | An explicitly requested new analysis run that uses selected transcript correction overlays without changing prior results. |
| Correction-overlay set | The collection of transcript corrections consumed by a corrected-text analysis run; in v1 this is all current corrections for the transcription version. |
| Run-bound Creator Cut | A Creator Cut whose provenance points to one analysis run and one selected AI starting cut. |
| Canonical project state | The authoritative editable project data stored in `state.sqlite`. |
| Resolved cut plan | A self-contained ordered list of source ranges that a cut variant uses for preview and export. |
| Edit operation | A versioned append-only record describing an AI or creator change to cut state. |
| Persistent undo | The ability to reverse prior Creator Cut edits after reopening a project. |
| Session-scoped redo | Redo availability limited to the current valid undo path in the active editing session. |
| Package manifest | Lightweight package identity and compatibility metadata stored in `manifest.json`; it does not duplicate the edit graph. |
| Durable project contents | The backup-required project state: `manifest.json` and `state.sqlite`; exported files are optional and caches are excluded. |
| Cache-less recovery | Opening and using canonical project state successfully without any derived cache artifacts. |
| External export | A rendered MP4 stored outside the `.easycut` package, with optional project metadata/reference. |
| Review-only mode | A project state that allows transcript and edit-decision inspection while source-dependent playback and export are disabled. |
| Partial relinking | A recovery state in which some source clips are validated and usable while other project clips remain missing. |
| Source identity | Stable fingerprint and media metadata used to prove that a relinked clip is the original project source. |
| Visible excluded state | A dimmed transcript state for content excluded from the current cut but still available for playback and restoration. |
| Non-speech context span | A speechless source range shown for visual context and playback; it is not a normal utterance or take candidate in v1. |
| Visual-only preservation | The rule that no-speech footage stays in every AI cut unless the enclosed-gap rule applies or the creator removes or shortens it explicitly (ADR-107, narrowed by ADR-109). |
| Curated context row | Historical name for a no-speech row. Since ADR-109 every positive gap between timed lines and at clip edges is a visible, playable, restorable row, including gaps under two seconds. |
| Cross-file take group | An alternative-take group whose candidate utterances come from more than one source clip. |
| Canonical row | The collapsed transcript row representing the currently selected take from an alternative-take group. |
| Take-selection decision | The explicit AI choice of one candidate take as the proposed version for a take group. |
| Take-selection badge | The compact label on a canonical row naming who chose the take and its position, e.g. "AI picked take 2 of 3" or "You picked take 2 of 3", with a Show alternatives action. |
| AI Rough Cut | The analysis baseline the shipped app generates (ADR-107): continuous passages the model proposes to keep from the whole transcript, validated line by line; anything the validator cannot place exactly is kept and marked Needs review. Stored in the Clean-kind cut slot. |
| AI Clean Cut | Legacy: the precision-first mechanical baseline of earlier builds, produced by per-utterance take analysis. Existing cuts still open; the shipped app does not generate new ones. |
| AI Story Cut | Planned after v1 (ADR-083): an optional shorter proposal for a target duration made of story-level removals. Not generated by the shipped app; saved proposals remain reviewable. |
| Cut variant | A non-destructive, reviewable sequence derived from the same source media and edit decisions. |
| Cut diff | The explicit set of source-range additions, removals, or replacements that distinguishes one cut variant from another. |
| Context preview | A preview of the resulting transition from content before a proposed removal to content after it. |
| Creator Cut | The editable working cut created automatically from whichever AI baseline the creator first changes manually (ADR-081); the baseline stays intact. |
| Edit provenance | Metadata identifying whether a cut decision came from an AI baseline (Rough Cut, legacy Clean Cut or Story proposal) or a creator action, recorded as append-only edit operations. |
| Restart-associated pause | Silence that occurs as part of a detected false start, abandoned take, restart, or repeated attempt and may qualify for automatic removal. |
| Standalone pause | Silence not confidently tied to a mechanical failure; it remains by default and may be suggested for optional removal. |
| Optional Cleanup | A future-facing concept for uncertain cleanup candidates; standalone pause and filler-word tasks are not exposed as first-class v1 objects. |
| Line | The user-facing name for an utterance row in the transcript review. |
| No-speech row | The user-facing name for a non-speech context span or derived gap: a stretch with no transcribed speech, shown with its duration, playable, and kept by default. |
| Retained passage | A continuous quotation the Rough Cut proposes to keep, validated exactly against the saved transcript before it can remove anything around it. |
| Withheld proposal | A Rough Cut removal the app refused to apply because its quotation, timing or ordering could not be validated; the affected lines stay and carry a Needs review note with the reason. |
| Needs review | The orange note on a line or gap that the AI proposal or a default rule touched in a way the creator should check: withheld proposals, timing issues, and gaps removed by the enclosed-gap rule. "Needs review only" filters the transcript to these rows. |
| Review note | A note saved with the transcript by the transcription provider client, such as "no speech detected" for a clip; shown on the affected rows and never a licence to cut automatically. |
| Enclosed gap | A no-speech row whose nearest speech on both sides is fully removed. It is removed by default with a visual-content warning and can be restored (ADR-109); a gap with a partly kept neighbour, overlapping speech or incomplete transcript coverage stays. |
| Remove enclosed gaps | The explicit action that applies the enclosed-gap rule to a saved cut without another AI request, recorded as one undoable edit. |
| Shorten pause | A manual, reversible edit on one no-speech row that removes its middle and keeps time at both ends (0.6 s by default, at least 0.4 s), forking or revising the Creator Cut (ADR-108). Never applied automatically or to all gaps at once. |
| No-speech rows only | The transcript filter that shows only no-speech rows, including gaps shorter than two seconds (formerly "Pauses only"). |
| Join | The point in the prepared cut where one retained source range ends and the next begins. Previous join / Next join start playback one second before each join so transitions can be checked. |
| Full preview | Watching the prepared cut from start to end in the preview player; required before Approve this cut. Playing single rows does not count. |
| Approved cut | A cut plan the creator approved after a full preview; export renders exactly that plan and records its hash. |
| Compatibility gate | The check run by Check & confirm sequence: dimensions, aspect ratio, frame rate presence, audio format, orientation, colour format (HDR/SDR and bit depth) and unchanged, available source files. |
| Colour format | A clip's codec, bit depth and colour tags as recorded at import; export keeps the source's colour, writing HDR or 10-bit sources as 10-bit HEVC. |
| Transcription checkpoint | The durable per-clip transcription result saved before the next clip starts, so a stopped or failed run keeps finished clips and a retry reuses them (ADR-110). |

**Retake rough-cut boundary**: A conservative, reversible source-time edge for a verified earlier retake removal. Content permission is decided separately; creator acceptance and boundary adjustment are measured independently of content correctness (ADR-105).
