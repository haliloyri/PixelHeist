# P08 — playable vertical slice and design validation

23 September 2026. Planning revision r12. **P08 is in progress.** P08-02,
P08-03, P08-05, P08-07 and P08-08 are complete. P08-01 still has short story
boards and one-line beats. P08-04 and P08-06 need observed human players and
cannot be completed by automated checks. The user's decisions of 23 September
(doubled base pace, credit refill for 3×, larger story boards, overlap-safe
Level 3) are implemented below; the first measurements are kept as history.

## Evidence summary

| Gate | Evidence | Result |
| --- | --- | --- |
| Full regression | `artifacts/validation/p08-final-a/`, `-b/`, `-c/` (split to fit the shell's process lifetime) | 27 suites / 86,468 checks, 0 failures; Godot 4.7.1, isolated saves |
| Slice flow (P08-02) | `tests/test_slice.gd`, `p08-final-c/slice_metrics.json` | 93 checks: full first case from a fresh story save and from a migrated demo save |
| Tempo/invariance (P08-05, P08-08) | `tests/test_slice_tempo.gd`, `p08-final-b/tempo_metrics.json` | 87 checks over all 17 boards |
| Screen review (P08-03, P08-07) | `p08-captures-flow-2/`, `p08-captures-economy-2/`, `p08-captures-museum/`, review sheets | Four locales plus pseudo-expanded text; three defects fixed |

`p08-slice/` and `p08-slice-tests/` are incomplete runs interrupted when the
shell ended long background processes; they are not evidence. `p08-captures-flow/`
and `p08-captures-economy/` predate the fixes below.

All captures in P08 use Mesa llvmpipe software rendering under Xvfb. They
verify layout, text fit, composition and depth, not GPU frame cost (P13).

## P08-02 — full slice

`test_slice.gd` drives the real controller with durable saves and real flights:
operations → three recommendations → dossier → onboarding → heist → secured
success → return → inspection → disposition/storage → museum, four times, then
the revealed finale → level finale (S17) → operations. It then renders S01,
S13, S14, S15, S16, the museum and operations in en/tr/es/de with no missing keys.

* **Fresh save:** keep, private sale, public sale and store; five job fees only,
  5 news articles, case-file links, path growth (wealth 9,400, renown 168,
  insight 8), finale and two deferred works persisted.
* **Migrated demo save:** a legacy ten-slot save owning six demo works and a
  412.5-second boost balance migrates without inferred story jobs or beats and
  keeps the balance. The same case then completes: demo acquisitions survive,
  a demo-owned original can be sold in story, curation reaches 35 through a
  physical exhibition milestone, and demo mode still opens afterwards.
* Minimum interaction from secured success to the museum: **6 taps** (success,
  skip return, choose future, choice, confirm; store is 4).

## P08-08 — the visual layer preserves the puzzle

For every one of the 17 boards a simulated player follows the authored order
at 1×, automatic 3× and reduced motion. Boost and reduced motion never change
whether the same moves win, the final logical state, one pickup per pixel, or
lengthen a job; no boost is spent at 1×. Queue buttons are 96 design px at
three docks and 90 at five; five carriers never overlap. Hidden/revealed packets
(`test_anticipation`), forbidden-edge and bottom-only routing (`test_bottom_entry`,
`test_columns`) and independent boost records (`test_boost`) pass in the same
gate.

## P08-05 — first measurement (before the decisions)

Simulated player: follows the authored order, acts 2 seconds after each
decision whenever a dock is free, never waits for flights to land. These are
lower bounds without reading, hesitation or mistakes.

| Work | Level | Docks | Pixels | Moves | 1× (min) | Auto-3× (min) | 3× spent (s) | Docks full (s) | Decoy wait (s) | Result |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| `sun_seal` | first_commission | 3 | 101 | 17 | 1.7 | 0.8 | 32 | 49 | 0 | wins |
| `sapphire_cup` | first_commission | 3 | 124 | 19 | 1.9 | 0.8 | 36 | 56 | 0 | wins |
| `girl_with_a_pearl_earring` | first_commission | 3 | 672 | 98 | 8.3 | 3.7 | 162 | 284 | 0 | wins |
| `starry_night` | first_commission | 3 | 884 | 129 | 10.5 | 4.8 | 214 | 354 | 0 | wins |
| `ivory_travel_clock` | first_commission | 3 | 211 | 31 | 2.9 | 1.3 | 58 | 88 | 0 | wins |
| `workshop_swatches` | first_commission | 3 | 225 | 34 | 3.0 | 1.4 | 60 | 98 | 0 | wins |
| `moon_gate_mask` (finale) | first_commission | 3 | 526 | 77 | 6.6 | 3.0 | 133 | 228 | 0 | wins |
| `mona_lisa` | false_owners | 3 | 720 | 147 | 12.4 | 8.2 | 301 | 292 | 138 | wins |
| `the_kiss` | false_owners | 3 | 728 | 152 | 12.3 | 8.3 | 294 | 267 | 150 | wins |
| `the_scream` | false_owners | 3 | 720 | 146 | 12.3 | 7.5 | 282 | 314 | 118 | wins |
| `birth_of_venus` | false_owners | 3 | 748 | 154 | 12.8 | 8.1 | 329 | 329 | 118 | wins |
| `water_lilies` | false_owners | 3 | 704 | 140 | 11.4 | 7.0 | 270 | 281 | 110 | wins |
| `the_gleaners` | lower_threshold | 5 | 616 | 149 | 6.9 | 6.6 | 101 | 48 | 55 | wins |
| `the_magpie` | lower_threshold | 5 | 616 | 140 | 3.9 | 3.7 | 6 | 72 | 30 | blocked |
| `the_star` | lower_threshold | 5 | 624 | 145 | 0.9 | 0.9 | 3 | 3 | 9 | blocked (wins if acting instantly) |
| `dance_at_le_moulin_de_la_galette` | lower_threshold | 5 | 616 | 147 | 9.4 | 8.4 | 95 | 149 | 102 | wins |
| `apples_and_oranges` | lower_threshold | 5 | 616 | 146 | 0.8 | 0.8 | 0 | 12 | 10 | blocked |

A first case (any four selectable works plus the finale) takes **16–31 minutes
at 1×** and **7–14 minutes with automatic 3×**, and spends **319–626 seconds of
3× time**, i.e. 53–104% of the lifetime 600-second budget. Museum travel is
bounded by constants: full corridor ≈4.9 s, elevator 1.5 s (0.36 s reduced).

No core rule, drone speed, boost budget or authored board was changed.
Section 3 of the design asks for full-campaign comfort evidence before any
boost change; these numbers are that evidence for Level 1.

## P08-03 / P08-07 — screen and motion review

Reviewed: 9 baseline states, 10 campaign, 9 locale/layout, 29 post-heist flow,
18 economy, 15 curation/archive and 8 spatial-museum states in each of en, tr,
es and de, plus pseudo-expanded text, the 10.5-second post-heist motion clip
(return, reconstruction, heist, success) and the 9-second museum clip
(corridor, approach, parallax, elevator, second floor). WCAG contrast of every
text token on ink/card/room backgrounds is ≥4.65:1 (coral 4.34:1 is used only
for accents, not text); primary buttons are 10.3:1.

Fixed in this phase:

1. **S16 button text collapsed to 16 px.** Floor, position, storage, memory and
   recall buttons are created inside containers with no size yet, so text
   fitting measured a near-zero width. They now declare their laid-out bounds
   (`scripts/ui/museum_panels.gd`). Verified in all locales and pseudo text.
2. **Synthetic max-rank capture showed a save error.** P07 made the preceding
   capture leave the museum, which saves; the validator correctly rejected the
   presentation-only totals. The capture now opens the profile first and asserts
   no save attempt (`tests/capture_economy.gd`). No runtime change.
3. **Long-content modal fixture** joined repeated sentences without spaces
   (`tests/capture_post_heist.gd`). Fixture only.

## Open findings

| ID | Finding | Owner |
| --- | --- | --- |
| P08-I01 | Level 1 alone spends 53–104% of the lifetime 3× budget; the remaining ~95 jobs would run at 1×. Rule kept; needs a product decision after P08-04 comfort observations. | User decision → design §3 |
| P08-I02 | First-case board durations are uneven: Sun Seal, Sapphire Cup (~1.8 min) and the two story boards (~3 min) are below the 4–7 minute target; Pearl/Starry Night (8–10 min at 1×) exceed it. These are the demo's tutorial boards reused as story candidates. | P08-01 content decision |
| P08-I03 | On slice boards the player cannot act for ~45–56% of 1× time (all docks working). Intended ASMR watching or dead time must be judged by observed players. | P08-04 |
| P08-I04 | Level 2 boards spend 110–150 s per job waiting for unwanted packets to expire. | P11 queue authoring |
| P08-I05 | Level 3 reference orders block when the player acts before earlier flights land (`the_magpie`, `apples_and_oranges` even when acting instantly; `the_star` with 2-second pacing). Existing tests drain every flight, so this was invisible. Affects the demo now and Level 3 story content later. | P11 generator/validator must simulate overlapping play |
| P08-I06 | Content buttons are 62–70 design px (~34–38 pt on a 390-pt-wide phone), below a 44-pt target; queue buttons pass. | P13-09 |
| P08-I07 | The four shared beats and finale line are single sentences; representative scene writing and native review remain. | P08-01, P11/P13 |

## Handoff

Complete: P08-02, P08-03, P08-07, P08-08. Open: P08-01 (I02, I07), P08-04
(observation — see [playtest protocol](P08-Playtest.md)), P08-05 (I01, I03,
decisions), P08-06 (gate after P08-04). Save compatibility unchanged; no rule,
content value or boost budget changed. No purchases, external messages or
distribution occurred.

## User decisions of 23 September — implemented

| Decision | Implementation | Evidence |
| --- | --- | --- |
| 1× was too slow: double it | `BASE_TEMPO = 2.0` in `scripts/main.gd` scales flights, carrier/rotor timing, pickup lift and decoy expiry; 3× multiplies the new base; the 3× budget still counts real seconds. Timing tests now express simulation seconds. | `test_drones`, `test_columns`, `test_boost`, tempo table below |
| Empty 3× can be bought with credits | Tapping empty 3× offers 120 s for 240 earned credits (`economy.json.boost_refill`). `boost_refill:<n>` ledger event; paid state first, then a new budget epoch; load repairs a lost epoch write without charging again; Wealth untouched; offer only when empty; en/tr/es/de. | `test_boost_refill` (29 checks), `p08r2-captures/boost-refill-*.png` |
| Larger Sun Seal and Sapphire Cup | Story-only boards in `data/story_overrides.json` (Sun Seal 24×24 / 432 px, Sapphire Cup 28×28 / 418 px), merged by `art_id`; demo boards unchanged; queues authored by the queue tool. | `test_campaign`, `test_slice`, `p08r2-captures/story-*.png` |
| Fix Level 3 blocking (P08-I05) | `tools/rebuild_queues.gd` rejects any route that blocks when the player acts before flights land (pauses 0/1/2/4 s, with/without 3×) and retries with another seed. Re-authored `the_magpie`, `the_star`, `dance_at_le_moulin_de_la_galette` (blocked after the tempo change) and `apples_and_oranges`. `test_slice_tempo` now requires every board to win under overlapping play. | `test_slice_tempo` (118 checks) |
| Content updates must not lock saves | A changed board under an unfinished heist now drops only that session (recorded in `migration.content_reset_jobs`) instead of locking the whole save. Needed because these boards changed. | `test_content_update` |

Full gate after the decisions: `p08r2-final-a/`, `-b2/`, `-c/` — 29 suites /
86,557 checks, 0 failures. The frozen P03 prototype flight now reads its own
board fixture (`scenes/prototypes/lab_level.json`) so production queue changes
cannot alter it.

### Tempo after the decisions

Same simulated player (authored order, 2 s per decision, never waits for flights).

| Work | Level | Docks | Pixels | Moves | 1× (min) | Auto-3× (min) | 3× spent (s) | Docks full (s) | Decoy wait (s) |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|
| `sun_seal` (demo) | first_commission | 3 | 101 | 17 | 0.9 | 0.6 | 29 | 12 | 0 |
| `sun_seal` (story) | first_commission | 3 | 432 | 66 | 3.1 | 2.3 | 105 | 46 | 0 |
| `sapphire_cup` (demo) | first_commission | 3 | 124 | 19 | 1.0 | 0.7 | 32 | 12 | 0 |
| `sapphire_cup` (story) | first_commission | 3 | 418 | 59 | 2.8 | 2.0 | 96 | 42 | 0 |
| `girl_with_a_pearl_earring` | first_commission | 3 | 672 | 98 | 4.4 | 3.3 | 158 | 59 | 0 |
| `starry_night` | first_commission | 3 | 884 | 129 | 5.5 | 4.3 | 202 | 67 | 0 |
| `ivory_travel_clock` | first_commission | 3 | 211 | 31 | 1.5 | 1.1 | 50 | 18 | 0 |
| `workshop_swatches` | first_commission | 3 | 225 | 34 | 1.6 | 1.2 | 55 | 21 | 0 |
| `moon_gate_mask` (finale) | first_commission | 3 | 526 | 77 | 3.6 | 2.6 | 121 | 54 | 0 |
| `mona_lisa` | false_owners | 3 | 720 | 147 | 6.9 | 6.1 | 238 | 52 | 61 |
| `the_kiss` | false_owners | 3 | 728 | 152 | 7.1 | 6.3 | 248 | 44 | 67 |
| `the_scream` | false_owners | 3 | 720 | 146 | 6.8 | 5.9 | 236 | 58 | 51 |
| `birth_of_venus` | false_owners | 3 | 748 | 154 | 7.1 | 6.2 | 260 | 57 | 55 |
| `water_lilies` | false_owners | 3 | 704 | 140 | 6.4 | 5.6 | 231 | 48 | 50 |
| `the_gleaners` | lower_threshold | 5 | 616 | 149 | 5.4 | 5.3 | 100 | 0 | 20 |
| `the_magpie` | lower_threshold | 5 | 616 | 135 | 5.2 | 5.0 | 92 | 7 | 28 |
| `the_star` | lower_threshold | 5 | 624 | 149 | 5.6 | 5.5 | 119 | 0 | 30 |
| `dance_at_le_moulin_de_la_galette` | lower_threshold | 5 | 616 | 148 | 5.3 | 5.4 | 116 | 0 | 14 |
| `apples_and_oranges` | lower_threshold | 5 | 616 | 138 | 5.2 | 5.2 | 113 | 1 | 32 |

All boards now win under overlapping play. At the new pace, player time on the
larger boards is dominated by decisions, so automatic 3× saves little on Level 3.
A first story case takes about **13–20 minutes at 1×** and **9–15 minutes** with
automatic 3×, and would spend 428–683 s of 3× time; the budget can now be
refilled from job fees (240 credits = two job fees).

### Findings after the decisions

| ID | Status |
| --- | --- |
| P08-I01 boost budget | Addressed by the provisional credit refill; revisit price/amount after P08-04. |
| P08-I02 uneven first-case boards | Sun Seal/Sapphire Cup fixed for story (≈3 min). **Ivory Travel Clock and Workshop Swatches are now the short boards (≈1.5 min)**; the 4–7 minute target is met only by Pearl and Starry Night at the doubled pace. Decide whether to enlarge those two or lower the target. |
| P08-I03 inactive waiting | Docks-full time fell from ~45–56% to ~12–15% of 1× time on slice boards. |
| P08-I04 Level 2 decoy waits | Fell from 110–150 s to 50–67 s per job (≈13%). |
| P08-I05 Level 3 blocking | Fixed and guarded by the queue author and `test_slice_tempo`. |
| P08-I06 touch size, P08-I07 beats | Open (P13-09; P08-01). |
