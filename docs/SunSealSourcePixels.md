# Sun Seal source-pixel pilot — P16-41

27 September 2026. Historical record of the first pilot, limited to Sun Seal / Level 1. Fresh attempts now use the later [larger-cube revision](SunSealLargeCubes.md); the 32×32 version is retained for compatible resume.

## Data and rendering

`tools/build_sun_seal_pixels.py` samples the full bundled fictional Sun Seal image into 32×32 cells using BOX area averaging in source sRGB. The source image is not rewritten. `data/source_pixel_boards.json` stores 1,024 RGB samples (693 distinct tones), four logical matching groups, source SHA-256, deterministic 35-packet queues and a solution. Navy/bronze/gold/turquoise carrier colors are representative source samples. The six-cell turquoise group uses its exact budget rather than inventing pixels to reach a larger capacity.

The 2D museum renderer, 3D gameplay instances, carried cargo and Row Beam use source-cell tones. Ants and carrier bodies retain their group's representative color. The sampled 3D artwork uses an unshaded instance-color material so the museum lighting does not recolor its face. No blanket palette change affects other artworks.

The runtime campaign overlays the new board only for Sun Seal. `levels.json`, the original 15-work data, and the large legacy queue file remain untouched. Museum previews use the current authored board. Existing content fingerprints are matched to an archived board before checkpoint validation and resume. Old active Sun Seal sessions continue on their own grid and can be saved again; the next fresh attempt uses the new board. Queue migration rejects incompatible grids.

## Verification

Completed P16-41. `python3 tools/build_sun_seal_pixels.py --check` reproduces the source hash, all 1,024 samples, grouping and queue data. Backup comparisons confirm the original PNG, legacy levels, large queue file and chapters remain byte-for-byte unchanged. The 100-original asset audit and paired planning validation pass.

Five relevant suites pass with **1,313 checks**: source pixels 113, heist feedback/queues 747, v4/checkpoint/boosters 61, intro 39 and r13 flow 353. Source-pixel evidence and four clean GPU captures are in `artifacts/validation/sun-seal-source-pixels-final/`; the four regression suites are in `artifacts/validation/sun-seal-source-pixels/`. The initial headless instance-color readback check failed because the dummy renderer does not expose real GPU instance colors; it was moved to the actual GPU capture, where all six source-color probes pass within 0.005/channel. Source/logic assertions remain in the headless suite. The initial root-window comparison was clipped by project stretch; a dedicated 1080×630 SubViewport now exports the complete side-by-side original/pixel comparison.

The new full route completes without boosters, preserves live checkpoint budgets and records the existing Sun Seal reward. Both small-queue and large-queue historical sessions survive with their original board, ants, ownership and wallet; a fresh attempt switches to the new board. GPU captures cover gameplay, original detail, pixel detail and the side-by-side comparison, all visually inspected.

**Balance limitation:** the conservative serial solver (waiting for active work before each next packet) takes 1,110.3 simulated seconds at 1×. This proves solvability, not a 2–5 minute human playtime. The 1,024-cell density is the requested visual pilot; human pacing, density choice and real-device performance are not accepted as final. No global speed or puzzle rules were changed to mask this cost.

`tests/playtest_sun_seal.gd` opens the pilot interactively through the existing fixture, with a fresh temporary save assigned before `_ready`, normal original/bee opening and no access to player progress. Each launch is independent. The manual playtest was launched after validation.

Backup: `.backups/pre-sun-seal-source-pixels-20260927.tgz`. Test fixtures use isolated saves. No other artwork is converted. Next remains the user's review of this pilot and P16's outstanding content/device work; 85 future puzzles remain unauthored.
