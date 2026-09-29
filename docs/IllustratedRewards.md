# Illustrated Safehouse rewards — P16-62

29 September 2026 · Design revision 2026-09-25-r13.

References: `sc/main-screen.PNG` and `sc/Reward-Path.jpeg`. The requested
`sv/rewar.png` is not present; the existing reward-path reference informs the
large art and card hierarchy. The reward path is not copied as a season pass.

Six side medallions, a two-column illustrated overview, matching reward receipts
and offer previews reuse the existing claim/product/provider contracts.
No Ads opens its own preview; purchases still need the explicit price action.
Counters and English labels are native, never baked into art. No save migration.

Art: `assets/ui/rewards/medallions.png`, generated using the built-in imagegen
tool. Prompt and transparency correction are recorded in the adjacent prompt
file. No character art or narrative is changed.

Implementation: `scripts/ui/lobby.gd`, shared `scripts/ui/reward_art.gd`,
`reward_panel.gd` and the existing offer branch in `scripts/main.gd`.
The approved background, Play artwork and footer remain intact; on taller
portraits the middle/bottom side rows share the extra vertical space.

Validation: `artifacts/validation/illustrated-rewards-final-20260929/` passes
clean import/startup and **505 isolated checks**: lobby 38, screen refresh 42,
r13 flow 353, store 72. The runner produced **29 GPU captures** at 720×1280 and
390×844. Reviewed home at both sizes, reward grid, daily receipt, No Ads,
owned entitlement and exhausted-ad states. Side hit rectangles clear lower
controls; keyboard focus returns to the opening shortcut. Skipped ads grant
nothing; completed fake ads grant only their verified reward. Owned No Ads
packs disable the duplicate entry; caps disable both ad entry points.

A final copy correction changes the English No Ads product description from
“No more ads” to “Removes interstitial ads”, matching the existing entitlement.
Localization source and generated catalogs are synchronized. The targeted rerun
in `illustrated-rewards-copy-20260929` passed clean import/startup, 38 lobby
checks and seven portrait captures; the corrected No Ads preview was inspected.
Both paired checklists and planning-document validation pass.

A sandbox-only attempt could not create Godot's unique validation user directory;
the isolated runner succeeded with the necessary filesystem permission. No player
save was accessed. The final successful run removed its own isolated user data.

Real-device safe areas/touch acceptance remain
P16-29; real billing/ad SDKs remain P16-24. Next phase remains P16, including
uncompleted art/content/device work; no external release task is completed.
