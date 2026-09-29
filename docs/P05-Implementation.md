# P05 — heist-to-museum flow

20 September 2026. Completed: **P05-01 through P05-12**. Next: **P06**.

## Delivered

| Tasks | Implementation and boundary |
| --- | --- |
| P05-01 | Twenty editable `scenes/flow/s01.tscn`–`s20.tscn` shells, screen registry/router, Back rules, reusable reading/actions regions and loading/empty/error states. Existing selection/heist/museum controllers remain active. Future screens remain shells, with the full ending gated. |
| P05-02 | Final delivery commits before success. First story jobs atomically record a provisional 120-credit fee, pending inspection/frame context and one optional notification. One primary Continue action; no automatically stacked notifications. Replays cannot duplicate payment or overwrite an unresolved decision. |
| P05-03 | Original reusable 3D night-service van and city-seeded skyline, cosmetic tint hook, immediate Skip, two input-paced bubbles and reduced-motion still. Menus/return/inspection consume no boost. |
| P05-04 | Fast 1.6-second reconstruction and fixed none/related/inconsistent/fragment outcomes in `data/post_heist.json`. Workshop Swatches archives its side record; Moon Gate Mask records the device-delivery discrepancy; Water Lilies remains the fixed first main-fragment carrier. Other works do not invent a clue. |
| P05-05 | Eligible keep, two fictional buyer offers, verified fictional return/loan recipients, one consequence confirmation, cancellation, explicit storage and re-exhibition. Evidence survives every disposition. Legacy inspections upgrade through a separate idempotent transaction. Pending inspection and case finale resume on cold launch. |
| P05-06 | Immediate first-job/Continue entrance, returning recap, preserved onboarding and blocked/pause guidance, persistent language/audio/motion settings, modal focus cycling/restoration and scrollable long decisions. |
| P05-07/08/09 | Production orthographic 3D board: beveled instanced blocks, recessed tray and contact shadows. Volumetric scouts/carriers, rotor pods, first-launch unfolding, folded queues/waiting, magnetic lift payloads and zero-capacity rise/side exit. Existing 2D geometry, targeting and flight timing stay authoritative. |
| P05-10 | Original night-heist diorama, extruded PIXEL HEIST lettering and signature drone. Input is immediately available; normal and reduced-motion versions share layout. |
| P05-11 | Shared raised cobalt modal family, original inventory seals, tactile/focus states and editable `modal_card.tscn` with a reusable long-content region. Briefing/settings/disposition use the family in play; news/purchase reading variants are captured as component fixtures, with their actual content/providers reserved for P07/P09. Inspection/success share the palette, buttons and dimensional art stages. |
| P05-12 | Committed last delivery → artwork reveal → drone/badge/confetti → recorded fee. Continue can skip the sequence; reduced motion is static and existing completion audio respects sound settings. Case recap lists actual choices/ownership and deferred targets. S18 renders the player's actual exhibited originals/memories and empty frames; its full-campaign route remains locked until P12. |

New code/data: `post_heist_service.gd`, `screen_router.gd`, `flow_screen.gd`,
`depth_heist.gd`, `story_stage.gd`, `game_theme.gd`, `modal_card.gd`,
`data/post_heist.json`, `data/screens.json` and editable flow scenes. Save changes
are optional schema-1 fields; the existing migration and atomic file format
remain compatible. Main coordinates scenes and decisions; rendering callbacks
cannot grant rewards or remove logical pixels.

The catalog has **534 keys in en/tr/es/de**. Complete strings and automatic
layout checks are included; independent native-speaker editorial review remains
P11/P13. There are still **17 puzzle definitions and one authored story case**.
This phase does not complete the other 19 cases or the base-game ending.

## Validation

Integrated gate: **`artifacts/validation/p05-final/`**, clean import/startup,
**19 suites / 27,229 checks / zero failures**, **167 captures** (nine baseline,
41 localization, 39 campaign, 78 flow) and a **10.5-second motion clip**.
The final logo refinement is separately checked in
**`artifacts/validation/p05-presentation-final/`** with the affected presentation,
post-heist and depth suites, all 78 flow captures and re-encoded motion.
Both runs preserve source manifests and logs.

- `test_post_heist`: 198 checks covering all four fixed outcomes, invented-clue
  rejection, repeat/legacy inspection, all disposition kinds, cancelled
  confirmation, storage/re-exhibition, replay fee protection, unresolved-decision
  protection, cold inspection/finale resume, twenty editable shells and seven
  shared modal roles. Nine actual child-process kills exercise completion,
  authored inspection and sale at flush, primary replacement and backup stages;
  recovery/retry grants payment exactly once and retains evidence.
- `test_depth_heist`: 57 checks for projection onto actual native hit areas,
  presentation-only state, folded waiting, real scout pickup, magnetic payload,
  visible zero and rise-before-side departure. The real-renderer capture suite
  additionally compares every MultiMesh transform against logical tile removal;
  the headless Dummy renderer cannot return meaningful GPU transforms.
- Existing suites retain all 15 original solutions, 1×/3× behavior, shared docks,
  bottom-only Level 3, sealed-color waiting, undo, own-carrier routes, pickup
  timing, audio, 600-second boost, migration, interrupted flights and saves.
  The first case still passes all 360 ordered four-of-six choices. Its actual
  controller flow now exercises return/inspection/keep/store as well.
- Flow captures cover every locale, empty storage, all four inspection outcomes,
  long decisions/top-bottom scroll, confirmation, settings, archive, case recap,
  personal-exhibition presentation, normal/reduced entrance, future modal-family
  component fixtures, pseudo-expanded German, three/five docks, pickup, success
  and loading/empty/error states. Motion includes van return, reconstruction,
  real scout flight and success choreography.

```sh
python3 tools/validate_project.py --output artifacts/validation/p05-final --visual --flow --timeout 120
python3 tools/validate_project.py --output artifacts/validation/p05-presentation-final --suite test_post_heist --suite test_depth_heist --suite test_visual_foundation --flow --timeout 120
python3 tools/build_localization.py --check
python3 tools/validate_campaign_data.py
python3 tools/validate_planning_docs.py
```

Host: macOS 26.6.2 arm64 / Apple M5, Godot
`4.7.1.stable.official.a13da4feb`, GL Compatibility. The ambience suite uses
CoreAudio; capture audio is disabled. Every run uses a clean temporary project,
unique application identity and isolated save paths. The player's
`user://progress.cfg` is neither opened nor reset by these tests.

The pre-edit backup is `.backups/pre-p05-20260920-201656.tar.gz` with **1,255**
source/evidence hashes in its adjacent JSON manifest. Against it, original
`puzzle_state.gd`, `drone_routes.gd`, `levels.json`, `artwork_details.json` and
`locations.json` are byte-identical. P05 source changes after the integrated run
were limited to the entrance logo, covered by the final presentation run;
final report/checklist changes are documentation only.

## Visual review and iteration

The early render exposed a width-locked orthographic camera that misplaced
3D actors relative to their buttons, inverted capacity text and overbright
materials. Height-locked projection, upright numbers and restrained lighting
fixed them. Inspection of the entrance exposed clipped lettering; an extruded
TextMesh replaces it. Normal/reduced, long German confirmation, Turkish return,
reconstruction, three/five docks and personal exhibition were visually sampled.

Failed runs remain preserved. Initial parsing issues were fixed before runtime
acceptance. An early depth test wrongly read transforms from the headless Dummy
renderer; that check now runs on the real GPU. Another fixture assumed a shared
dock always had index zero, causing a timeout; it now checks the actual occupied
docks. Shell setup now clears old actions and avoids duplicate connections.
Only the successful final runs count as acceptance.

## Remaining limits and handoff

**P06 is next:** balance the provisional 120-credit fee and fictional offers,
author independent wealth/renown/insight/curation grants, first-event/rank tuning,
labels, pinned memories and earned-credit decoration economy. Two buyers record
different destinations/offers now; reputation effects and full trade-off tuning
remain P06. No fictional sale estimate is awarded merely for completion.

P07 owns the ten-floor perspective museum, full placement/exhibition controls,
loan scheduling, richer case file and authored news. The current story projection
still has four floors. P09 owns actual purchase/ad UI and verified test providers;
P10 owns sharing. News/purchase screenshots are reusable component fixtures, not
working commerce or published articles. S18 is a save-driven presentation, not
an authored/unlocked base-campaign ending; P11/P12 supply remaining story content.

`p05-render-metrics.json` reports desktop renderer counters: the five-dock sample
has 616 tiles in six tile batches, but crew/environment still contribute many
draw calls. These are not phone FPS, thermal or memory acceptance. P08 observed
playtests and P13 device/performance, touch safe-area, accessibility and lifecycle
gates remain open. No deployment, distribution, external message, real purchase
or live provider integration occurred.

Planning revision **r9**: **117 task IDs, 47 complete, 70 pending**, with identical
English/Turkish task IDs and states.
