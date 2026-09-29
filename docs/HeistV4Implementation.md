# Approved v4 gameplay implementation — 27 September 2026

Scope: P16-32, gameplay screen only. Latest approved reference is
`artifacts/design/gameplay-redesign/pixel-heist-gameplay-v4.png`.

## Implementation

- Navy museum background, atlas ornament frame, short/wide recolorable carriers,
  copper ants, brass/ivory controls and Lora numerals. New carrier body is shared
  between active and waiting states; only active rotors unfold.
- Five individual unlit platforms. Three waiting columns, three complete rows,
  cropped fourth row, cyan selectable-front outline. Existing five-lane content
  pages 3+2, preserving authored lane identities and order.
- Compact three-button icon-only footer: Extra Dock, Row Beam, Recall. Legacy
  Scout Fly and Master Key remain usable in Pause; their stock IDs do not change.
- Tall portrait viewports extend the ant travel area and anchor the queue to the
  footer. Ant paths reproject on resize/resume without changing logical progress.
- Row Beam clears the lowest occupied row only when it has no ant reservations;
  matching queue/idle carrier capacity is consumed alongside pixels. Successful
  use spends one stock and counts toward the existing star rule. Old saves gain
  zero Row Beam stock; existing wallet, completion and owned powers are retained.
- Fresh heists start with five docks (+2 maximum extras); existing checkpoints
  retain their authored starting capacity and already purchased extra docks.

## Validation

Focused isolated Godot regression passed in
`artifacts/validation/heist-v4-regression/`: new v4 tests, r13 booster tests,
planning/localization/chapter checks, import, main scene and six GPU captures.
Final evidence is in `artifacts/validation/heist-v4-final/`: puzzle 6,801,
v4 61, r13 boosters 34, r13 flow 353 and store 72 checks, all passing; import,
main scene, planning/localization/chapter checks and six GPU captures passed.
The ambience test's 8 assertions passed, but the Dummy audio driver emitted a
Godot resource-release error at exit, so that run correctly records an overall
failure. The same unmodified ambience test passed cleanly with the real CoreAudio
driver in `artifacts/validation/heist-v4-audio-coreaudio/`. Combined: 7,329 passing
assertions across six suites. This is not a claim that Dummy teardown passed.

Screenshots inspected: start, real active ants, tall portrait, five-lane second
page, reduced motion, and Row Beam. No screenshot contains fabricated capacities;
all values come from live puzzle state. P16-32 is complete for desktop scope.
Next: P16-29 device acceptance and P16-31's remaining feel checks; P16-30 content
production remains separate.

No player save was opened by test processes: runner uses a copied project, unique
application identity, and temporary save fixtures. Pre-edit backup:
`.backups/pre-heist-v4-20260927-123838.tgz`, SHA-256 manifest beside it.

## Asset provenance and typography

- `assets/heist_v4/atlas.png`: user-requested generated transparent asset sheet
  (`exec-da5d40a7-9502-49cc-a490-49421872c6fb.png`), explicit runtime region mappings
  in `heist_skin.gd`; no fixed-grid assumptions. Carrier enamel alone recolors to
  level palette RGB, preserving metal/shading and ivory numerals.
- `assets/heist_v4/museum.png`: generated clean background from the approved mockup
  (`exec-320fd961-6082-485e-b4c7-11da86f3e83b.png`). Prompt requested the same navy
  museum/lamps/columns/floor, with all UI, painting, ants and boxes removed.
- Lora variable font: official Google Fonts repository, `ofl/lora`, licensed under
  SIL OFL; license copied to `assets/fonts/Lora-OFL.txt`. Lora Bold weight 700 is
  used for carrier numbers; existing UI fallback remains for small utility text.
- Fixed trim: navy `#151D35`, antique brass `#B89350`, ivory `#F2E5CA`, selection
  cyan `#80DCE8`. Gameplay enamel is the actual artwork palette, not eight fixed
  semantic color classes. This keeps pixel/carrier matching unambiguous.

## Remaining work

P16-29 real iOS/Android device feel/performance/accessibility acceptance remains
open. New five-dock starts alter difficulty and require playtesting. No store,
ad-provider, publishing, signing or real purchase was performed. P16-31's device
feel work and P16-30's remaining campaign content are not completed by this pass.
