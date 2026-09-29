# Collection layout and Museum control refinement — P16-54

27 September 2026. Implements the owner’s Collection layout and button feedback.

S5 and P7 share `museum_controls.gd`: bundled Lora type, brass borders,
navy/turquoise enamel, inner highlight, depth and keyboard focus. Top tabs leave
clear space between captions and their turquoise selection underline. Collection
moves Edit, Photo and view controls to a shelf above the shared footer.

Three saved layout IDs (`spotlight`, `pairs`, `salon`) drive the same room renderer
in browsing, editing and PNG exports. Spotlight has a large first painting and
pairs below. Live rooms scroll instead of shrinking ten paintings. Editing uses
numbered painting targets: select then tap another to swap, or use earlier,
later and first-position actions. Remove is explicit; the owned-art library below
the room provides additions. Theme cycles among the existing three colors.

The optional layout field preserves old save validation. Reading a room without
that field preserves the former visible featured-first order on a copy; editing
commits stable IDs and the chosen layout atomically. Ownership, campaign progress,
wallet and energy are unaffected. New explicit order is never overridden by a
hidden featured-first render sort. Failed writes retain the committed arrangement.

P16-54 is complete for desktop. Validation evidence:
`artifacts/validation/museum-collection-layout-final-20260927/`.

- Clean import and main scene passed on Godot 4.7.1.
- 648 checks passed: 223 Museum/layout/save checks, 72 store checks and 353 flow
  checks. Cases cover layout reload, legacy featured-first adoption, tap-to-swap,
  earlier/later/first moves, removal/addition, immediate title updates, failed
  writes and unchanged ownership/wallet/energy. Artwork bounds are checked for
  all three layouts, 1–10 works, live room and both export sizes.
- 28 GPU captures/PNG exports passed; reviewed 720×1280 and 390×844 views,
  selected editing, pairs/salon layouts, the scrolled library, original/pixel
  detail, clean exports and tab/footer spacing. Final runtime source hashes match
  the validation copy. Exports center short rows to avoid scattering small works.
- English/Turkish designs and task states are aligned; planning, localization and
  chapter validation passed. All runtime runs used isolated profiles and saves.

The first sandboxed import could not create its unique Godot test profile;
the authorized validation reruns completed normally. No player save was used.
Device safe-area/touch acceptance remains P16-29; next phase is still P16.
No real sharing adapter is added.

[Collection preview](../artifacts/validation/museum-collection-layout-final-20260927/museum-collection.png)
· [Editing on a tall viewport](../artifacts/validation/museum-collection-layout-final-20260927/museum-tall-edit.png)
· [Painting Detail](../artifacts/validation/museum-collection-layout-final-20260927/museum-detail.png)

