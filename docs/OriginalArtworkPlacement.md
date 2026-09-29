# Original artwork placement — P16-39

27 September 2026. Latest user scope: find and place original images only; do not create pixels.

## Scope and compatibility

`data/artwork_placement.json` assigns 100 stable artwork IDs to 100 levels, ten per museum floor. The first 15 retain their existing IDs and originals, including three explicitly fictional story artworks. The next 85 use real museum works from the researched public-domain / Open Access pool (84 works) and one supplemental Met work, Cézanne’s The Card Players. This is 97 historical works plus three preserved fictional works, not a claim of 100 new historical paintings.

`data/artwork_images.json` retains the exact download URL, museum source, rights evidence, SHA-256 and date for every added asset. AIC mirrors are accepted only when the Commons file page contains the exact museum object URL or IIIF image UUID and public-domain evidence. Met files come from the museum's own image service. No new image generation, pixel boards, puzzle queues, heist IDs, story events or save grants are included.

The campaign's playable order remains the existing 15 heists. Original assignments are separate from `chapters.json` and `levels.json`. Consequently the end-of-demo message after Level 15 remains: making Level 16 playable requires puzzle authoring that the user explicitly excluded from this task.

## Museum behavior

All ten floors display their assigned originals with natural image proportions, titles and existing ownership locks. Future originals can be opened in the existing painting detail, with artist/date and source museum. They cannot be added to the owned collection. Pixel mode uses an original fallback with an Original label when there is no puzzle board; the detail omits the unavailable pixel toggle.

## Verification

`python3 tools/validate_artwork_originals.py` passes: all 100 assigned files exist, hashes match, image bytes are unique, source/rights fields are present, and the first 15 playable IDs remain unchanged. Backup byte comparisons also confirm `levels.json`, `large_packet_queues.json` and `chapters.json` are untouched.

Five relevant isolated-save suites pass with **1,026 checks**: artwork placement 492, heist intro 39, r13 flow 353, r13 store 72 and stage museum 70. Evidence is in `artifacts/validation/originals-100-verified/` and the final corrected museum expectation in `artifacts/validation/originals-100-museum-final/`. The earlier museum assertion expected empty future slots; it now requires assigned originals while still requiring only 15 playable heists. Planning, localization, chapter generation, clean resource import and main-scene startup also pass.

The museum capture suite produced **16 GPU artifacts**, including Floor 3, Floor 10 and future-original detail. Those three new views were inspected: proportions, captions, source metadata and unowned locks render correctly. Original-only fallback and ownership protections are covered by the new runtime suite.

The optional broad `--visual` walkthrough (`capture_r13.gd`) is an existing stale fixture: it does not create its screenshot subdirectory and later calls `_open_chest` on the lobby after an outdated solve flow. It was stopped after the targeted museum captures completed. The combined run therefore has a failed overall summary; this report claims only the explicitly passing suites and museum captures, not the unrelated full-screen walkthrough. The first sandboxed import attempt also lacked permission for its separate Godot application-data directory; the isolated elevated retry passed. These logs are retained.

Backup: `.backups/pre-100-levels-20260927-155921.tgz` and its SHA-256 manifest. Player saves are untouched. Next phase remains P16: P16-30's 85 pixel puzzles/solvable queues/story facts are still incomplete; release-territory review and real-device acceptance are separate.
