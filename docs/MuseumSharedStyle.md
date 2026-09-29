# Museum shared illustrated style — P16-53

27 September 2026. The Safehouse and Museum now share `home_navigation.gd`:
the actual approved footer atlas, original captions/materials and identical
geometry. Museum selection relocates the turquoise light with a shader; Home
retains the reference appearance. Native hit controls preserve navigation.

Museum gains a brighter existing museum-hall background, dimensional warm title
treatment, richer enamel tabs and six illustrated controls. The generated atlas
is stored in `assets/ui/museum/illustrated_icons.png`. Existing originals, ratios,
scrolling, locked previews, collection, photo export and gameplay stay intact.

`ScreenStyleGuide.md` specifies the visual benchmark, assets, shared component,
colors, font hierarchy, geometry, interaction states and responsive acceptance.
AGENTS.md now requires it for later UI work. English and Turkish product/checklist
updates remain aligned at r13.

Validation: 479 isolated checks passed (17 Safehouse, 109 Museum, 353 r13 flow).
The final visual-only refinements reran all 126 Safehouse/Museum checks; the
flow result remains in `artifacts/validation/museum-shared-style-final-20260927/`.
Final evidence is `artifacts/validation/museum-shared-style-polished-20260927/`:
clean import/main scene, 22 Museum captures/PNG exports, three Safehouse captures,
and planning/localization/chapter checks all passed. Standard 720×1280 and tall
390×844 layouts were visually reviewed, including floors, crew, collection,
editor and photo mode. Runtime files match the final tested source hashes.
The Home footer is pixel-identical to the approved previous Home capture.

The first GPU pass caught texture lifetime issues (white icons), and the next
caught neighboring atlas pixels and inactive glow seams. Retaining the atlas
resource, fitting individual sprite regions and feathering the shader transition
resolved these; the final artifacts are the acceptance evidence. All tests used
unique application profiles and fixture saves, never the player's progress.

P16-53 is complete for desktop. Device acceptance remains P16-29. Next phase remains P16;
this task does not complete remaining interface art, story art or playable content.

## Art production

Built-in `image_gen` (no CLI/API fallback). Final project asset:
`assets/ui/museum/illustrated_icons.png`, 1536×1024 RGBA. Alpha was verified:
705,234 pixels have alpha below 10; 849,978 above 239. The image viewer may display
RGB under transparent pixels; runtime must honor alpha. The first output was
refined for a cleaner alpha background; only the final atlas is consumed.

Generation prompt:
> Use case: stylized-concept. Create ONE production game UI sprite atlas,
> transparent background, wide landscape 3 columns x 2 rows of exactly equal
> square cells. Six fully isolated large richly rendered tactile icons, each
> centered in its own cell with 12% clear transparent margin, no overlap, no
> frames around cells, no words or letters. Top row left: golden classical
> museum building with turquoise lit doorway. Top row center: two overlapping
> ornate thick golden painting frames with tiny cobalt and turquoise landscape
> paintings. Top row right: palm-sized steampunk robot ladybug, copper body,
> green glass eyes, masculine charming robotic character, no human features.
> Bottom row left: four chunky 3D jewel pixels, turquoise cobalt gold coral,
> assembled square mosaic. Bottom row center: ornate brass art-deco museum
> elevator doorway, closed turquoise enamel double doors, clear gold up/down
> triangles at top. Bottom row right: vintage brass camera with large turquoise
> glass lens. Style: polished animated-film painterly digital game props with
> clean ink edges, rich colors, warm golden spotlights, copper and brass bevels,
> deep cobalt-blue shadows. High visual weight and legibility at 64px. Materials
> must have dimensional highlights and thickness, not minimal line icons.
> Entire background true alpha transparency. Do not draw a UI mockup, text,
> characters beyond the specified robot bug, drop shadows that cross cells,
> or a checkerboard. Uniform grid exact six icons, equal sizes.

Final edit prompt:
> Edit target: the attached six-icon sprite atlas. Remove the entire brown/black/
> gold background, all ambient background haze and backdrop, and make it genuinely
> transparent alpha. Keep ONLY the six solid objects, unchanged in rendering,
> color and exact 3-column 2-row positions. No glow outside silhouettes, no
> shadows outside silhouettes, no background pixels at all. This is a production
> transparent PNG game sprite atlas. Preserve original resolution 1536x1024 and
> exact equal 512x512 cell layout. Do not replace background with black, white,
> brown or a checkerboard.

## Compact exhibition header follow-up

The owner's screenshot feedback removes the four-line text stack beneath the
upper tabs. One 60-unit toolbar now holds a small floor-number badge, the stage
name, original/pixel toggle and elevator. Total and per-floor ownership counts
are available in the floor directory. The artwork scroll begins at y=296 instead
of y=389, reclaiming 93 design units while keeping the same clearance above the
footer. The directory follows the new trigger position; no save, ownership,
artwork dimensions or interaction semantics change.

Validation: 109 Museum checks passed, clean import/main scene and 22 GPU/PNG
artifacts passed in `artifacts/validation/museum-compact-header-20260927/`.
Original/pixel exhibition, floor directory and 390×844 layout were visually
inspected. English/Turkish design, P16-53 checklist wording and the shared style
guide were updated; planning validation passes. P16-53 remains desktop-complete;
next work stays P16 and device acceptance stays P16-29.
