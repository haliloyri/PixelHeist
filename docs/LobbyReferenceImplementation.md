# Museum crew home — P16-36, 27 September 2026

The supplied portrait home composition replaces the previous insect/cube lobby.
The museum scene and Pixel Heist logo are one background; button hit areas,
wallet, energy, level and chapter progress remain live Godot controls. Original
static reference button/icon regions use AtlasTexture; their baked example
numbers are never shown. Dynamic type uses bundled Lora Bold (`Lora-700.ttf`),
ivory #FFF0CB with brass #C6A16A and emerald #38DBC3 accents.

## Files and behavior

- `scripts/ui/lobby.gd`: reference layout, top wallet/energy/settings/avatar,
  five progress dots, Start Heist and Shop/Home/Museum. Footer and lower controls
  anchor to the bottom on tall screens, keeping the scene's character proportions.
- A small rewards chest opens an inline tray for existing daily/star/chapter
  chests, free-coins ad and offer actions. No economy or progression is replaced.
- `scripts/ui/story_screen.gd`: Case File uses S4 in read-only archive mode.
  Only opening and seen chapter panels appear. Home/last-page exit does not
  auto-start a level, mark story seen, grant chests or change an ending.
- New display strings have stable localization keys. Release remains English;
  dormant locale catalogs contain explicit English fallback for these keys.
- `assets/lobby/v2/museum_crew.png` was prepared with built-in image_gen from
  the user reference, removing only UI overlays. `reference_ui.png` supplies
  the approved static controls through runtime atlas regions. Full prompt and
  provenance: [generation record](../art_review/lobby/Generation.md).

## Validation

- `artifacts/validation/lobby-v2-verified/summary.json`: 17 home interaction /
  save-isolation assertions and the existing 353-check r13 flow suite passed,
  plus planning/localization/chapter/import/main-scene checks.
- Final GPU captures and focused tests: `artifacts/validation/lobby-v2-approved/`.
  Standard 720×1280, tall 390×844 and expanded reward tray were captured. Native
  hit areas follow the visible controls. Reference atlas corners are clipped
  by `lobby_cutout.gdshader` without repainting or darkening their colors.
- Archive tests cover both Home and last-page exit, seen-panel filtering and
  unchanged wallet/progress/rewards. Existing first-launch/next-heist flow passed.
- Initial old-lobby test expected a hidden `AppleBtn`; the replacement omits
  that retired event control, and the test now accepts absent or hidden.

No player save was used. All runs use the validator's isolated application ID
and disposable fixture save; the interrupted first test's leftover engine was
explicitly stopped. Real touch/device acceptance remains P16-29.

## Preservation and next work

Backup: `.backups/pre-lobby-v2-20260927.tgz`. Original lobby resources remain
for other screens. Stable IDs, economy, first-launch Story, puzzle and heist
intro behavior are unchanged. This does not complete P16-25's remaining modal
art, P16-29 device acceptance, or P16-30's remaining 85 puzzles.
