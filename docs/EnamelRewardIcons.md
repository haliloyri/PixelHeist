# Satin-enamel reward icons — P16-64

29 September 2026 · Design revision 2026-09-25-r13.

Apply Halil's approved material/color revision of the six frameless objects.
`assets/ui/rewards/enamel_objects.png` is the exact built-in imagegen output
`exec-c87201a3-beb2-4fad-844c-4e8b535d5a96.png`, copied without pixel edits.
1536×1024 RGBA; six 512×512 cells in the existing stable semantic order.
The earlier medallion atlas remains available but is no longer consumed.

The new objects use satin enamel, softly aged warm brass and coordinated teal,
blue, coral and plum. The generated silhouettes, soft lighting and alpha are
preserved. `reward_art.gd` supplies the atlas to Safehouse shortcuts, the reward
overview, receipts and offer previews. Shortcut illustrations now occupy a
138-unit-high area; native titles and statuses sit below rather than overlapping
the former caption plaques. Existing hit targets, IDs, focus, ownership, ad
caps, claims and persistence remain unchanged.

Validation passed: clean import/startup, 38 isolated lobby checks and 42
screen-refresh checks (80 total), plus 29 GPU captures at 720×1280 and 390×844.
Evidence: `artifacts/validation/enamel-reward-icons-20260929/`. Reviewed both
home proportions, reward overview and No Ads preview. Object silhouettes,
alpha, captions and hit-target separation are intact. The validated runner
cleaned its isolated user-data directory; player saves were untouched.
Planning-document validation passes. Approved source SHA-256:
`7e0c3b392e4edc1eb0a8c97f25179e1c271a0186189ac3d45043cfec14f11b06`.
 Next phase remains P16; real-device acceptance is
P16-29, real billing/ad integration is P16-24.
