# P04 — target trade-offs and campaign selection

20 September 2026. Completed: **P04-01 through P04-07**. Next: **P05**.

## Delivered

- **P04-01/02:** independent authored sale ranges, fixed recognition,
  none/possible/strong research with reasons, theme tags and contextual physical
  exhibition fit. The first case has six selectable works and the original
  Moon Gate Mask finale. Two original fictional puzzles — Ivory Travel Clock
  and Workshop Swatches — supply expensive/unknown and low-money/research
  alternatives to the famous, lower-offer paintings.
- **P04-03/04:** operations desk, three recommendations, free Other targets and
  scrollable dossier. Cards show conditional fictional sale estimates, separate
  recognition/research, actual collection fit, a benefit, an available alternative's
  opportunity cost and puzzle difficulty. Empty museums, departed originals,
  overlapping strengths, the single finale and completed cases have honest text.
  Historic art facts remain separate from the fictional operation's holder.
- **P04-05:** non-overlapping range comparisons, contextual dominance and weak
  difference warnings. Three-target sets are compared for differentiation and
  real display context; there is no overall art score, live balancing bonus or
  paid-theme preference. A token 100-credit gap is not a meaningful advantage.
- **P04-06:** four distinct choices commit with shared beats, two deferred IDs,
  finale reveal/completion and next-case unlock through the existing atomic
  save boundary. Demo/story flights remain separate, original ownership remains
  shared, and replay does not restore sold art, multiply choices or pay estimates.
  Cold story startup opens operations; the original 15-work demo stays available.
- **P04-07:** all 360 ordered four-of-six choices for the one authored case,
  four single-motivation strategies, real controller flights for both new puzzles
  and the finale, plus persistence, replay, mode-switch and comparison checks.

Source ownership and exact target values are in [Campaign.md](Campaign.md).
The original 15-work content files are unchanged; story additions use separate
data files and stable IDs. Total puzzle definitions: **17**. The catalog now has
**459 keys in en/tr/es/de**. Case headings exist for all 20 planned cases, but
only the first case has an authored playable target set. Opening the next case
reports that limit. This does not claim a complete base campaign or ending.

## Validation and evidence

Final integrated gate: `artifacts/validation/p04-verified/` — clean import and
startup, **17 suites / 26,671 checks / zero failures**, plus **89 real-renderer
captures** (nine baseline, 41 localization, 39 campaign). Campaign state adds
9,106 checks including all 360 orders; actual campaign flow adds 208. The
remaining 15 suites still cover every legacy puzzle at 1×/3×, bottom entry,
shared docks, waiting colors, undo, durable boost, save migration, interrupted
writes/flights, localization and the P03 visual foundation.

```sh
python3 tools/validate_project.py --output artifacts/validation/p04-verified --visual --timeout 120
python3 tools/validate_campaign_data.py
python3 tools/build_localization.py --check
python3 tools/validate_planning_docs.py
```

Host: macOS 26.6.2 arm64, Apple M5, Godot
`4.7.1.stable.official.a13da4feb`, GL Compatibility; the ambience suite uses
CoreAudio. Each run imports a temporary project with a unique application
identity and fixture saves. No test opens, resets or migrates the player's
`user://progress.cfg`. Fault-injection workers deliberately terminate during
writes; their parent persistence/resume suites must still pass.

Visual inspection sampled the first-case cards, clock dossier, Spanish long
text, Turkish fit/completion states, German finale and pseudo-expanded dossier
and target cards. The campaign capture audit checks intended label bounds and
raw keys/placeholders in all four languages. These results establish desktop
layout, not phone performance or independent editorial approval.

The pre-edit backup is `.backups/pre-p04-20260920-191455.tar.gz`, with 883 file
hashes in the adjacent JSON manifest. Against that manifest, `puzzle_state.gd`,
`drone_routes.gd`, `levels.json`, `artwork_details.json` and `locations.json` are
byte-identical. The existing 600-second budget and puzzle contract are preserved.
Final report/checklist updates follow the runtime source manifest; only
documentation changes afterward, followed by static validation.

## Iteration history

- `p04-first` exposed a dynamic localization-prefix audit and a GDScript type
  inference issue. Existing-key prefix checks and an explicit string type fixed
  them; unknown complete keys still fail validation.
- `p04-state` exposed a recommendation set missing the strongest money example
  in an empty museum. Set comparison now includes coverage of available axis
  maxima while preserving genuine strengths/costs and physical collection fit.
- `p04-flow` and `p04-screens` passed focused controller/persistence checks and
  the initial 35 campaign captures. Four completed-case empty states were added
  afterward, increasing campaign captures to 39.
- `p04-final` is retained as a failed run: its expanded cold-start fixture kept
  using a stale save generation after a second game instance saved settings;
  the stale-writer guard correctly rejected subsequent commits. The fixture
  now reloads after the second instance exits. Its capture marker also still
  expected 35 images despite 39 successful captures. Both harness issues are
  fixed in `p04-verified`; no failed run is counted as final acceptance.

Planning documents are synchronized at **r8: 117 task IDs, 35 complete and
82 pending**. Completed IDs are identical in the English and Turkish checklists.

## Handoff and remaining limits

**P05 is next:** editable screen shells/router, committed-success continuation,
van return, reconstruction, four inspection outcomes, keep/sell/return/loan or
Store for now, pending-inspection resume, recap and the P03 production visual
direction. Preserve the selected-frame context and the committed choice/finale
state when adding these flows. Workshop Swatches has an authored side-record
identity; preview/completion does not yet archive it. The first finale's delivery
reveal is not a main archive fragment.

P06 owns actual job payments, buyer offers and profile grants. P04's prices are
fictional tuning values and completion never awards their sale estimate. P07
owns the ten-floor spatial museum; the current story projection has four floors
to accommodate 17 works. P11/P12 author the remaining target sets, full dialogue,
closure jobs and ending; each added case needs its own 360-order validation.
P11/P13 retain native-speaker review and real-device/lifecycle/performance gates.
No distribution, external messaging, real purchase or live provider integration
was performed.
