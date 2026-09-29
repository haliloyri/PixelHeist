# Shared heist artwork HUD — P16-52

27 September 2026. The title plaque and progress ribbon were already shared S2 nodes, but `_layout_heist_frame()` selected their positions with `heist_cell_pitch` and `legacy_fingerprint`. This left artworks without the newer source-pixel metadata, as well as resumed old boards, using the former bottom title and progress layout.

The shared title now sits on the top frame and the brass progress bar/count sits between the level badge and frame for every playable artwork. Older boards retain their logical cells, queue, and on-screen dimensions. If their existing frame begins too high for the shared HUD, the board and frame move down just enough to clear it. The two ant passages remain on the bottom rail and keep their horizontal spacing. No save identity, puzzle rule, wallet or progress data changed.

Validation: `python3 tools/validate_planning_docs.py` passed after paired English/Turkish design and checklist updates. `artifacts/validation/shared-heist-hud-approved-20260927/` passed clean Godot import/startup and four isolated suites: `test_shared_heist_hud` (97 checks across all 15 playable artworks and a resumed legacy Sapphire Cup), `test_heist_v4`, `test_source_pixels`, and `test_sapphire_cup_pixels`, all with zero failures. `artifacts/validation/shared-heist-hud-visual-20260927/` passed another isolated layout run and six GPU captures. The Gleaners at 720×1280 and 390×844 was inspected: its title, count and frame are separated in both portrait sizes. The temporary test application data was removed; the player's `user://progress.cfg` was not used.

Remaining risk: real iOS/Android layout and touch review remains P16-29. P16 continues with pending device and future-content work.
