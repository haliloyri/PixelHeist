# Museum Artwork Detail replay — P16-48

27 September 2026. An owned artwork with an authored heist board now shows a visible **Play again** button below the existing collection controls in P7 Artwork Detail. Pressing it starts a fresh S2 heist using that detail's stable artwork ID. Starting a heist does not spend energy; the existing replay win reward and failure/quit energy rules apply. If energy is empty, P3 Out of Energy opens and the gallery and saved heist state remain intact. Locked previews and works without a playable board have no replay action. The existing original/pixel switch and collection controls are unchanged. The label reuses the English `ui.replay` source string.

An isolated clean Godot validation passed the stage-museum suite (105 checks), r13 flow (353 checks), clean import/startup and 18 GPU museum captures with zero failures. A final direct isolated-save rerun of the stage-museum suite passed 109 checks after selecting a non-first artwork for the replay assertion. The tests cover button visibility, energy gating, fresh board state, selected art ID, preserved ownership and no energy charge on entry. The 720×1280 and 390×844 Artwork Detail captures were visually inspected; the button fits inside the existing modal. Evidence: `artifacts/validation/museum-replay/`. A pre-change backup is in `.backups/pre-museum-replay-20260927.tgz`.

The interactive fixture `tests/playtest_sun_seal.gd -- --museum-replay` opens the owned Sun Seal detail with an isolated save so the button can be tried without touching `user://progress.cfg`.

P16 remains open. Native-device acceptance remains P16-29; the 85 unproduced heists remain P16-30.
