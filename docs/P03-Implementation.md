# P03 — four-language and visual foundation

20 September 2026. Completed: **P03-01 through P03-09**. Next: **P04**.

## Delivered

- **P03-01/02:** 352 stable English source keys, three complete locale JSON
  catalogs and generated en/tr/es/de gettext PO files, including contexts and
  plural forms. The existing 15-work demo now switches language in settings,
  follows supported device languages, falls back to English and persists manual
  preference without changing acquisition identities or replacing other settings.
- **P03-03/04:** canonical cast IDs and public speaker labels; the anonymous
  client does not expose Evelyn's identity. Artist/place identities remain.
  Named placeholders, locale number formatting and gettext plurals are used;
  language selection has no commerce-country, price or reward effect.
- **P03-05/06:** glyph/casing, catalog/key/context/placeholder/cast checks,
  four-language screen captures and expanded German captures. Text fitting now
  measures intended bounds rather than a Label's auto-expanded rectangle.
  Long inspection facts scroll. [Localization.md](Localization.md) defines
  authoring, public/hidden identity, shared terminology and future storefront rules.
- **P03-07:** the designer-toy palette, materials, typography, spacing, light,
  motion and five button states are recorded in `data/design_tokens.json` and
  [RenderingDecision.md](RenderingDecision.md), with original procedural forms.
- **P03-08/09:** an isolated interactive visual lab compares procedural 2.5D
  and real-time 3D on the same 616-cell, five-carrier, bottom-entry puzzle.
  It also provides a five-frame perspective museum with two elevator recesses,
  corridor/approach/return camera movement and opening doors. Entrance, heist,
  museum, dossier and success studies, quality/motion variants and a 16-second
  motion clip establish **3D board/crew and perspective museum** for P05/P07.

The playable demo retains its original visual flow apart from localization and
fitting. The new art direction is a separate prototype, not completed P05/P07
integration, a 20-level campaign, or a new store/payment implementation.
The prototype uses its own PuzzleState and never reads a player save/provider.

## Validation and visual evidence

Full gate: `artifacts/validation/p03-final/` — clean import/startup, **15 suites,
16,926 checks, zero failures**, nine baseline captures, 41 locale/layout captures,
nine prototype captures and an encoded motion study. The 13 pre-existing suites
still pass 15,447 checks; localization adds 1,462 and the initial visual foundation
suite adds 17. Flow tests solve all 15 works at 1× and 3× identically.

Final prototype-only refinement: `artifacts/validation/p03-presentation-final/`
— **19 visual foundation checks**, nine refreshed stills, comparison JSON and
`p03-motion.mp4` (192 frames, 12 fps, 16 seconds). This adds display assertions
for delivered capacity/progress, a visibly opening reduced-motion elevator,
and records the selected 3D pickup instead of the 2.5D candidate. No playable
runtime code changed after the full gate. This focused run validates the final
prototype source; planning/report-only edits follow its source manifest.

```sh
python3 tools/validate_project.py --output artifacts/validation/p03-final --visual --prototype
python3 tools/validate_project.py --output artifacts/validation/p03-presentation-final --suite test_visual_foundation --prototype
python3 tools/build_localization.py --check
python3 tools/validate_planning_docs.py
```

Host: macOS 26.6.2 arm64, Apple M5, Godot
`4.7.1.stable.official.a13da4feb`, GL Compatibility and CoreAudio for the audio
suite. Every run uses the validator's temporary copy, unique application
identity and isolated saves. Player `user://progress.cfg` was not opened or reset.
A pre-edit archive and per-file hashes remain at
`.backups/pre-p03-20260920-114328.tar.gz` and `.json`.

The final images were visually checked for long German titles, Spanish text,
Turkish glyphs, pseudo-expanded home/briefing/settings/inspection, dimensional
meshes, distinct artwork textures, five capacities, modal hierarchy, perspective
and reduced-quality depth. Sampled MP4 frames show the lifted pixel, the 6→5
carrier capacity after delivery, 1/616 progress, camera approach and elevator
opening. The still images and motion demonstrate prototype direction, not
final phone readability, editorial translation quality or campaign art approval.

| Final prototype measurement | Median redraw + sync | p95 | Draw calls |
| --- | ---: | ---: | ---: |
| Procedural vector 2.5D board/crew | 9.571 ms | 10.276 ms | 2,642 |
| Real-time 3D board/crew | 6.132 ms | 8.794 ms | 1,489 |
| Perspective museum | 5.544 ms | 7.791 ms | 260 |
| Museum, low quality/reduced motion | 2.759 ms | 4.657 ms | 51 |

Each row has 45 samples after warm-up. These are forced redraw plus CPU/GPU sync
intervals, **not FPS or isolated GPU timings**. The low-quality room changes the
camera view as well as quality; its draw-call reduction includes culling and is
not attributed solely to shadows. Both board candidates use the same authored
state, but different rendering/projection paths. An optimized sprite atlas was
not implemented or measured. See the decision document for production trade-offs.

Against the pre-P03 archive, `scripts/core/puzzle_state.gd` and
`scripts/core/drone_routes.gd` are byte-identical. Level JSON changes are limited
to text keys and speaker identity/display metadata; cells, palettes, queues,
solutions, dock count and entry mode are unchanged. The 600-second independent
boost budget and P02 persistence/kill-recovery suites still pass.

## Iteration history retained honestly

- `p03-i18n-first` and `p03-layout` passed initial functional/capture checks;
  visual review still found pseudo brackets missing glyphs and two long titles
  exceeding their allocated boxes. ASCII brackets, intended-bounds fitting and
  a stronger capture audit fixed these; `p03-layout-trace` passed all 41 captures.
- `p03-layout-fixed`, `p03-prototype-parse-fixed` and `p03-visual-redraw` retain
  failed/timed-out captures. Waiting on the post-draw signal while replacing
  scenes was not reliable in these runs. The harness now advances layout and
  forces drawing on the main thread, outside that callback; `p03-capture-sync`
  and both final runs pass without the stall.
- `p03-prototype-first` retains two GDScript type-inference failures. The invalid
  capture process was explicitly stopped, its errors retained and temporary
  data cleaned. Explicit float types fixed the parser errors.
- Visual review found inward-facing beveled-mesh triangles and shared artwork
  material reuse. Correct winding/outward-normal checks and per-art texture
  material copies fixed them before the final gate. The last focused pass fixes
  the prototype's stale capacity/progress labels and near-door reduced pose.

No failed run is counted as acceptance evidence. Planning documents are aligned
at **r7: 117 matching task IDs, 28 complete / 89 pending**.

## Remaining risks and handoff

P04 implements target trade-offs and campaign selection. Use stable content
identities and keep Offer, Recognition, Research and collection fit independent.
The four profile IDs remain wealth/renown/insight/curation; there is no total
artwork score or universal best card.

P05/P07 must integrate and optimize the chosen presentation, add production
modal focus/input behavior, carrier lifecycle, full museum/elevator state and
appropriate sound. P08 remains the visual acceptance gate before bulk content.
P11/P13 still require native-speaker editorial review, new-content translations,
safe-area/accessibility work and real-device performance/lifecycle evidence.
The prototype is not an implemented campaign ending or a mobile release.
No deployment, publication, external message or real purchase occurred.
