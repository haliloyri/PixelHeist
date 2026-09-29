# P02 — stable identities, persistence and continuation

20 September 2026. Completed: **P02-01 through P02-07**. Next: **P03**.

## Delivered

- Added the versioned content registry and explicit mapping for all 15 demo
  artworks; puzzle, location and detail data carry stable IDs. Content generation
  preserves those IDs. Existing authored boards, queues and puzzle rules remain.
- Split acquisition history, physical ownership, exhibits/memories, inspection,
  evidence, campaign modes, wallet/path events and provider state in schema 1.
- Added checksummed atomic primary/mirror writes, non-destructive legacy migration,
  semantic validation, recovery, future/content-change protection and write errors.
- Added exact logical/visual/undo job checkpoints, home Continue, replacement
  choice, background suspension and protected-save error handling.
- Moved boost expenditure to a separate durable monotonic record. Rewind,
  checkpoint recovery and job restart cannot replenish it.
- Added idempotent local transaction operations; completion commits before
  success. Future inspection, economy and commerce features have a tested
  storage boundary, not completed player-facing UI or live integrations.
- Added persistence/resume suites and actual OS-process kill workers. Extended
  the renderer captures with Continue, replacement and save-error states. The
  validation runner supports selected suites and terminates whole isolated
  process groups on timeout.

The file format, transaction keys, recovery semantics and future-phase boundaries
are specified in [Persistence.md](Persistence.md). A pre-edit snapshot and hash
manifest are retained at `.backups/pre-p02-20260920-132323.tar.gz` and `.json`.
No test read or wrote the player's real save. Migration happens when the user
runs this build against their own save; this task tested isolated fixtures only.

## Validation evidence

Final gate: **13 suites, 15,447 checks, zero failures**, clean import, main-scene
startup and **nine real-renderer captures**, recorded in
`artifacts/validation/p02-final/summary.json`, individual logs, PNGs and the
source SHA-256 manifest. Host: macOS 26.6.2 arm64, Godot
`4.7.1.stable.official.a13da4feb`, Apple M5 GL Compatibility, CoreAudio.

```sh
python3 tools/validate_project.py --output artifacts/validation/p02-final --visual
python3 tools/validate_planning_docs.py
```

| Validation | Checks / result |
| --- | ---: |
| Existing puzzle, flow, drone, column, bottom-entry, boost, anticipation, audio, expansion, museum and service suites | 15,146 passed |
| New persistence suite | 170 passed |
| New resume suite | 131 passed |
| Renderer captures | 9 saved; three new screens visually reviewed |
| Planning document synchronization | r6; 117 matching tasks, 19 complete / 98 pending |

Actual child processes were killed after flush, primary replacement and mirror
completion for all six transaction kinds (18 interruption cases), plus pickup
and delivery in real scene controllers. Tests cover retries, integer/JSON-float
callback equivalence, legacy files kept byte-for-byte, corrupted primary/mirror,
future schemas, malformed legacy data, write failure, stale writer protection,
independent exhausted boost, all 15 authored resume checkpoints, matched undo,
pause/background/navigation and final-delivery-to-secured-result continuation.
The original flow suite still solves all 15 works at 1× and 3× identically.

The new Continue, replace-heist and protected-save error screens fit the existing
504 × 840 viewport without clipping; English source text remains pending P03
localization. The final nine captures are byte-identical to the reviewed renderer
run. A separate runner timeout check killed a parent and its sleeping child in
1.01 seconds; its expected timeout is recorded as a successful harness check in
`artifacts/validation/p02-timeout-check/summary.json`.

Compared with the pre-P02 archive, puzzle/route/ambience sources are byte-for-byte
unchanged; authored content JSON differs only by added stable identity fields.
The final runner cleaned its unique application data. The evidence source
manifest precedes this documentation-only addition of final results; no runtime
code changed after the full passing run.

Supporting incremental evidence is retained in `artifacts/validation/p02-first`,
`p02-storage`, `p02-resume` and `p02-callbacks`.

The intermediate `p02-runtime` run is deliberately retained as a failure:
raw JSON passed through Godot's OS command wrapper lost quoting in a test worker.
Its child-process diagnostic is preserved in `worker-argument-failure.log`.
The obsolete test processes were stopped, arguments changed to base64, child
watchdogs added and the runner's process-group timeout cleanup strengthened.
This was a test-harness fault, not a passing storage test.

The `p02-verified` run also remains recorded as failed: it exposed strict
integer-versus-JSON-float dictionary equality in repeated callback detection.
Canonical whole-number normalization fixed the mismatch. `p02-callbacks` and
the final full run include the explicit regression check and pass all cases.

## Limits and handoff

Next is P03: stable localization keys and complete en/tr/es/de gameplay,
plus the newly specified visual foundation and depth prototypes. P02's new UI
text is English source; the existing demo is Turkish. Four-language completeness
is not claimed. Preserve all new r5 visual-scope tasks as future work.

Inspection/disposition screens, authored campaign/economy, ten-floor memory
display, real billing/ads and provider verification remain P04–P09 work. The
schema is ready for independent state; it does not imply those features exist.
This desktop evidence does not establish mobile lifecycle delivery, storage
latency/battery cost, power-loss durability, concurrent save access, device
performance or store distribution. No deployment, external message or real
purchase occurred. Existing P01 evidence remains historical and unchanged.
