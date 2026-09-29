# Sun Seal close-packed pixels — P16-43

27 September 2026. User requested slightly smaller pixels/more cells and no spaces between them.

Fresh Sun Seal attempts now use 18×18 / 324 pixels, up from 16×16 / 256. Cell pitch is 11.1% smaller in the same frame. Five matching colors, three shaded block faces and the cool backing remain. Top/front/right polygons tessellate the entire cell square; there are no open wedges or gutters between occupied blocks. Museum and gameplay share those projected corners. The backing is revealed when a cell is collected.

The sampler regenerates exact-budget queues and a deterministic solution. The prior 16×16 board was appended to `source_pixel_history.json`; old 16×16, 32×32 and original small-/large-queue checkpoints preserve their grid, queues, active flights and progress. No other artwork or source image was changed.

## Verification

Completed with isolated saves through `tools/validate_project.py`; planning, localization, chapter validation, clean import and main-scene startup passed. Gameplay regression suites passed 843 checks with zero failures: source pixels 81, heist feedback 701 and heist v4 61. All five GPU captures passed and were visually inspected in `artifacts/validation/sun-seal-gapless/`.

The deterministic source generator passed `--check`. A raster audit of the occupied board interior found zero backing-colored pixels; after clearing a row, the same region contained 3,976 backing-colored pixels (`gap-audit.json`). This confirms continuous occupied faces and visible backing after collection. The conservative serial solver completed in 434.7 simulated seconds at 1×; this is an automated execution measurement, not human playtime.

No player save was reset. Next work remains the outstanding P16 checklist and real-device acceptance. Backup: `.backups/pre-sun-seal-gapless-20260927.tgz`. P16 and real-device acceptance remain open beyond this single-artwork adjustment.
