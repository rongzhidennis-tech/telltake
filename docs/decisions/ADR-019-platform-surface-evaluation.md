# ADR-019: Evaluate iPhone-first and macOS-first against the real creator workflow

- Status: Accepted
- Date: 2026-08-18

## Context

The target creator records, reviews, edits, and publishes on an iPhone. The v1 workflow is:

> import multiple phone clips totaling 20–30 minutes → cloud transcription and AI analysis → utterance-level review → local cut preview → local MP4 export → publish from the phone

The product should not default to desktop merely because traditional video editors are desktop applications. However, local media handling, transcript review, and rendering may be easier on macOS.

## Current capability evidence

Apple’s PhotosUI provides system photo/video pickers for iOS and gives the app access to selected assets, which supports a privacy-conscious import flow. [PhotosUI documentation](https://developer.apple.com/documentation/photosui/)

AVFoundation supports audiovisual asset inspection, composition, playback, and export on Apple platforms. AVComposition represents source-track segments that can be arranged into an edited sequence, and AVAssetExportSession exports an asset using a selected preset. [AVFoundation](https://developer.apple.com/documentation/avfoundation/), [AVComposition](https://developer.apple.com/documentation/avfoundation/avcomposition), [AVAssetExportSession](https://developer.apple.com/documentation/avfoundation/avassetexportsession)

iOS supports foreground-started continuous processing tasks that can continue when the app is backgrounded, including examples such as video export. These tasks can be queued, cancelled, or terminated under system constraints and therefore require progress reporting and recovery behavior. [Performing long-running tasks on iOS and iPadOS](https://developer.apple.com/documentation/backgroundtasks/performing-long-running-tasks-on-ios-and-ipados)

iOS can hand exported media to system sharing services and compatible apps through UIActivityViewController. This supports a phone-based publish handoff without requiring a direct platform integration in v1. [UIActivityViewController](https://developer.apple.com/documentation/uikit/uiactivityviewcontroller)

## Comparison

| Criterion | iPhone-first native app | macOS-first native app |
| --- | --- | --- |
| Fit with recording and publishing habit | Strong: the source video and final handoff already live on the phone | Weak to medium: the creator must transfer footage and may need to move the result back to the phone |
| Import friction | Strong: PhotosUI/share flow can start from the device library | Medium: local files are easy once present, but phone-to-Mac transfer adds a step |
| Cloud transcription and AI analysis | Equivalent; both can extract/upload audio and receive edit decisions | Equivalent |
| Utterance-level transcript review | Medium: smaller screen, but the collapsed canonical-row model keeps the interaction focused | Strong: more room for transcript, player, and expanded alternatives |
| Alternative-take comparison | Medium: viable with inline expansion and focused previews | Strong: more simultaneous context and comparison space |
| Local preview and MP4 export | Viable but operationally constrained by mobile resource, storage, and background-task behavior | Lower-risk inference: sustained local processing and large-file handling are simpler on a desktop |
| Publish from the same device | Strong: system sharing can hand off the exported video to compatible apps | Weak to medium: may require transfer or a separate phone publishing step |
| Product learning relevance | Strong: validates the actual end-to-end creator workflow | Medium: validates AI editing quality but introduces a workflow mismatch |
| Engineering risk for first implementation | Higher: background export, storage pressure, lifecycle interruption, and mobile UX need explicit handling | Lower: easier local file access, debugging, and long-running rendering |

## Decision

If the goal is the fastest internal proof of AI transcription, take detection, and edit correctness, macOS is the lower-risk prototype surface.

If the goal is to validate the product as creators would actually use it, iPhone-first is the stronger product surface. The transcript-first interaction is narrow enough that it does not require a full desktop timeline, and the phone preserves the most important workflow advantages: immediate import, local source ownership, local export, and handoff to publishing.

The product strategy is phased:

1. Use macOS as the initial implementation and development surface to validate the complete AI editing workflow with lower local-media and rendering risk.
2. Treat iPhone as the intended end-user product direction.
3. Keep the transcript model, utterance and take-group model, edit decisions, cut variants, AI service interfaces, and rendering plans outside macOS-specific UI code wherever possible.

The macOS version is a validation prototype, not a commitment to a permanent desktop product. The iPhone implementation will later add Photos import, mobile transcript review, export progress and recovery, and system share-sheet publishing.
