# P07 — museum, exhibitions, archive and news

Implemented 20 September 2026; verified and closed 23 September 2026.
P07-01 through P07-09 are complete. Planning revision r11.

## Implementation

- Ten independent stable-ID floors, five frames each, uncapped object storage.
  Original, sold, returned and loaned ownership is separate from memory displays.
  Tap placement and native drag/drop share one atomic operation. Replacement
  preserves the previous object in storage; intentionally empty frames stay empty.
- Seven optional exhibition themes show current physical matches and historical
  first milestones separately. Existing economy grants remain authoritative:
  memories, rebuilds, repeated placement and loan recall never repeat rewards.
- S12/S16 expose the collection, sources, personal history, known evidence,
  placement, storage, labels and eligible disposition. S13 has five fixed fragment
  slots, automatic verified links, known/unknown recap and optional local notes.
- Nine authored articles cover the available content with four fictional voices;
  persistent history, optional album, editable cover/dividers, read state and
  three featured saved clippings. Removing a clipping never erases history.
- A real perspective Camera3D renders the five-position museum corridor with
  floors, wall depth, thick frames, artwork textures, spotlights and recessed
  elevator cabins. Touch and keyboard travel, approach/return and both elevators
  preserve floor/focus/selection. Reduced motion uses short fades; light quality
  retains room geometry with lower rendering cost and no head bob.

The 15-work demo plus two authored story works remain. Storage is verified with
180 synthetic IDs, not represented as 180 authored artworks. The only authored
story case remains First Commission. Full campaign facts/news/fragments, human
translation review and actual mobile performance remain later phases.

## Evidence

Initial integrated gate: `artifacts/validation/p07-integration-first/` passes
planning/localization/data/import/main scene, campaign flow, exhibitions,
localization, legacy museum and post-heist suites.

Durable model gate: `artifacts/validation/p07-museum-faults/` passes 183 checks,
including 180-work storage/reload, all 50 frame IDs, physical-vs-memory rules,
sale/loan/return, old-save migration and actual process kills at three atomic-write
stages during placement. Failed writes retain the previous complete collection.

Final regression gate: `artifacts/validation/p07-final/` passes planning,
localization (742 keys × en/tr/es/de), campaign/economy data, clean import, main
scene and all 25 test suites / 86,288 checks with zero failures on Godot
4.7.1.stable.official.a13da4feb (Linux arm64, Dummy audio, isolated saves).

The first 23 September run (`p07-final-linux/`) exposed four stale expectations,
not runtime defects. `test_bottom_entry` and `test_services` still asserted the
pre-P07 15-frame projection; they now assert the ten-slot legacy layout is kept
inside the 50-frame (ten floors × five) projection with all added frames empty.
`test_museum_navigation` required all paths to stay equal after placing a
recalled loan as an original; that placement legitimately completes a one-time
curation milestone. The check now requires that recall grants nothing, that
wealth/renown/insight never repeat, that new grants are only `exhibition:` or
`diversity:` firsts, and that removing and rebuilding the same display grants
nothing further. Targeted rerun: `p07-fix-linux/`.

Visual gate: `artifacts/validation/p07-visual-linux/` holds 184 captures (baseline,
locale, campaign, museum and curation sets in en/tr/es/de plus pseudo-expanded
text) and `p07-museum-motion.mp4`. Reviewed corridor, approach, parallax,
elevator/entry, tenth floor, light/reduced variants, exhibition/storage/history,
memory, real-art details, case file/notes and news/album: no clipping, missing
keys or flat-list fallback. Review contact sheets are in `review-sheets/`. These
captures used Mesa llvmpipe software rendering under Xvfb, so they confirm layout
and depth composition, not GPU frame cost. The 20 September macOS GPU captures
(`p07-room-review/`, `p07-reading-review/`) predate the final `main.gd` and
localization edits.

Every runtime run uses `tools/validate_project.py` with a temporary clean project,
unique Godot application identity and per-fixture saves. The player's
`user://progress.cfg` is never opened or reset. No purchases, external messages,
deployment or distribution occur.

## Save compatibility and boundaries

Schema 1 gains optional versioned museum/case/news blocks. Migration retains
ownership, stored objects, evidence, history, credits, path grants and the shared
600-second boost budget. Local authored loans are immediately recallable to
storage through an idempotent transaction; future scheduled loans require a
separate product decision. New UI indices are projections of stable art/frame
IDs, never new persisted object identities.

Normal and reduced-motion museum presentations share the same state and puzzle
rules. Device thermal/frame/memory budgets remain P13; observed usability,
repeated-transition tolerance and motivation trade-offs remain P08. Native
language editorial review remains P11/P13. Full-campaign news production and the
remaining four main fragments remain P12.

## Handoff

Completed: P07-01 … P07-09. Changed on close: three test files, both
checklists and this report; runtime code unchanged since 20 September. Open:
real-GPU/device performance and thermal budget (P13), observed player
usability and repeated-transition tolerance (P08), native-language editorial
review (P11/P13), full-campaign news and remaining fragments (P12). Next phase:
P08.
