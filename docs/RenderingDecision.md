# P03 rendering and art-system decision

This is the presentation foundation for P05 and P07, not a replacement of the
playable demo or a mobile release sign-off. The isolated Godot scene is
`scenes/prototypes/visual_lab.tscn`. It never loads a save, grants ownership,
opens a provider, or charges the boost budget.

## Selected implementation direction

Use **real-time 3D for the board pieces, scouts and carrier drones**, with a
near-top-down fixed camera and the existing deterministic 2D puzzle as the sole
rules authority. Use a **true perspective 3D room** for the Night Museum and
native Godot Control nodes for localized interface/modal text. Reuse the original
procedural enamel meshes for the entrance diorama and celebrations.

The comparison uses the same 616-cell Level 3 Magpie artwork, its authored
palette and bottom-only routes, five carrier positions, and one reserved scout
pickup/delivery. One implementation draws extruded polygons and layered vector
drones; the other uses beveled meshes and rounded bodies. The state-equivalence
test compares complete snapshots before pickup and after delivery. Neither
renderer chooses cells, changes routes or owns reservations.

The measured vector 2.5D implementation costs more draw calls than this 3D
prototype. The result favors 3D here, alongside reusable models, coherent light
and convincing lift depth. It is **not** a claim that 3D always outperforms an
optimized sprite atlas: the compared 2.5D candidate is procedural vector art,
not a pre-rendered/batched atlas. Pre-rendered 2.5D remains the contingency if
real-device measurements require it. Do not silently replace depth with flat
rectangles.

## Cost and acceptance methodology

`capture_visual_foundation.gd` warms each view for ten frames, then records 45
samples of forced redraw plus CPU/GPU synchronization, objects and draw calls.
The wall interval is not isolated GPU time, an end-to-end frame time, or an FPS
claim. The capture uses a 504 × 840 desktop window with a 720 × 1200 logical
canvas; the 3D subviewport has its own logical resolution. Source manifests,
engine/host information, medians and p95 values are retained alongside images.
The current measurements are in the [P03 implementation report](P03-Implementation.md).

The planning target for P05/P07 is a 60 Hz frame budget (16.67 ms total), with
30 Hz fallback assessed on the lowest supported device in P13. The desktop
redraw comparison is an early gate only: it excludes mobile thermal load,
battery, driver differences, complete UI/input logic and future content density.
Do not mark P13 performance complete from these numbers.

| Candidate | Production implications |
| --- | --- |
| Procedural 2.5D | Predictable authored colors and hit rectangles; side faces, shadows, attached pixels, rotor folding and angles require separate drawing logic. Many individual vector commands here. A sprite atlas would need rendering, packing, variant management and a separate memory comparison. |
| Real-time 3D | One reusable original mesh/material vocabulary for tiles, folded/open crew, lift and props. Adds light/camera tuning and geometry/overdraw cost. Fixed projection and neutral top faces must retain authored color readability. |
| Perspective room | Five thick frames, real floor/wall junctions, warm spotlights, depth-bearing elevator doors and controlled camera travel. Low quality disables shadow/MSAA cost while retaining meshes and camera perspective. |

P05 should batch repeated tiles (for example, MultiMesh groups), share meshes
and materials, restrict simultaneous scouts to the existing rules, and profile
again. Do not infer a performance win before measuring that implementation.
P07 must add persisted floor/focus/exhibit navigation and complete elevator
transitions to the separate spatial prototype.

## Shared art system

`data/design_tokens.json` records the palette, typography, spacing, radii,
material roughness, light direction, motion durations and five button states.
The prototype uses these conventions; extracting production components is P05.

- Ink and warm paper organize information; cobalt marks night architecture,
  cyan the signature drone, coral the partner, and gold primary actions/frames.
  These accents never recolor the puzzle's matching palette.
- Tiles have a distinct top, bevel and darker side; removing a tile exposes its
  tray. Enamel drone bodies have shallow height, four rotor pods, a dark visor
  and two cyan lights. Large payload numbers remain on a stable top face.
  All geometry and motifs are original; no licensed toy characters are used.
- Use a warm upper-left key, restrained cool fill, broad material highlights
  and grounding shadows. Fix inward mesh normals before tuning light. Neutral
  museum mats protect artwork color. No head bob or mandatory camera shake.
- Display/title/heading/body/caption start at 76/38/28/23/17 logical pixels.
  Locale fitting uses the allocated rectangle, with scrolling for long facts.
  Paper buttons have a colored bottom edge and shadow; hover brightens, press
  lowers the edge, focus outlines, and disabled reduces emphasis.
- The dossier modal has a cream surface, cobalt dimensional edge, public
  speaker heading, concise story text, artwork title and persistent actions.
  It settles over 210 ms; reduced motion shows the final pose immediately.
  Production variants, focus restoration, input trapping and sound remain P05.

## Prototype controls and motion study

Open the standalone scene in the editor and run the current scene (F6).
F1–F5 select entrance, heist, museum, dossier and success. Tab toggles board
2.5D/3D; R toggles reduced motion; Q toggles low quality. On-screen buttons move
between views. Museum arrows move along the five-frame corridor; Inspect
approaches/returns, while the same action near an elevator approaches its
opening doors. Escape returns home. These are prototype controls, not new demo
navigation or saved progress.

The 16-second, 12-fps study includes idle hover, a real logical scout pickup and
delivery, corridor movement, artwork approach/return, an elevator approach,
modal entry and a two-drone celebration. Reduced-motion and low-quality stills
retain depth. It is a visual study without a new soundtrack; existing ASMR and
ambience behavior remain in the unchanged playable demo. Prototype completion
shows no unearned payment, profile score or canonical campaign ending.

Generate the comparison and encoded MP4 in an isolated run:

```sh
python3 tools/validate_project.py --prototype --suite test_visual_foundation
```

FFmpeg is needed to encode the captured frames. The runner fails that evidence
step if it is unavailable; it does not claim a motion clip from stills alone.
The harness uses main-thread `RenderingServer.force_draw(false)` after layout,
so scene replacement does not occur inside a renderer's post-draw callback.
See the [Godot RenderingServer API](https://docs.godotengine.org/en/stable/classes/class_renderingserver.html#class-renderingserver-method-force-draw).
