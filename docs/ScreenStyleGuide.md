# Pixel Heist — shared screen style guide

Canonical UI implementation reference · 27 September 2026 · P16-53.
Read alongside `GameDesign.md` and `Characters.md` before changing any screen.
The approved Safehouse is the visual benchmark. This guide supersedes conflicting
historical mockups in `VisualDirection.md`; it does not add screens or change gameplay.

## Visual benchmark

Use `assets/lobby/v2/museum_simple.png` for the approved S1 background (P16-63,
29 September): calm navy walls, one central painting and Rocco/Sprocket, with
quiet side lanes for the illustrated controls. The earlier `museum_crew.png`
remains a historical art reference. `reference_ui.png` still supplies the brass
props, turquoise enamel and cream/gold lettering of the unchanged controls. Match the richness of those assets at actual phone size.
Large surfaces stay cobalt/navy, with readable warm light; avoid a nearly black
screen, flat line-icon navigation, or a generic dashboard appearance.

## Shared bottom navigation

P16-65 (29 September) replaces the old raster footer with `home_navigation.gd`:
navy/petrol shelf, individual satin-enamel objects from
`assets/ui/home/enamel_navigation.png`, native Lora labels and a restrained
selected teal tile/underline. The old reference footer/shader remain history.

- Order: Shop / Home / Museum. Canvas width 720; height 146, bottom anchored.
- Preserve hit rectangles `(20,6,220,136)`, `(249,6,222,136)`, `(480,6,220,136)`.
- Icons have warm brass, ivory, turquoise/petrol, soft coral and plum details;
  no enclosing medallions. Atlas order: shop/home, museum/case file (2×2).
- `home_art.gd` derives each cell from the actual source dimensions and preserves
  aspect ratio/alpha. Native captions sit below art and clear the underline.
- Case File uses the dossier illustration next to the wider progress card.
  Remove the redundant bronze reward chest; restore reward focus to the actual
  opening shortcut, defaulting to Daily when opened programmatically.
- `heist_start_button.gd` draws the native satin-turquoise Start Heist action:
  544×108, thin brass edge, soft lower shadow, 34-unit Lora, compact play symbol.
  No baked wording or oversized gold rim. No next authored level means disabled
  More Soon; owned painting replay remains available in Museum.

**Museum navigation exception (P16-55, approved 27 September):** S5 has no footer.
Use a 76×64 back button at `(24,20)` and a centered title in `(124,13,472,77)`;
keep the upper Floors / Collection / Crew tabs. Back returns to Safehouse from
normal views, first exits Collection Edit (committing the name) or Photo mode,
and closes an open floor directory first. Escape follows this hierarchy and
lets Painting Detail close before leaving the screen. Floor content ends 12
units above the bottom. Collection shelves retain a 28-unit bottom inset and
at least 20 units of clearance from scroll content, reclaiming the full 146-unit
footer height. The S1 footer follows its later P16-65 revision.

## Materials and text

| Role | Recipe |
| --- | --- |
| Main surfaces | Navy `#102A35`, enamel `#163944`, dark outline `#102331` |
| Warm lettering | Cream `#FFF0CB`; hero gold `#FFE5A0` |
| Brass edges | Highlight `#EDC77E`, body `#C6A16A`, shadow `#71401C` |
| Selected / primary | Turquoise `#38DBC3`, enamel `#087F72` |
| Typography | Bundled `assets/fonts/Lora-700.ttf`; avoid platform font substitutions |
| Screen title | 52 design units, 4-unit dark outline, 4-unit warm depth shadow |
| Section title | 30 units, warm gold, 2-unit depth shadow |
| Navigation caption | 20 units upper tabs; bottom uses native Lora labels |
| Body / metadata | 18–23 units; readable contrast; fit long names without cropping |
| Buttons | 2–3-unit brass edge, rounded enamel, inner highlight, lower shadow |

English only. Use short titles and show real progress only where it helps the current action.
For the Museum exhibition, keep one compact toolbar under the tabs: floor-number
badge, stage title and two icon controls. Put total/per-floor collection counts
in the floor directory. Do not stack repeated counts, floor labels and large
section titles above the artwork; keep the exhibition visually dominant. Rich typography
must remain readable; do not bake changing values, prices or counts into images.

## Illustrated controls

`assets/ui/museum/illustrated_icons.png` is a three-column, two-row atlas:
Museum / framed collection / copper robot ladybug; jewel pixels / elevator / camera.
`museum_icon.gd` maps semantic IDs to tightly fitted atlas regions (with aspect
ratio preserved and neighboring sprites excluded), so labels and actions remain native.
Keep the atlas resource preloaded: immediate-mode Godot draw commands need its
texture to remain alive after `_draw()` returns.
Use transparent full-color art with generous silhouette padding, dimensional
highlights and brass/copper depth. Inspect every icon at its actual 48–64-unit
size. Keep the existing symbols for actions without a matching illustration;
never reuse an unrelated icon just because it is decorative.

The Museum uses the existing `museum_hall.png` illuminated room, not the busy
Safehouse character painting behind exhibits. Artwork retains its own colors,
natural ratio and dominant visual area. Upper tabs use illustrated props, warm
captions and an explicit selected underline. Small secondary actions stay concise. Upper tabs reserve the last 14 units for
selection feedback; the caption ends above this area. Never draw the underline
through text. `museum_controls.gd` supplies the shared navy/turquoise enamel,
brass edge, inner highlight, depth shadow and transparent focus outline for
Museum actions and Painting Detail (including replay and close).

Collection keeps its Edit / Photo / view action shelf below the scrolling room
with a 28-unit bottom inset and at least 20 units of separation. Edit shows
three layout silhouettes above the room, then the room itself as the placement
surface. Numbered artwork targets use a turquoise selection outline; earlier,
later, first-position and remove actions have their own bottom shelf. Adding
owned work is below the room in the same scroll. Live preview and clean export
share the same layout calculation; never squeeze ten live paintings into tiny
thumbnails to avoid scrolling.

Characters follow `Characters.md` exactly: anthropomorphic animals and palm-sized
copper robot bugs with green glass eyes; never humans. Do not invent character
appearances or use unapproved poses as narrative facts.

## Responsive and interaction acceptance

Work in the existing 720-unit design space and keep the app's portrait scaling.
Check 720×1280 and 390×844 GPU captures, including long floor names, locked art,
original/pixel mode, collection editing, crew, floor directory and photo mode.
Avoid overlap, clipped labels, transparent art carrying a solid background,
double selected states, and controls intercepting neighboring taps.

Reuse existing actions, stable IDs and persistence. A styling change must not
spend energy, grant art, change puzzle rules or alter saved collection membership.
Run the relevant existing tests through `tools/validate_project.py` with isolated
saves. Real phone rendering, safe areas and touch feel remain P16-29 acceptance.

## Settings, Crew and Rewards (P16-56)

Settings/Pause and reward receipts use `museum_controls.gd` for their navy/brass
modal shell, Lora labels and enamel actions. Keep native controls and focus,
explicit On/Off switches and stable modal instances when a preference changes.
Use one obvious primary action; show the energy cost next to the heist exit.
No inactive text should masquerade as a link.

Crew uses the five-column/two-row transparent `assets/ui/crew/portraits.png`
atlas through `crew_portrait.gd`, mapped by stable IDs. Preserve species, copper
bodies and green glass eyes. Muted locked portraits remain previews, with level
requirements. Use a scrolling list of 228-unit cards with readable bios and
60-unit Equip actions, instead of squeezing ten cards into the viewport.

The Rewards tray remains within S1; dim and block the background while open,
keep keyboard focus inside, and restore it on dismissal. Reward readiness is
visible before tapping. Ad actions say Watch Ad. P4 receipts group quantities
instead of running booster names together or showing +0 gold for entitlements.

## Level Complete celebration (P16-57)

S3 uses a centered 664-unit navy/brass card over the museum background. The
painting, shared Lora type, generated victory duo and true saved rewards lead
to an immediately available Continue action. Keep secondary buttons on a
separate shelf; let a single visible secondary action fill the shelf. New crew
gets its own row using the stable-ID portrait atlas. Rocco and Sprocket use
`assets/ui/complete/victory_duo.png`, matched to the approved opening panel.

Use a single bounded burst of gold, turquoise, coral, blue and lilac confetti
above the action shelf. Stagger the three stars and settle the painting and
portraits, then stop processing. No flashing, indefinite bobbing or forced
animation delay. Reduced motion starts fully settled with no particles.
Background suspension/overlays freeze effects; reward updates never replay them.

## Reward celebration (P16-58)

P4 reuses the victory-confetti renderer with 56 smaller-motion pieces and a
single chest pop. Clip the effect below the title/daily strip and above Collect.
It cannot intercept taps, delay dismissal, or change reward quantities. Stop
after 3.2 seconds; freeze while suspended and omit movement with reduced motion.
The Rewards selection tray itself does not celebrate an unclaimed reward.

## Case File illustrated scenes (P16-60 supersedes P16-59 prose)

Use the shared museum backdrop, Lora typography and navy/brass controls. Stage
cards show a thumbnail, title, completion state and Opening / Opening + Finale;
remove premises, report summaries and intermediate Read buttons. A card opens
its first available illustration directly. Only Stage 1 scenes are authored in
this pass; other stage cards say Scenes coming soon and stay disabled.

Use stage_story_scene.gd for both live Stage 1 scenes and archive replay. Show
uncropped art, two named short speech balloons on the image, and bottom navigation.
Remove the separate dialogue area beneath the art (29 September, P16-61).
Cream balloons have dark outlines and tails pointing toward their speakers.
Author balloon bounds/tail points in data/stage_scenes.json at 656 image units
wide, scaling and positioning them with the contained artwork, not the viewport.
Keep faces and evidence free of interface overlays. Opening/finale text and art
come from data/stage_scenes.json; never bake dialogue into the painting. Archive
Back returns directly to cards, preserving scroll/focus. Live opening starts the
heist; live finale returns to Safehouse and uses the existing reward receipt.

## Illustrated Safehouse rewards (P16-62; art revision P16-64)

Six frameless satin-enamel object icons use `assets/ui/rewards/enamel_objects.png`
through `reward_art.gd`: turquoise daily chest, blue star chest, coral milestone
safe, teal video clapper, muted violet No Ads television and plum gift.
Warm brushed brass and soft highlights match the museum and bottom navigation.
This approved P16-64 set replaces the ornate `medallions.png`, retained only as
history. No enclosing circles, caption plaques or ornamental frames.
The atlas is 3×2, 512-unit cells with alpha transparency. Native English titles
sit below the object silhouettes; readiness badges and saved counters remain
separate. Keep the simplified museum background (P16-63); Play and bottom navigation
follow the later P16-65 revision. All shared reward/receipt/offer consumers use the same atlas.

The in-screen Rewards overview uses a treasure hero and two columns of three
illustrated cards; the previous five text rows are superseded. Disabled claims
retain visible progress. The six card destinations use the existing P4/P5 and
provider interfaces. No Ads explicitly selects `no_ads`, with owned state
disabled; it never silently buys a product. Reward receipts and offer previews
share the semantic artwork. Opening the overview excludes background keyboard
focus; dismissal restores the actual opening shortcut.
