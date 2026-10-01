# ADR-101: Keep transcript editing beside cut preview

- Status: Accepted
- Date: 2026-09-18
- Scope: Improvement point 3; desktop review surfaces in EC-05/08/13/15

## Decision

Use a two-column review workspace, initially 58% transcript and 42% preview.
Remember the divider proportion in local app preferences and constrain both
panes to usable widths. Keep the transcript independently scrollable and the
aspect-fit player at the upper right. Keep cut selection, duration and export
in a compact toolbar; keep row playback, Remove/Restore and Undo/Redo with the
transcript. Optional take comparison, Story, boundary and correction tools are
collapsible and independently scrollable below playback.

Search is a display filter over recognized/corrected transcript text and source
filenames, including excluded rows and alternatives normally collapsed in groups.
It never changes inclusion or group membership. Clearing search restores the
normal grouped view. Text wraps at the current column width and supports local
12–22 point sizing. Exclusion and partial inclusion have explicit text labels.
Selection and scroll are retained across ordinary edits and text resizing.

## Consequences

Window layout does not alter preview coverage, approval, source validation or
edit persistence rules. Playback can remain paused while searching or opening
optional tools; actual edits still invalidate incompatible playback. The outer
window regions follow its frame so optional-tool fitting sizes cannot shrink
the transcript. Automated checks cover desktop/laptop sizes and saved divider
proportions; live Test23 checks are recorded in `improve_idea.md`.
