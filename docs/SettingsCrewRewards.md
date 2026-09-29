# Settings, Crew and Rewards — P16-56

28 September 2026. Applies the shared screen style to P1 Settings/Pause, S5 Crew,
the S1 Rewards tray and P4 receipt. The existing 13-screen contract remains.

Settings retains four preferences but uses native toggle buttons with drawn
On/Off switches and explanatory text. The same modal survives toggles. Save
failure restores the committed state. Pause retains Resume, an explicit -1
energy Safehouse exit and both legacy boosters. Dead Privacy/Support copy is
removed; no support endpoint is invented.

Crew uses spacious scrolling cards and ten individual transparent robot-bug
portraits mapped by stable crew IDs. Locked levels, readable descriptions,
Equip and Equipped replace cramped cards. Save failures do not change selection.

Rewards uses a dismissible, focus-contained overlay within Safehouse. Claim
readiness, cooldown/progress and ad limits are visible. Claims and real provider
boundaries are preserved. Receipts list actual gold and aggregate duplicate
boosters; purchase metadata supplies the real per-booster quantity and extra
entitlements/energy. Collect only acknowledges the already committed reward.

P16-56 is complete. Validation uses isolated temporary saves and a separate
Godot application identity; the player save is not reset.

- Clean baseline: `artifacts/validation/settings-crew-rewards-final-20260928/summary.json`.
  Planning, localization, chapter generation, import, main scene and all five
  suites passed (711 checks, zero failures).
- Final fully-collected milestone state: `artifacts/validation/settings-crew-rewards-completion-final-20260928/summary.json`.
  The expanded screen-refresh suite passed 33 checks (replacing its earlier 32),
  bringing the five suites to 712 distinct checks. The fixture separates the
  15 authored levels from future chapters before modeling a completed campaign.
- 22 new Settings/Pause, Rewards/receipt and Crew captures at 720×1280 and
  390×844, plus 28 Museum/Collection regression captures. Representative states
  were visually inspected for clipping, spacing, portrait boundaries and buttons.
- The initial missing-metadata log error was corrected before the clean run.
  Save failure, persistence, equip state, claim-once behavior, exact receipt
  quantities, dismissal and focus restoration are covered.

Device touch/safe-area review remains P16-29. Next phase remains P16; no SDK or
distribution work is included.

## Art production

Built-in image_gen, transparent output. Asset: `assets/ui/crew/portraits.png`.
Original: `exec-080b8cc8-ad01-4d28-82e9-c39c0922428e.png` in the chat's generated images.
Prompt: one five-column/two-row production sprite atlas with Bit (ladybug), Dash
(dragonfly), Gizmo (beetle), Hum (bee), Flicker (firefly), Pinch (stag beetle),
Skitter (cricket), Velvet (moth), Tock (weevil), Nova (jewel beetle), in that order.
Palm-sized male steampunk robots with copper bodies and green glass eyes,
consistent slightly elevated three-quarter front view, six metal legs, antennae,
engraved brass/copper and turquoise enamel, warm museum light, painterly animated
film style with clean ink contours. Fully isolated transparent backgrounds,
equal cells, generous padding, no humans, labels, numbers, borders or watermark.

### Exact generation prompt

> Use case: stylized-concept. Asset type: ONE production sprite atlas for Pixel Heist Crew portraits, ten distinct full-body robot insect characters, exact grid FIVE columns by TWO rows, equal cells, generous 16% transparent padding within each cell; wide landscape canvas. Canonical cast: palm-sized male steampunk robot bugs with copper bodies and green glass eyes. Top row left to right: Bit, ladybug with spotted rounded copper shell; Dash, dragonfly with four elongated glass wings and slender segmented body; Gizmo, stout beetle with rounded bolted copper wing cases; Hum, bee with striped brass/copper abdomen and two glass wings; Flicker, firefly with luminous green glass abdomen. Bottom row left to right: Pinch, stag beetle with distinctive curved copper mandibles; Skitter, cricket with long folded mechanical jumping hind legs; Velvet, moth with broad soft-edged engraved copper wings and feathery metal antennae; Tock, weevil with long curved snout; Nova, jewel beetle with iridescent turquoise/emerald enameled wing cases over copper chassis. All friendly masculine robot insects, green glass eyes, two antennae, six articulated metal legs where visible. Cohesive stylized animated-film painterly digital game art, clean ink contours, rich copper/brass highlights and turquoise enamel, warm museum spotlights, dimensional toy-like craftsmanship. View each from a consistent slightly elevated three-quarter front angle, fully isolated, no overlap, no shared props, no floor or background, true alpha transparency. Keep every silhouette inside its own cell, no touching neighboring cells. Same visual size and lighting across the ten. No humans, no text, no letters, no numbers, no border, no watermark, no labels, no checkerboard pattern, no white backgrounds.
