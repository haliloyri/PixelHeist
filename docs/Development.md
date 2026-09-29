# Pixel Heist — development and validation

Read [GameDesign.md](GameDesign.md), [ToDoList.md](../ToDoList.md), and
[Architecture.md](Architecture.md) before changing runtime behavior.

## Toolchain and clean import

The P01 host has Godot **4.7.1.stable.official.a13da4feb**, macOS 26.6.2 arm64.
The project uses the GL Compatibility renderer, a 720 × 1200 logical viewport,
and a serialized editable `scenes/main.tscn`. Use the standard Godot editor;
there are no C#, GDExtension, third-party runtime SDK, or Python game dependencies.
Python 3 is used only for development tools. Do not regenerate content merely
to open the project: the source assets and authored JSON are already present.

```sh
export GODOT_BIN=/Users/hoyri/Downloads/Godot.app/Contents/MacOS/Godot
"$GODOT_BIN" --path . --editor --import
"$GODOT_BIN" --path . --editor scenes/main.tscn
```

Normal editor commands use the developer's Godot profile. For automated checks,
use the isolated command below. Delete no player save to make a test pass.
Imported `.godot/` data is generated and is not a source prerequisite. Track
source assets, their `.import` recipes, script `.uid` files, scenes and data.

Editor/import checks do not need export templates. A distributable build needs
export templates matching the engine, explicit platform presets, and later
platform SDK/signing/account setup. No export preset, signed mobile build, or
release approval is supplied by P01. Do not upgrade the engine silently during
a phase; record its version and rerun the same checks if an upgrade is chosen.

## Repeatable verification

```sh
python3 tools/validate_project.py
```

For the macOS renderer and real audio gate:

```sh
python3 tools/validate_project.py --visual --audio-driver CoreAudio
```

The runner accepts `--godot`, `GODOT_BIN`, or a `godot`/`godot4` executable on
PATH. Its final fallback is the existing macOS Downloads/Applications install.
`--output` chooses a **new** evidence directory; existing runs are never
overwritten. `--timeout` bounds each process group (300 seconds by default).
Use repeatable `--suite test_persistence --suite test_resume` for targeted runs;
omit it for the complete gate. Unknown suite names fail instead of doing nothing.

Each run copies the project into a temporary directory without `.godot`, prior
artifacts, backups or version-control data. It gives the copy a unique app
identity, copies a portable editor with its own settings/cache, imports from
scratch, opens the main scene, runs every `tests/test_*.gd`, and optionally
captures nine baseline frames, 41 locale/layout frames and 39 campaign frames
with a real GPU. The installed engine and project files
are not edited by this command. Godot's portable editor setup follows its
[data-path documentation](https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html#self-contained-mode);
the macOS marker is placed beside the copied `.app`, as implemented in
[EditorPaths](https://github.com/godotengine/godot/blob/master/editor/file_system/editor_paths.cpp).

`tests/fixture.gd` assigns each scene a different temporary save path before
`_ready`, seeds random presentation, and disables external links. Ordinary
tests use `test_mode`; persistence tests deliberately turn it off for their
fixture only. Cleanup removes that fixture's file/directory, including boost
tests. No test reads, resets, imports, or overwrites the player's progress.
P02's child workers deliberately terminate themselves during a write or a flight
phase. Expected `Killed: 9` lines are evidence of fault injection; the parent suite
must still finish with zero failures. Workers have a watchdog, and the runner
terminates the whole isolated process group if a suite times out.

Logs, source SHA-256 manifest, version/platform, commands, exit codes and timings
are retained under `artifacts/validation/<run>/`. An engine error, assertion,
nonzero exit, timeout, or missing test completion marker fails validation.
Review screenshots yourself; a successful PNG write is not visual acceptance.
Headless results do not prove renderer, sound quality, mobile input or devices.
CoreAudio requires an accessible macOS audio session; a real-renderer capture
requires a desktop window/GPU session. Sandboxed denial is recorded as failure,
not silently removed from logs or claimed as a pass.

## Backup and version-control policy

This workspace was not a Git repository at P01 start. Before runtime changes,
a complete source/artifact snapshot was saved as
`.backups/pre-p01-20260920-074417.tar.gz`, with per-file SHA-256 hashes in the
adjacent JSON manifest. Archive SHA-256:
`7433612b08887d1f850d34b5713635e4a49a80d2aadcfb0fa83d3ad3fe7dbb79`.
The archive excludes `.godot`, `.git`, backups and machine caches; it does not
read or contain the player's save.

P02's pre-edit snapshot is `.backups/pre-p02-20260920-132323.tar.gz`, with an
adjacent per-file hash manifest. Modern saves and the independent budget contract
are documented in [Persistence.md](Persistence.md); do not restore only one file
or remove expenditure records as a routine development step.

Until version control is established, create a fresh timestamped source snapshot
before each broad phase. Never overwrite the previous snapshot. Verify the
manifest; restore into a new directory and validate there before replacing any
working file. A local snapshot is rollback protection, not an off-device backup.

When adopting Git, start from a reviewed baseline, commit small phase-scoped
changes, and include validation evidence in the handoff. Ignore generated
imports/caches, backups, local test logs/captures and build products; keep source
assets, `.uid`/`.import` recipes, tests, tools and documentation. Never commit
player saves, signing secrets, credentials or receipts. No remote repository,
push or publication was performed. Save migration was implemented and tested
only with isolated fixtures; the user's live files were not opened or migrated.

## P03 localization and presentation lab

Edit the English source and three locale JSON files, then run
`python3 tools/build_localization.py` and `python3 tools/build_localization.py --check`.
The normal validator includes catalog parity, references, placeholders and cast
checks before import. See [Localization.md](Localization.md).

Use `--prototype` for the nine dimensional prototype stills, redraw comparison
and 16-second MP4 (FFmpeg required). It can be combined with `--visual` and
selected suites. The sandbox scene has no save/provider access; open
`scenes/prototypes/visual_lab.tscn` and run that scene to explore it. See
[RenderingDecision.md](RenderingDecision.md) for controls, budgets and scope.
P03's backup is `.backups/pre-p03-20260920-114328.tar.gz` plus its hash manifest.

## P04 campaign selection

The demo entrance's Story cases button opens the first six-choice story case;
the operations desk can return to the all-unlocked 15-work demo. Both retain
their own suspended heist. See [Campaign.md](Campaign.md) for content ownership,
save additions, comparison rules and the P05 handoff.

```sh
python3 tools/validate_campaign_data.py
python3 tools/validate_project.py --suite test_campaign --suite test_campaign_flow --visual
```

The full runner includes campaign-data validation before importing Godot. All
four-language candidate text is authored through the existing catalog pipeline.
The original content generator owns the original 15 levels only; the two added
story puzzles have separate authored files and must not be folded into numeric
legacy identities. P04's source/artifact backup and hashes are
`.backups/pre-p04-20260920-191455.tar.gz` and the adjacent `.json` manifest.

## P05 flow and rendering evidence

```sh
python3 tools/validate_project.py --visual --flow --output artifacts/validation/p05-verified
```

`--flow` adds four-language entrance, return, four inspection outcomes,
disposition/confirmation, archive, case finale, personal-exhibition presentation,
modal-family and reduced-motion captures. Its GPU audit checks tile removal
against actual MultiMesh transforms (the headless Dummy renderer cannot supply
those transforms). It also encodes return/reconstruction/heist/success motion
with local ffmpeg and records desktop draw-call/batch counters. These counters
are not mobile performance acceptance. No OS capture or live player save is used.

## P06 economy and profile validation

```sh
python3 tools/validate_economy_data.py
python3 tools/validate_project.py --visual --flow --economy
```

The normal gate includes authored economy-data checks and both economy suites.
`--economy` captures S12/S15/S19, museum primary labels and reward dossiers in
four locales, including preview/purchase, departed memories, empty/full pins,
maximum-rank presentation and pseudo-expanded text. All JSON simulation reports
are copied to evidence even without visual flags. See [P06 evidence](P06-Implementation.md).
The pre-edit archive/manifest are `.backups/pre-p06-20260920-211123.tar.gz` and
its adjacent `.json`; 1,989 files, no player save. Only the first case is authored;
the separately labeled 100-fee projection is not full-campaign balance.
