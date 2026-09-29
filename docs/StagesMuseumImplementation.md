# Stages, museum and private collection — P16-37

27 September 2026; implements the approved plan after “yap”.

## Structure and compatibility

`data/stages.json` defines ten stable stage IDs, names and level ranges. The
campaign exposes exactly 100 floor slots (ten per stage). Existing twenty
five-level story/claim IDs stay intact and pair into stages, avoiding replayed
rewards or lost story/crew state. Existing 15 playable artworks map to Levels
1–15; Levels 16–100 remain explicitly unauthored slots, never fake duplicates or
unverified playable puzzles. Their production is P16-30.

Home shows the live stage name and ten-segment progress. Story milestone cards
use stage/level wording. The fifth and tenth level keep existing claim amounts
and identities, so regrouping neither reduces reward cadence nor grants a bonus.
The original plot and fragment levels 10/30/50/75/100 are preserved.

## Museum / collection

S5 now contains Floors, Collection and Crew. Ten floor choices each expose ten
large artwork frames in a horizontally scrollable corridor. Originals are the
default, with a pixel toggle on the wall and detail. Images retain their native
aspect ratio. Existing `artwork_images.json` is the original-image source; game
fiction remains cataloged as fiction. Missing content is labeled Coming soon.

A collection is an optional additive v2-save object: title, up to ten unique
owned art IDs in order, optional featured ID and midnight/emerald/burgundy theme.
Pre-feature v2 saves load an empty default room. Save validation rejects unowned
or duplicate IDs, overflow, invalid themes/features and control-character titles.
Every edit uses the existing atomic commit; no purchase or reward is involved.
Works remain on their permanent floors. Add/remove is accessible in the artwork
detail and room editor; the editor also reorders, features and renames.

View in Museum is available on ordinary Level Complete screens; first-time
story milestones keep Continue so the optional visit cannot skip their story.

## Photo export

A separate HUD-free scene renders the collection into a SubViewport at 1080×1350
or 1080×1920. It contains artwork, room title/theme and a small Pixel Heist mark.
The layout adapts to fewer works; the saved output contains no controls, wallet,
locks or save identifiers. The photo preview is the same room renderer as export.
Save PNG uses a file dialog with explicit destination selection and reports errors.
No image is uploaded or posted. This is a real local image export, not a clipboard
text substitute. Native iOS/Android social share sheets need a platform adapter
and device evidence; they are not claimed implemented by the desktop fallback.

## Verification

`artifacts/validation/stages-museum-final/summary.json`: all eleven suites passed
(8,156 assertions), plus planning, localization, chapter generation, clean import
and main-scene checks. `test_stage_museum.gd` contributes 62 checks covering stage
boundaries/100 slots, pre-feature v2 loading, selection ownership/duplicates/cap,
feature/order/title/theme persistence, atomic failure behavior, unchanged wallet
and floor ownership, milestone claims and museum/photo navigation.

Eleven GPU artifacts were captured: Home, original and pixel floors, original
painting detail, collection, editor, photo preview, tall layout and three real
PNG exports. Original 4:5 (1080×1350), pixel 9:16 (1080×1920), and a single-work
4:5 export were inspected. Long artwork captions fit their frame widths; original
images keep their proportions. Output files contain no game HUD. Export returns
an error instead of success when the PNG cannot be written.

Existing save/progression and heist/intro/motion tests remain green. Planning
documents and task states were validated again after the final evidence update.
Desktop evidence does not replace actual iOS/Android touch, performance or native
share-dialog tests.

## Preservation / next work

Backup `.backups/pre-stages-museum-20260927.tgz` contains scripts, scenes, data,
localization, docs, tools, tests and instructions. Player saves are never used by
validation. No existing heist content, intro, puzzle rule, shop or payment changes.
Next: P16-30's 85 complete artwork/pixel/queue sets; P16-29 touch and performance
acceptance; real mobile share adapter. This task does not mark those complete.
