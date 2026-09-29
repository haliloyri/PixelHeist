# P06 — economy, four paths and personal memories

20 September 2026. Completed: **P06-01 through P06-06**. Next: **P07**.

## Delivered

| Tasks | Implementation and evidence |
| --- | --- |
| P06-01 | One spendable credit wallet; 120-credit first story fees; exact authored private/public buyer offers only on confirmed sale. Dossiers distinguish guaranteed job income, conditional inspection and sale estimates. |
| P06-02 | Exactly wealth/renown/insight/curation. Independent five-rank progress and choice-based portraits on S15; stable per-contact trust is separate. |
| P06-03 | Only recorded gameplay fees and eligible actual sales increase lifetime Wealth. Ad/test credits and paid entitlements do not; decoration spending never decreases it. Reserved gameplay IDs and arbitrary path payloads are rejected by generic reward calls. |
| P06-04 | Durable first-event grants, 20 localized rank titles, thresholds, five explicitly eligible difficult demo jobs, first physical theme/diversity milestones and provenance validation. Actual replay/undo, reload, sale, storage/rebuild, memory exclusion and interruption checks pass. |
| P06-05 | S12 memories, six labels, one selected primary label per labeled artwork, three pins, ownership/date/fictional location/evidence, editable call sign and independent profile descriptions. Automatic firsts cannot move; subjective labels can. Departed works retain memories and evidence. Museum and storage cards display primary labels. |
| P06-06 | Six earned-credit vehicle/platform finishes, free preview, affordability, buy-once/equip, persistent visible tint and first-job affordable purchase. Four policies × all 360 first-case orders pass with no ads, paid products or progress gates. |

The implementation contract and full values are in [Economy.md](Economy.md).
New sources include `data/economy.json`, `economy_service.gd`,
`economy_panels.gd`, `validate_economy_data.py`, two economy test suites and a
renderer capture suite. Save service/schema, S11/S12/S15/S19, story presentation,
gallery, target dossiers and the validation runner integrate those boundaries.
The catalog now contains **622 keys in en/tr/es/de**. No story or art identifiers
are derived from translated strings.

The 15-work demo and its assets remain; there are **17 puzzle definitions and
one authored five-job story case**. The full 100-job campaign/ending, museum
management and platform commerce are not completed by this phase.

## Validation

Integrated gate: **`artifacts/validation/p06-regression/`**.

- Clean import and main scene; **21 suites / 85,454 checks / zero failures**.
- **235 real-renderer captures:** 9 baseline, 41 localization, 39 campaign,
  78 post-heist flow and 68 economy captures; existing 10.5-second motion re-encoded.
- `test_economy_simulation`: **57,764 checks**, 1,440 policy/order runs, actual
  authored transaction rules and semantic save validation. Four distinct
  examples, min/max path outcomes and a clearly labeled synthetic 100-fee budget
  projection are retained in `p06-economy-simulations.json`.
- `test_economy`: 107 checks in the integrated gate, including first purchase,
  first-event provenance, independent contact trust, physical-vs-memory
  collection, primary labels/pins, legacy/P05 migration, rank boundaries and
  **three actual child-process kills** during earned decoration spending.
- `test_campaign_flow`: 213 checks, including actual puzzle-flight replay and
  secured-result undo with no duplicate professional growth. Existing puzzle,
  shared docks, bottom entry, waiting colors, routes, sound, 1×/3×, resume,
  corruption and separate 600-second boost checks remain green.
- Economy capture suite: 2,323 additional layout/state assertions, four locales,
  empty/history profile, wallet/path separation, three-pin limit, returned
  memories, free preview, owned/insufficient-credit shop states, replay dossier,
  museum labels, pseudo-expanded German and synthetic maximum-rank display.
  Maximum-rank fixtures only alter presentation memory and never persist.

A final failed-save notification fix for removing a pin when three were already
pinned is verified in **`artifacts/validation/p06-final-check/`**: clean
import/startup and **117 economy checks / zero failures**. The prior UI incorrectly
suppressed this error at the pin limit; it now retains the selected pins and
shows the existing save-error recovery screen. No other runtime changes followed
the integrated gate. Final source hashes match that targeted run; subsequent
changes are documentation only.

```sh
python3 tools/validate_project.py --output artifacts/validation/p06-regression --visual --flow --economy --timeout 120
python3 tools/validate_project.py --output artifacts/validation/p06-final-check --suite test_economy --timeout 120
python3 tools/validate_economy_data.py
python3 tools/build_localization.py --check
python3 tools/validate_planning_docs.py
```

All runs use a clean temporary copy, unique Godot application identity and
per-fixture temporary saves. **No player's `user://progress.cfg` was opened,
reset or migrated.** Host: macOS 26.6.2 arm64 / Apple M5, Godot
`4.7.1.stable.official.a13da4feb`, GL Compatibility; CoreAudio for the sound gate.
Source manifests, commands, logs and artifacts are preserved with each run.

## Visual review and corrections

Turkish profile, first affordable purchase, owned finish and history; German
returned memory, dossier, museum primary label and maximum ranks; and
pseudo-expanded German profile/memory were visually inspected. The selected
shop item now shows its price and buy action immediately below the preview,
without duplicated name/preview controls. Purchasing or equipping selects the
actual new look. Platform tint also applies to the success diorama. Screens use
the existing scroll/action regions and game buttons; important long text remains
readable, with fixed navigation below the scrolling content.

Failed intermediate runs remain as diagnostic evidence, not acceptance. Initial
JSON numeric grant values needed normalization before strict integer validation;
that was fixed. A memory test inserted a StringName frame key rather than the
canonical String and correctly failed save validation; the fixture now uses the
canonical ID. One sandboxed import could not create its unique application-data
directory; the normal isolated runner completed with the required filesystem
permission. Later successful runs above are the acceptance evidence.

## Compatibility and next phase

Pre-edit snapshot: `.backups/pre-p06-20260920-211123.tar.gz`, with **1,989**
per-file hashes in its adjacent JSON. Original `puzzle_state.gd`,
`drone_routes.gd`, `levels.json`, `artwork_details.json` and `locations.json` remain
byte-identical to that snapshot.

Schema 1 receives optional versioned `economy`/`profile` state. Migration retains
wallet, objects, evidence, saves, first known labels and boost; old path metadata
is retained separately while professionally eligible history is derived from its
recorded sources. Existing P05 payments are never paid again. Unknown legacy
completion dates remain unknown. Decoration debit/ownership/equipment and path
updates share the existing atomic transaction boundary.

**P07:** ten floors, full placement/storage and original-vs-memory presentation,
current vs historic exhibitions, expanded case file, news/album and spatial museum
travel. P06 supplies their durable path/memory foundation, not the future UI.

Rank thresholds and cosmetic prices are first-case starting values. A high-value
sale already buys the small starting catalog; observed P08 playtests and actual
P11/P12 content distributions must assess that pace. The synthetic 100-fee
projection is not authored full-campaign balance. Human translation review,
mobile touch/lifecycle/performance and minimum-device acceptance remain P11/P13.
SDK-backed purchases/ads remain P09; export/sharing remains P10. No real purchase,
external message, deployment or distribution occurred.

Planning revision **r10**: **117 task IDs, 53 complete, 64 pending**, with matching
English/Turkish task IDs and states. Full-campaign free completion and final
balance are verified when the actual remaining P12 content exists.
