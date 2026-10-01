# Local MP4 export

Select a Clean, Story or Creator Cut, play its full preview and explicitly approve
it. **Export MP4…** then asks for a new external filename. Required originals must
still validate; unused missing clips do not block export. Existing files, original
source paths and destinations inside the project package are rejected.

The request saves the approved ordered ranges and plan hash together. Once the
status says rendering, editing can continue: changes apply to the working cut,
not the captured export. **Cancel export** stops an unpublished attempt. Closing
the review window also cancels it. A successfully published file is retained and
its completion recorded even if cancellation arrives at that point.

Rendering stays local and uses validated originals. Preview and export share the
camera stereo-fallback selection and source-range assembly. H.264 video retains
source presentation timing, including mixed/variable frame rates, and AAC audio
retains included content and synchronization. No captions, effects, aspect-ratio
variants or publishing integration are added. Unsupported encoder/input formats
fail explicitly; these fixtures are not a claim of universal codec/device support.

The completed record stores the external path, SHA-256 fingerprint, byte size,
duration and captured plan hash. A temporary sibling directory owns intermediate
files; publication never replaces an existing destination. Filesystems lacking
atomic hard-link support fail safely. The app displays the final path.

If output publication succeeds but the database write fails, the file is retained
at the requested path and the app reports failure. Do not automatically overwrite
it on retry. A process crash may leave temporary output or an unfinished record;
automatic recovery/cleanup is a later slice. See
[ADR-091](../decisions/ADR-091-captured-local-mp4-exports.md).
