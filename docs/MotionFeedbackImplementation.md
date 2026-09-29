# Walking and Row Beam feedback — 27 September 2026 (P16-34)

## Changes

- Replaced wall-clock leg sway with an articulated tripod gait. Each ant records
  actual traveled route distance in `walk_distance`; phases advance with that
  distance at both 1× and 2×. Gate waits, pickup dwell, pause and app suspension
  hold the feet still. Reduced motion uses a fixed stance. Old checkpoints omit
  the optional distance field safely; new ones retain it.
- Each Row Beam removal snapshots its source cell/color and a box target before
  the single logical transaction. The row flashes, pixels depart in a staggered
  curved stream, then shrink/fade with matching trails and small fragments.
  Particles disappear en route, so the effect does not imply another delivery.
- Actual board/capacity/stock changes remain immediate and atomic. Cosmetic
  particles are neither saved nor counted as scouts; resuming cannot re-charge,
  re-collect or replay a reward. The final row's visible effect finishes before
  the normal completion screen. Pause/suspension freezes its age, and reduced
  motion uses a short in-place dissolve. New heists clear old particles.
- Beam duration stays fixed (~1.3–1.6 seconds including stagger). Existing 2×
  semantics affect ants only. Positions resolve from current board/box geometry,
  so the transfer continues toward the boxes after a viewport resize.

## Verification

All eight gameplay suites passed (8,038 assertions) alongside import, main-scene,
planning, localization and chapter checks in
`artifacts/validation/motion-feedback-final/summary.json`.
The final focused rerun passed all 24 motion assertions and a 156-frame real GPU
capture in `artifacts/validation/motion-preview-verified/summary.json`.
Frames 114 and 126 were inspected: the full row leaves the painting, follows the
active boxes, and shrinks/disintegrates in the corridor. The 6.5-second preview
is `artifacts/validation/motion-preview-verified/walking-and-row-beam.mp4`.
The deterministic capture forces offscreen draws and clears its fixture's
focus-suspension flag; production pause/focus behavior is unchanged.
`tests/test_motion_feedback.gd` covers speed ratio, measured distance, planted
foot displacement, stopped gait, effect creation/movement/fade, stock and pixel
conservation, pause/suspend, reduced motion, final-row delay and single reward.
`tests/capture_motion_feedback.gd` captures real 1× walking, 2× walking and a Row
Beam action for an MP4 preview; it uses an isolated fixture, not a player save.

## Preservation / remaining work

Source backup: `.backups/pre-motion-20260927-135010.tgz`.
No content budgets, artwork palettes, prices, save identity, purchases or real
player progress are changed. P16-29 real iOS/Android device acceptance remains
open; P16-30 artwork/content work is independent.
The concurrently added heist intro is outside this change; the final focused
rerun uses the shared fixture's explicit intro skip.
