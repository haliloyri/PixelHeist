# Sun Seal larger cubes — P16-42

27 September 2026. Latest user correction supersedes the 32×32 source-tone pilot for new Level 1 attempts.

## Change

The new Sun Seal board has 16×16 cells: 256 collectible pixels, nine exact-budget packets and five playable colors (navy, bronze, ochre, gold and turquoise). Intermediate sampled tones are mapped to those same colors; there are no independently colored transition pixels. The five readable palette choices interpret the source instead of requiring a literal reproduction. Source-region turquoise coverage preserves the two small stones at this coarser resolution.

Each cell is twice as wide/high as the prior grid. A shared raised-block form has three faces: its top carries the exact gameplay color, while its right/front faces use fixed depth shading. Museum previews draw the same projected faces; gameplay uses a true three-face ArrayMesh. Logical cell centers and ant routing are unchanged by presentation geometry. The cold lavender-blue backing (`#7c87b7`) is absent from the palette and is visible through spacing and collected cells; it creates no extra collectible color.

`data/source_pixel_history.json` retains the previous 32×32 board and queues. Historical 32×32 and original small-/large-queue saves continue on their own grid without wallet, ownership or pixel loss. Only a fresh Sun Seal attempt uses the latest board. Other artworks and the original PNG are unchanged.

## Verification

Completed P16-42. `artifacts/validation/sun-seal-large-cubes/summary.json` passes clean import/startup, planning, localization, chapter generation and five isolated-save suites: source pixels 69, feedback/queues 695, v4/checkpoints/boosters 61, r13 flow 353 and intro 39 — **1,217 checks, zero failures**. New tests cover five shared palette colors, exclusion of the backing color from the puzzle, three-face mesh construction, and old small-/large-queue plus 32×32 checkpoint compatibility.

Five GPU captures passed: gameplay, original detail, pixel detail, exposed backing after Row Beam, and the original/pixel comparison. Gameplay, the comparison and cleared backing were visually inspected: the bigger cell footprint, three shaded faces and lavender-blue exposed surface are visible. Source generation is reproducible through `python3 tools/build_sun_seal_pixels.py --check`; the 100-original asset audit also passes.

The conservative full-flight solver wins without boosters in 330.1 simulated seconds at 1× (previous pilot: 1,110.3). This is deterministic solvability/pacing evidence, not an observed human playtime or real-device acceptance. A fresh isolated interactive playtest was opened for the user.

Backup: `.backups/pre-sun-seal-large-cubes-20260927.tgz`. Existing player saves are never opened by test fixtures. Next: user review of this new Sun Seal treatment; real-device acceptance and the rest of P16's content remain separate.
