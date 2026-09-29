# P16 — r13 casual redesign: implementation record

Design: [GameDesign.md](GameDesign.md) revision `2026-09-25-r13`. Checklist: [ToDoList.md](../ToDoList.md) phase P16.  
Date: 25 September 2026.

## What was built

| Area | Files | Notes |
| --- | --- | --- |
| Controller | `scripts/main.gd` | Rewritten. Keeps the heist engine (queues, drones, routes, pickups, decoys, 3D board) and replaces the r12 meta layer with 6 screens and 7 pop-ups. |
| Screens | `scripts/ui/lobby.gd` (S1), `scenes/ui/heist.tscn` (S2), `scripts/ui/level_complete.gd` (S3), `scripts/ui/story_screen.gd` (S4), `scripts/ui/gallery_screen.gd` (S5), `scripts/ui/shop_screen.gd` (S6) | Pop-ups P1–P7 are built in `main.gd` from `scripts/ui/ui_kit.gd` (shared copper/brass template). |
| Puzzle | `scripts/core/puzzle_state.gd` | Extra docks (max 2), Zap, Scout Fly reveal, Master Key entry override, jam detection. Pick order and routing unchanged. |
| Checkpoint | `scripts/services/heist_checkpoint.gd` | Version 2: validates by pixel conservation so boosters can reorder queues. |
| Save | `scripts/services/progress_store.gd` | Schema 2 (`progress.cfg.v2` + mirror), one-time read-only migration from r12 v1 and pre-P02 ConfigFile saves. |
| Economy | `data/economy_r13.json`, `progress_store.gd` | Gold, energy (10, 20 min), stars, Daily / Star / Chapter chests, boosters, looks, packs, ad rules. |
| Commerce | `scripts/services/commerce.gd` | Purchase and rewarded/interstitial provider boundary with fake providers only. |
| Campaign | `data/chapters.json` (from `tools/build_chapters.py`), `scripts/services/campaign_catalog.gd` | 20 chapters, finales, fragments, crew unlocks, 100 win bubbles, 57 outro panels, opening panel, three endings. |
| Text | `localization/source.json` | New English keys (context `r13`). The game always selects English; tr/es/de catalogs mirror English and are not shipped. |

## Removed

r12 flow screens S01–S20 and `data/screens.json`; target selection, inspection and disposition; four development paths, contact trust, news album, case file, memory studio, workshop, exhibitions and museum corridor; the 600-second 3× budget and refill; undo/restart/sound/help buttons in the heist; the language selector; the demo home. Their services, scenes, data files, validators and test suites were deleted. The full pre-redesign project is in `.backups/pre-redesign-2026-09-25.tgz`.

## Validation

`python3 tools/validate_project.py` on Godot 4.7 (Linux headless, clean temporary copy, isolated saves):

| Step | Result |
| --- | --- |
| planning, localization, chapters | pass |
| import, main scene | pass |
| test_ambience | pass |
| test_puzzle | 6,579 checks, pass |
| test_r13_store | 72 checks, pass — save/mirror recovery, wins, stars, replay, tutorial gift, energy refill, boosters, chests, purchases and restore, ad caps, interstitial rule, v1 and legacy migration, tamper rejection |
| test_r13_boosters | 34 checks, pass — Extra Dock, Zap, Scout Fly, Master Key, jam, Continue, checkpoint, 2×, Retry |
| test_r13_flow | 351 checks, pass — campaign data, Safehouse → Heist → Level Complete → Safehouse, resume without double pay, energy gate, chapter finale → Story → chest, Gallery, Shop, fake purchases and ads, Home costs energy, ending choice |

`tests/capture_r13.gd` walks all 13 screens and pop-ups and writes 25 screenshots to `artifacts/r13/` (run with a display: `--rendering-driver opengl3`).

## Open items

- **Content:** Chapters 4–20 have story and data but no heist puzzles or artworks (85 heists). After Chapter 3 the Safehouse shows "More heists coming soon!". Tracked as P16-30.
- **Art (P16-25–27):** interface icons, crew bugs and speaker portraits are code-drawn placeholders. Comic panels: Chapter 1 (opening + 3 outro panels) uses painted art from `assets/story/` (1024×1280 JPG, listed in `STORY_ART` in `tools/build_chapters.py`); other chapters fall back to the location backgrounds. Bubbles sit top-left and bottom-right so the art's centre stays clear.
- **Share:** copies a share line to the clipboard until a native share-sheet plugin is added.
- **Real SDKs (P16-24)** and **device testing (P16-29)** need owner approval and real devices.
