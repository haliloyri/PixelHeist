# Simplified Safehouse — P16-63

29 September 2026 · Design revision 2026-09-25-r13.

Halil approved the generated simplified background and requested its application.
The exact approved image is copied to `assets/lobby/v2/museum_simple.png`; S1
loads it through the existing `SCENE` constant in `scripts/ui/lobby.gd`.
The previous `museum_crew.png` is retained. No changes to controls, navigation,
rewards, save identities, economy or other screens.

The artwork was generated with built-in imagegen in this chat: quiet navy
museum side areas, one central framed pixel painting, canonical Rocco and
Sprocket, one copper robot bug, smaller top logo and uncluttered lower space.
Original generation output: `exec-e1ffbae2-5c46-4fbd-9ba6-c2b1ce91b7e5.png`.

Validation: `tools/validate_project.py --suite test_lobby_reference --lobby-reference`
passed clean import/startup, 38 isolated lobby checks and seven GPU captures.
Evidence: `artifacts/validation/simplified-safehouse-20260929/`. Standard
720×1280 and tall 390×844 Safehouse captures were visually reviewed: side
buttons read clearly against the quiet walls, central faces and logo remain
visible, and the lower controls fit. Planning-document validation also passes.
The approved PNG was copied byte-for-byte (941×1672), SHA-256
`2e13e02ea28d362f1cbc927d9fe41811e1ca9dc74ac059a919e87f20af785d5f`.
The isolated validation user directory was cleaned; player saves were untouched.
Next phase remains P16. Real-device safe-area/touch acceptance remains P16-29.
