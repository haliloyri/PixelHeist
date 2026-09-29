# Stage 1 illustrated scenes — P16-60

28 September 2026. The user replaced the prose dossier design with a visual
opening/finale flow and explicitly limited scene production to Stage 1.

- New data/stage_scenes.json contains two stable scene IDs and four approved
  English lines, each at most eight words. Existing chapter/save IDs are intact.
- assets/story/stage01_opening.png: museum rooftop preparation.
- assets/story/stage01_finale.png: device on the manifest and Barnaby-marked
  fragment at the Safehouse. No living Barnaby, extra cast or embedded dialogue.
- Generated using the built-in image_gen tool and the approved ch01_opening.jpg
  character/style reference. Exact final prompts: [prompts](../art_review/story/stage01/prompts.json).
- Initial stage_story_scene.gd placed uncropped art above two named dialogue
  cards (superseded by P16-61 below). Case File stage cards open this reader directly. No prose report view.
- Stage 1 opening is available while in progress; finale requires all ten
  artworks, even in legacy saves whose story.seen is incomplete. Replay changes
  no save or reward state. Stage 2–10 production remains outside this request;
  cards retain stable stage/progress data and honestly show Scenes coming soon.
- Live S4 chapter 0 uses the new opening. First-time Level 10 completion opens
  the new finale directly; leaving claims the existing false_owners chest once
  and marks that same story ID, then shows the normal receipt at Safehouse.
  Level 5 and all later live chapter flows are retained. The old stage_story.json
  recap data is retained but is no longer consumed by Case File.

P16-60 complete. Evidence: artifacts/validation/stage-one-scenes-20260928.
Clean temporary project import/startup, localization, chapter validation, 49
Case File checks, 17 Safehouse checks and 353 existing gameplay flow checks all
passed (419 assertions). Tests use isolated saves and a fixed clock. Coverage
includes nine-versus-ten-artwork access, legacy completion with missing seen
flags, direct image navigation, previous/back bounds, read-only archive guards,
live opening → heist, first Level 10 → ending, exactly-once chest receipt and
no automatic finale on replay. All four dialogue lines meet the eight-word limit.

Fourteen GPU captures cover live opening/finale, current and completed Case File
cards, and opening/finale replay at 720×1280 and 390×844. Representative captures
were visually inspected: artwork remains uncropped, text is separate and controls
clear both dialogue cards. Planning documents also pass structural validation.

The user's existing Godot preview was reloaded from disk after validation. The
actual Safehouse Case File action opened the new card list; selecting Stage 1
opened the rooftop picture directly, and Next scene showed the discovery finale
using the existing completed Stage 1 progress. The preview was left on the finale.
No player save reset or test fixture was applied to that preview.

Next phase remains P16. Real-device touch/safe-area acceptance remains P16-29;
later-stage scenes and remaining puzzles are not claimed complete by this change.


## Speech balloons — P16-61

29 September 2026. Both Stage 1 scenes now place the same four English lines
inside cream speech balloons on the illustration, with dark outlines, colored
speaker names and tails pointing toward the characters. The separate lower
dialogue cards are removed in both live S4 and read-only Case File.

Balloon bounds and tail points are authored in data/stage_scenes.json at a
656-unit image width. The shared renderer scales and positions them with the
contained artwork. The frame follows the natural image ratio without cropping
or empty panel bands; faces, the device and both evidence marks stay visible.
Navigation stays outside the art. No story access, save or claim logic changed.

P16-61 complete. Evidence: artifacts/validation/stage-one-bubbles-final-20260929.
Clean import/startup, localization, chapter generation and 51 isolated Case File
checks passed. Fourteen GPU captures cover live and archive scenes at 720×1280
and 390×844; representative opening/finale images were visually reviewed for
readable text, visible faces/evidence, uncropped art and clear navigation.
The user's Godot preview was reloaded, then opening and finale were verified
through the real Case File button using existing progress. It is left on the
finale. No player save was reset. Planning documents pass structural validation.

Next phase remains P16; real-device acceptance remains P16-29 and later-stage
scene production remains outside this change.
