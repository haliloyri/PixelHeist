# Heist feedback — 27 September 2026 (P16-33)

This supersedes the conflicting visual details of P16-32. References: approved
`artifacts/design/gameplay-redesign/pixel-heist-gameplay-v4.png` versus the user's
1108×2064 runtime screenshot attached on 27 September.

## What changed

- The runtime had fine outlined numerals, lighter heading/title weights, mixed
  progress/speed typography, side-view copper ants and open platform rotors.
  Typography now uses a real static Lora Bold 700 font with correct family/style
  metadata, larger ivory numerals and dark outline. Queue Buttons no longer draw
  an invisible native number whose outline overlapped the sprite's number.
- Existing `assets/ants/ant_05_blue.png` supplies the top-down robot body. Enamel is
  recolored at runtime to its carrier palette, retaining shading. Six articulated
  alternating feet walk along the existing ground routes. No elevation bob,
  wings or enlarged floating shadow. Return payloads keep their actual pixel size.
- No clickable-carrier halo/focus frame. Working hatches glow in the carrier color;
  idle doors stay dark. Rotors remain folded until actual departure, then unfold.
  The face count excludes already picked pixels. When it vanishes, the same
  top-down ant replaces it, including during departure.
- New campaign queues are authored separately in `data/large_packet_queues.json`
  by deterministic `tools/build_large_queues.py`. Real-color packets are 20–45;
  exact remainders stay >=20 when the color total permits it. A color with <20
  pixels uses its actual total. Active counts descend as pixels are stolen.
- Original levels/IDs remain intact. Catalog retains each known legacy fingerprint.
  Resume attempts solver-verified repacking of unlaunched capacity only; never
  changes board pixels, reservations, active carriers, wallet or earned progress.
  A blocked planner leaves the old queue alone; `queue_version` prevents repeated
  migration. Existing dock counts and extra docks remain intact.

## Verification

`heist-feedback-second`: import, main scene, existing v4/booster/flow tests and six
GPU captures passed. `heist-feedback-capacities`: 684 of 685 feedback assertions
passed; all 15 capacity/solution/migration checks and real-flight Venus completion
passed. The remaining assertion identified incorrect font style metadata (weight
700 outlines but Regular face name/flags); metadata has been corrected.

Final evidence: `artifacts/validation/heist-feedback-final/summary.json` records
all steps passed: planning/localization/chapters, Godot import/main scene, seven
suites with 8,014 assertions, and four real GPU captures. The final feedback suite
has 685 passing checks, including true Bold weight metadata, all 15 large-packet
solutions/capacity budgets, idempotent legacy conversion with a picked reservation,
real-flight Venus completion, folded platform rotors, color-matched top-down
sprites and picked-pixel face counters.

Images inspected: `feedback-ready.png`, `feedback-walking.png`,
`feedback-takeoff.png`, `feedback-tall.png`. Take-off capture shows a genuinely
finished carrier, its top-down ant emblem and newly unfolding rotors. The before
image is preserved at `artifacts/design/gameplay-redesign/runtime-before-feedback.png`.
P16-33 is complete for desktop scope; next acceptance remains P16-29 on devices.
P16-30 remaining campaign content is unchanged.

## Preservation and limits

Backup: `.backups/pre-heist-feedback-20260927-133030.tgz`.
Tests run only in isolated copied projects with temporary save fixtures. No real
purchase, publishing or player-save reset. Lora remains SIL OFL licensed; the
static instance derives from the existing variable font using fontTools.

Low-count exceptions are required by the user's “do not exceed remaining pixels”
constraint. Completed/partially used active boxes can also show <20. Larger packets
change difficulty; iOS/Android feel and performance testing remains P16-29.
