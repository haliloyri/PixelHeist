# P01 — reproducible demo and architecture handoff

20 September 2026. Completed: **P01-01 through P01-06**. Next: **P02**.

## Delivered

- Recorded Godot 4.7.1, import/editor/export prerequisites and the backup/version
  control policy in [Development.md](Development.md). Created the pre-change
  snapshot before editing runtime files; no Git repository existed.
- Added `tools/validate_project.py`: clean import, editable main-scene smoke,
  test discovery, bounded subprocesses, error detection, preserved logs and
  source hashes, optional real renderer captures. Personal editor settings are
  isolated through a copied portable editor. Test app data uses a unique name.
- Moved legacy ConfigFile IO to `scripts/services/legacy_save_store.gd` while
  keeping existing main-controller entry points, save keys and behavior.
- Added `scripts/platform/capabilities.gd` and routed the artwork source button
  through it. Purchases, restore, rewarded ads and native sharing truthfully
  return unavailable. No external SDK or reward logic was added to the puzzle.
- Added `tests/fixture.gd`, used by the eight existing scene-based test suites.
  Fixtures assign paths before startup, seed presentation and disable links.
  Removed hardcoded per-test `/tmp` paths and the leftover boost-test save.
- Added `test_services.gd` for legacy compatibility, independent fixture saves,
  unavailable capabilities, URL delegation and OS failure handling.
  Added `capture_baseline.gd` for six reproducible renderer states.
- Documented current versus planned services in [Architecture.md](Architecture.md).
  Updated the English/Turkish design and checklist status together.

The authored JSON, existing scene layouts, artwork/audio assets, puzzle and
route rules have not been changed. Legacy ownership, slots, settings and boost
retain their existing format. Tests do not touch the player's progress file.

## Executed evidence

Runtime evidence: `artifacts/validation/p01-validation/` (source manifest,
individual logs, `summary.json`, six PNGs). The final runner/documentation
verification is recorded in `artifacts/validation/p01-final/`.

```sh
python3 tools/validate_project.py --output artifacts/validation/p01-validation --visual --audio-driver CoreAudio
python3 tools/validate_project.py --output artifacts/validation/p01-final --visual
python3 tools/validate_planning_docs.py
```

Host: macOS 26.6.2 arm64. Engine: `4.7.1.stable.official.a13da4feb`.
Renderer: OpenGL 4.1 Metal compatibility, Apple M5. Audio tests: CoreAudio.
Clean import and main-scene startup passed. **11 test suites, 15,146 checks,
zero failures** in the runtime validation run:

| Suite | Checks |
| --- | ---: |
| puzzle | 6,612 |
| flow | 7,333 |
| drones | 39 |
| expansion | 23 |
| museum | 34 |
| columns | 43 |
| bottom_entry | 38 |
| boost | 28 |
| anticipation | 962 |
| ambience | 8 |
| services / isolation | 26 |

The flow suite solves all 15 authored works through actual flight/pickup/delivery
at 1× and 3× and compares logical results. Specialized suites cover shared
docks, sealed waiting colors, reservation/route legality, mystery information,
decoy timing, lower-only Level 3 entry, automatic/manual boost and no boost refund
on undo/restart. Existing save/reload checks plus the new service suite verify
legacy settings, layout expansion and duplicate/invalid entry filtering.

Initial sandbox-only import attempts are retained in `p01-before`,
`p01-baseline`, `p01-baseline-bundle` and `p01-refactor-check`. They failed on
macOS data-directory/editor-profile/certificate access; a bare copied binary
was also killed by the OS. No failures were hidden. The successful run used
the complete copied app bundle and access to the normal desktop/audio session.
These failures are environment evidence, not passing gameplay results.

## Visual review and preserved layout

All four `sc/unnamed*.webp` references were inspected. Preserve their interaction
hierarchy: large artwork above, distinct active docks, readable numeric color
carriers and front/rear queues below, compact speed control and bottom tools.
Do not import the reference art, insect/hand aesthetics, reward counts or paid
powerups. The canonical heist mechanics take precedence over reference imagery.

Six screenshots were rendered at the configured 504 × 840 window size:

| Capture | Review |
| --- | --- |
| `00-serialized-scene.png` | Menu and artwork visible without executing the main controller; editable scene retained |
| `01-home.png` | Three level tabs, five target cards and clear start/museum actions fit |
| `02-heist-three-docks.png` | Cream city backdrop, full board, three docks, numeric carriers, mystery previews, free tools and 10:00 display preserved |
| `03-heist-bottom-five-docks.png` | Five docks fit; three sealed edges and green bottom entry indicators visible; decoy bar distinct |
| `04-museum-empty.png` | Empty frame is visibly empty, offers a job; floor label and horizontal navigation readable |
| `05-museum-owned.png` | Acquired artwork appears in its chosen frame; neighboring partial frames reflect horizontal scrolling |

The six frames were visually inspected; no new clipping or layout regression was
found at this baseline size. The owned-museum capture uses explicit fixture
ownership, not a claim that this capture script completed a job. Real completion
is exercised separately by flow/museum tests. This review preserves the existing
design direction; it is not native-language, touch-device or final art approval.

## Remaining limits and next phase

P02 is still unchecked: legacy saves are not yet atomic/versioned, use numeric
indices, have no corruption recovery and cannot resume an in-flight heist.
P02 should begin with an explicit mapping for all 15 artworks and a compatibility
fixture, then separate campaign/ownership/transactions and implement safe resume.
Do not replace the old save before migration and rollback tests pass.

The campaign/economy/narrative services, four-language gameplay, production
billing/ads/sharing, real-device performance and store distribution are still
future phases. No real purchase, network message, deployment or publication
was performed. Automated audio checks prove state/mixing behavior, not listening
quality or mobile output. Other operating systems and device sessions remain
unverified. The local backup is not a remote/off-device backup.
