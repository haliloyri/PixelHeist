# Museum navigation — P16-49 (27 September 2026)

The S5 upper and lower navigation follows the approved Safehouse footer, with
navy enamel, brass edges/separators, gold captions and a turquoise selected
underline. Footer glyphs reuse the existing reference atlas at render time;
the Home screen and source image are unchanged. The Museum remains selected
across its Floors, Collection and Crew views. Photo mode remains HUD-free.

The right-hand elevator button replaces both arrows and the OS PopupMenu.
Its in-screen directory lists all ten named floors and live collected counts.
The selected floor has a teal outline and check, receives keyboard focus, and
scrolls into view. Selection resets the exhibition scroll and dismisses the
list. Outside tap, close and Escape dismiss it with focus returned to the
trigger. Keyboard traversal remains inside the directory. All floors remain
browsable without granting ownership, playable content or rewards.

Files: `scripts/ui/gallery_screen.gd`, `museum_navigation.gd`,
`museum_icon.gd`, `navigation_glyph.gdshader`; museum tests/captures and the
validator's capture count; synchronized English/Turkish design and checklists.
The existing collection room/editor were adjusted to clear the taller menus.
No persistence schema, gameplay rules, source image or home controls changed.

Validation: final clean import/main scene, 109 museum checks, 353 flow checks,
and 20 GPU captures/PNG exports passed with isolated application IDs and saves.
Evidence: `artifacts/validation/museum-home-navigation-final-20260927/`.
Standard 720×1280 and tall 390×844 museum/list captures, collection and editor
were visually inspected. Final runtime source hashes match the tested files.
The first sandboxed run could not create its isolated Godot profile; the
approved validator run used a separate disposable profile and cleaned it up.

The final runner's planning step caught a concurrent P16-48 assignment for the
separate detail-replay task. That task was preserved and this work assigned
P16-49 in both checklists. The original runner summary retains that failure;
`planning-final.log` and `acceptance.json` record the corrected planning check
alongside the successful runtime evidence. No runtime rerun is needed for that
document-only correction.

P16-49 is complete for desktop. Next work remains P16; real-device acceptance
stays P16-29 and remaining playable content P16-30. No externally dependent
release task is claimed complete.
