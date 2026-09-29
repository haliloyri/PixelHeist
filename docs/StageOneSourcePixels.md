# Stage 1 readable pixel presentation — P16-51

27 September 2026. Halil rejected the 22-row, 5–9-color Stage 1 board replacements because faces and signature colors disappeared. The replacements and their generator were removed from playable data. A later 48-row visual layer preserved more detail, but its pixels looked too small and its colors were hard to distinguish at game size. The current candidate uses 32-row images with stronger color separation over the existing puzzles. Levels 1–2 retain their approved source-derived boards.

`tools/build_stage_one_pixel_art.py` checks original-image SHA-256 values and generates eight PNGs in `assets/artworks/pixels/`. It preserves each painting's aspect ratio, enhances color and contrast, then selects 16–24 colors according to reconstruction error. Maximum-coverage quantization retains small but defining color regions: in particular, the blue headscarf in *Girl with a Pearl Earring*, which median-cut quantization mapped to beige and near-black. No dithering softens the visible pixels. `data/pixel_visuals.json` records stable artwork IDs, original and generated hashes, dimensions and color counts. `--check` verifies deterministic reproduction. The current source/pixel review sheet is `art_review/stage1_pixels/refined/contact_sheet.png`; `rejected_22px.png` and `size_color_options.png` preserve earlier comparisons.

| Level | Artwork ID | Pixel image | Colors |
| --- | --- | --- | --- |
| 3 | `girl_with_a_pearl_earring` | 27×32 | 24 |
| 4 | `starry_night` | 40×32 | 24 |
| 5 | `moon_gate_mask` | 32×32 | 24 |
| 6 | `mona_lisa` | 21×32 | 16 |
| 7 | `the_kiss` | 31×32 | 24 |
| 8 | `the_scream` | 26×32 | 16 |
| 9 | `birth_of_venus` | 50×32 | 24 |
| 10 | `water_lilies` | 33×32 | 24 |

The image appears on S2 Heist and in S5 Gallery pixel mode. In S2, collected logical cells mask the corresponding image regions. The existing cells, palettes, carriers, queues, budgets, pacing and save fingerprints remain unchanged. S5 shows the complete pixel image at natural aspect ratio, with the original image separately available. Levels 1–2 and 11–15 keep their existing presentations.

Validation: the generator `--check` passes. The clean-copy Godot run at `artifacts/validation/stage1-color-readable-32px/` passed planning, localization, chapter data, import, startup, the r13 flow suite, the Stage 1 visual suite and six GPU captures, with zero failures. The S2 Girl heist and S5 Stage 1 floor captures were inspected: the blue headscarf, blue/yellow night sky and larger pixel blocks are visibly distinct. Earlier validation of this visual-layer mechanism also passed Sun Seal source pixels (115 checks) and stage Museum (109 checks). All runtime checks used isolated Godot data; the player's `user://progress.cfg` was never used.

Remaining: Halil has not yet reviewed the latest 32-row actual game capture. P16-51 stays unchecked until that visual review. Real-device performance and player-observed pacing remain unverified; pixel-image subpixels do not add collectible puzzle cells. P16 continues, and the 85 future playable heists remain P16-30.
