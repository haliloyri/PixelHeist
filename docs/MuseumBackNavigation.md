# Museum back navigation — P16-55

27 September 2026. The owner approved replacing the Museum footer with a
single upper-left back arrow while retaining Floors / Collection / Crew.

`gallery_screen.gd` removes the footer and its three hit targets from every tab.
The new brass/enamel arrow shares the title row without overlapping the title.
Floors and Collection gain 146 design units of scroll height; Collection/Edit
controls move down by the same amount and retain a 28-unit bottom inset.
The Safehouse footer remains unchanged.

Back from Edit first commits the room name and returns to Collection; a second
back returns to Safehouse. Photo back returns to the prior Museum view. Escape
uses the same behavior through `main.gd`; existing modal and floor-directory
dismissal takes precedence. Ownership, collection arrangement and economy remain
unchanged. The existing immediate collection saves remain the persistence model.

P16-55 is complete for desktop. Evidence:
`artifacts/validation/museum-back-navigation-20260927/`.

- Clean Godot 4.7.1 import and startup passed; 237 Museum checks and 353 flow
  checks passed (590 total), using isolated saves and a unique test profile.
- Tests cover all three tabs returning to Safehouse, Edit exiting first, saving
  the pending room name, Photo back, Escape and modal priority, geometry and
  preserved ownership, collection order, gold and energy.
- 28 GPU captures/PNG exports passed. Floors, Collection and Edit were reviewed
  at 720×1280 and 390×844, with a clear header/back target and the reclaimed
  scroll space. The Safehouse screenshot and all three exported PNGs are byte
  identical to the preceding P16-54 capture set.
- Runtime source hashes match the validated copy. English/Turkish design and
  checklist updates, planning validation, localization and chapter checks passed.

Next phase remains P16; real-device safe-area and touch acceptance remains
P16-29. No new screen or platform integration is introduced.

[Collection](../artifacts/validation/museum-back-navigation-20260927/museum-collection.png)
· [Tall editor](../artifacts/validation/museum-back-navigation-20260927/museum-tall-edit.png)

