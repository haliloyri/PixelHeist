# Unified enamel home controls — P16-65

29 September 2026 · Design revision 2026-09-25-r13.

User requested matching footer/Case File art, removal of the redundant bronze
chest and a review of Start Heist. New built-in imagegen artwork in
`assets/ui/home/enamel_navigation.png` matches the existing enamel reward objects:
shop/home/museum/case file in a transparent 2×2 atlas. `home_art.gd` preserves
source ratio/alpha and maps each semantic ID. Prompt: adjacent `GENERATION.md`.

`home_navigation.gd` replaces the historical baked footer with generated icons,
native labels and one teal selected tile/underline. Existing tab IDs, hit areas
and destinations remain. Case File uses the dossier art. The duplicate bronze
reward shortcut is removed; Daily, Milestones and Star Chest still open the
reward overview, preserving focus restoration and claim rules. The progress
card expands into the freed space.

`heist_start_button.gd` is a native 544×108 turquoise enamel action, with a thin
brass rim, soft depth, live Lora caption, clear hover/press/focus and disabled
styles. With no authored next heist it reads More Soon and is disabled; Museum
replay is unaffected. No save changes or new purchase/ad integration.

Validation pending: isolated lobby, screen-refresh and Case File checks plus
standard/tall GPU captures, including the exhausted-content state.
Next phase remains P16; real-device safe-area/touch acceptance remains P16-29.
