# Case File stage dossiers — P16-59

28 September 2026. Case File now opens a stage directory inside S4, with ten
named cases mapped through existing stage IDs and their two internal story
chapter IDs. `data/stage_story.json` provides ten premises and twenty concise
canonical recaps. The original dialogue, fragments, stage mapping and ending
choices remain authoritative and unchanged. No save schema or content ID changes.

The first case includes the prologue. Only seen milestones expose summaries and
scene art. Reaching a stage without seeing its preceding story uses a neutral
premise; missing puzzles are honestly marked coming soon. The last case offers
only the saved ending and only after its story is seen. No archive action grants
rewards, marks story progress or changes an ending; legacy mutating S4 handlers
are guarded in archive mode.

The shared navy/brass interface adds stage selection, clear story progress,
individual reports, uncropped illustrations, separate named dialogue, scene
counts and Previous/Next. Reader → case → directory → Safehouse back navigation
supports Escape, restores focus and preserves the directory scroll. Arrow keys
work in the reader. The original post-win S4 flow remains intact.

P16-59 is complete. Validation used temporary project copies and isolated saves:

- `artifacts/validation/case-file-stages-complete-20260928`: import/startup,
  planning/localization/chapter validation, 85 Case File assertions and 17
  Safehouse assertions passed. Covers stable stage mapping, spoiler gates,
  selected-ending replay, save immutability, back navigation, reader bounds and
  the actual text/button clearance of every filed report. Test clocks are fixed
  so natural energy timestamp bookkeeping cannot contaminate save comparisons.
- The same run produced 22 GPU captures at 720×1280 and 390×844. Representative
  directory, report and reader captures were inspected. Report actions track
  actual wrapped label height, including subsequent reflows.
- `artifacts/validation/case-file-stages-accepted-20260928/test_r13_flow.log`:
  353 existing flow assertions passed. That run exposed the long-recap layout
  issue; the later complete run above verifies its fix. Total relevant checks:
  455. No claim is made that the earlier run passed every suite.

Future-stage/finale captures use explicit seen-story fixtures; they do not mean
all 100 puzzles or later story illustrations are produced. Existing authored art
is reused, with the existing background fallback for unillustrated scenes.
Device touch/safe-area acceptance remains P16-29; unproduced puzzles and story
artwork remain P16-30 and P16-27. Next phase remains P16.

## Live editor follow-up — 28 September 2026

The user reported that Case File still opened the old prologue with Home/Next.
The running Godot debug preview reproduced that old interface while the project
files already contained the stage directory. Reloading the project and starting
a fresh preview resolved the stale runtime. Activating the actual Safehouse
Case File button through keyboard focus then visibly opened the new directory,
with Stage 1 and Stage 2 available and later cases sealed. The preview was left
on that directory. No additional gameplay code change or save reset was needed.
