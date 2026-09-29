# Pixel Heist — persistence contract (schema 1)

Implemented in P02. This is a local single-player save contract, not a cloud,
anti-cheat, payment-verification or account service. Product rules remain in
[GameDesign.md](GameDesign.md).

## Identities and state ownership

`data/content_ids.json` is the versioned registry. Its explicit legacy mapping
must never be regenerated from translated names or current array positions.
All 15 existing puzzle, location and artwork-detail records carry `art_id`.
The 20 case IDs, seven character IDs, two proposed pack IDs, five fragments and
six personal labels are reserved independently of their future display text.
Frames use `floor_01_frame_01` through `floor_10_frame_05`; the demo exposes three floors and the story projection four; the full ten-floor
spatial museum remains P07. Declaring an ID does not author its content.

| State | Purpose |
| --- | --- |
| `schema_version`, `save_id`, `generation` | Format, save identity, increasing commit generation |
| `mode`, `completed_jobs.demo/story`, `sessions.demo/story` | Separate progression and resumable jobs; no inferred story completion |
| `campaign.current_level_id/beats/finales/selected/deferred` | Ordered first-case choices, fixed finale and deferred alternatives |
| `acquired` | Ever-acquired history, first mode and first completion timestamp; migrated time is unknown (`0`) |
| `ownership` | Current `owned`, `sold`, `returned` or `loaned` physical state |
| `exhibits` | Stable frame → artwork and `original`/`memory`; a departed original cannot occupy a physical frame |
| `inspections`, `clues`, optional `records` | Authored main/side evidence retained after disposition |
| Optional `post_heist`, `stored`, `pending_notifications` | Per-mode pending inspection/decision/finale, explicit stored originals, queued optional notices |
| `labels`, `news.archive/saved/featured` | Independent memories, permanent news history and optional selections |
| `wallet`, `paths`, `path_grants` | Spendable credits, four independent paths and their event ledger |
| `transactions`, `entitlements`, `ad_grants` | Idempotent local effects, last-known pack state and distinct ad credits |
| `settings`, `boost_remaining`, `migration` | Existing accessibility/audio choices, shared budget and migration provenance |

The UI temporarily projects stable IDs to its existing numeric arrays through
`demo_progress_adapter.gd`. Its compatibility bridge accepts the old in-memory
demo completion entry points used by editor/test harnesses. It creates neither
story beats nor economic/path rewards. Normal live completion goes through
`SaveService.transact` before success presentation. Owned art remains shared
history across modes; replaying it in story mode cannot recreate a sold original.
Normal startup opens the new entrance, or directly resumes a pending inspection/
finale. The separate demo selector remains available; mode switches retain
independent heists and shared ownership. Only the first story case is authored.

## Files, commit point and recovery

Relative to the existing `user://progress.cfg` path:

| File | Role |
| --- | --- |
| `progress.cfg` | Original legacy ConfigFile; migration never writes it |
| `progress.cfg.v1`, `.v1.bak` | Primary and mirror of the last committed schema-1 snapshot |
| `progress.cfg.budget`, `.budget.bak` | Independent monotonic boost expenditure, bound to `save_id` |
| Corresponding `.tmp` files | Uncommitted writes; ignored when loading |

The container is `PHSTATE1\n`, a 64-character SHA-256 digest, newline, then
Godot Variant bytes with object decoding disabled. The 16 MiB limit is checked
before decoding. SHA-256 detects corruption; it is not authentication.

Write and flush a temporary file, close it, verify it, then atomically rename
it over the primary in the same directory. **Primary replacement is the commit
point.** Mirror that committed generation afterward. A backup-write failure
does not roll back an already committed primary. A crash before replacement
leaves the old state; after replacement the new state is recoverable even if
the mirror is older. Load the highest valid generation. Ordinary corruption
of either file recovers the other; two invalid copies lock saving rather than
resetting progress. Future schemas and changed puzzle fingerprints also lock
instead of silently loading an incompatible older snapshot.

Legacy ConfigFile migration filters invalid/duplicate numeric art entries,
maps IDs explicitly, preserves valid frames/preferences/budget and fills missing
old gallery positions in the original preferred-index order. It imports demo
history only. Subsequent loads use the new snapshot, so migration is one-time.
The original bytes remain available for manual recovery. Do not restore only
the legacy file over an active modern save or delete the budget to reset time.

A detected newer disk generation rejects a stale writer. This is defensive
detection, not a concurrent-writer lock or multi-device merge protocol. Run one
game instance per save. Tests cover application-process termination and local
file corruption on macOS; power failure, filesystem/controller durability and
other platforms still require release validation.

## Mid-heist continuation

Each job stores stable art/frame IDs, a fingerprint of authored puzzle rules,
the board, remaining count, lanes with fixed mystery packets, active capacities,
reservation IDs/cells/carriers and their picked flag, move/serial counters,
queue timers, clocks, automatic/manual speed state, and matched logical/visual
undo snapshots. Flights retain their exact position, outbound/return paths,
segment, heading, loaded phase and lift dwell. Deployment, rotor and departure
ages also persist. Cosmetic particles and one-shot sounds are not replayed.
Version 1 paths use the current 720 × 1200 logical layout. A later change to
board/dock geometry must explicitly migrate or version those paths; a cosmetic
layout change must not silently reinterpret saved coordinates.

Validation checks authored queue suffixes, board colors, per-color conservation,
unique reservations, carrier capacities and agreement between logical pickup
and flight phase. A reserved pixel remains on the board until pickup; a picked
payload belongs to one pending reservation; delivery consumes that reservation
and carrier capacity. Restoring never calls pickup/delivery again for an
already consumed phase. Content fingerprints exclude translated display text.

Checkpoints occur on job start, deployment, undo, pickup/delivery/reservation
frame boundaries, queue expiry, pause, navigation, OS suspension/focus loss and
exit, plus a one-second visual/timer checkpoint. Resume uses the last committed
frame. Final delivery alone is still `heist` until completion is committed;
`secured` reopens success without another award. Starting another target from
home explicitly offers continuing the saved job or replacing it. Save failure
stops simulation and exposes Retry while preserving existing files.

The separate budget is reduced durably **before** granting accelerated time.
Use the minimum valid expenditure for this save, including on backup recovery.
It is never in an undo snapshot. Exhaustion forces 1×; pause and background time
spend nothing. Checkpoint rewind, restart, mode changes and callbacks cannot
increase it. Synchronous write cost on mobile storage remains a device-measurement
task; do not batch expenditure after acceleration and introduce a refund window.

## Transaction boundary

| Kind | Stable ID pattern / effect |
| --- | --- |
| Completion | `completion:<mode>:<art_id>`; history, first ownership/frame and secured session in one commit |
| Inspection | `inspection:<art_id>`; one authored result and fixed evidence |
| Disposition | `disposition:<state>:<art_id>`; inspected owned object, ownership change, original removal and optional sale credits |
| Reward | `reward:<authored_event_id>`; credits and explicitly attributed path grants |
| Entitlement | `entitlement:<provider_event_id>`; known pack state, distinct purchase/revocation events |
| Ad grant | `ad_reward:<art_id>`; at most one local grant for an acquired work, no path growth |

Whole-number JSON floats normalize to integers, including nested path amounts;
object key order is immaterial. The same ID/kind/payload returns `duplicate` without writing or repeating an
effect. Reusing an ID with a different payload returns `conflict`. Failed IO
leaves the old committed state. An inspected/sold work keeps its evidence and
history; a replay cannot reacquire it. A delayed duplicate purchase event cannot
undo a newer revocation. The authored first fragment carrier is `water_lilies`;
unwritten carriers do not grant fabricated main clues.

These are persistence operations, not public/untrusted provider endpoints.
P05 supplies eligibility and disposition UI; P06 supplies authored economy and
reward provenance; P09 supplies verified providers, eligibility, daily caps and
refund reconciliation. No live purchase, ad integration or campaign grant is
enabled by P02. Test-only event amounts are not production balancing.

## Validation

`test_persistence.gd` exercises migration, semantic/corrupt/future saves,
separate budget, stale writers, IO errors, repeated callbacks and actual child
process termination at flush/replacement/mirror stages for all six transaction
kinds. `test_resume.gd` kills/relaunches at pickup and delivery, recreates scene
controllers for undo/pause/home/background/last-delivery/secured-result/budget
exhaustion, and round-trips all 15 authored works. Existing puzzle/flight suites
remain authoritative for route legality and complete 1×/3× solution equivalence.
All saves use isolated fixture paths. See [P02 handoff](P02-Implementation.md).

## P05 post-heist transactions

First story completion atomically stores the job, one `reward:job:<art_id>`
120-credit fee, pending display-frame context and `secured:<art_id>` optional
notice. Another first completion is rejected while that mode has an unresolved
post-heist stage. Replays cannot replace pending decisions or duplicate fees.
`post_heist_service.gd` validates fixed inspection payloads and recipient/buyer
IDs from `data/post_heist.json`. Authored records and clues must remain present
in a valid snapshot. Legacy inspection metadata upgrades through
`inspection:authored:<art_id>` while preserving its old ledger entry.

Keep, sale, return and loan update ownership and exhibition atomically, after
inspection. Only an exact eligible sale pays the authored offer. Store for now
removes the physical display but preserves ownership; re-exhibition is a
reward-free placement. A finale keeps its acknowledgement pending after the
choice. P06 adds authored economy, buyer trust and personal profiles; P07 still
owns loan scheduling and full storage/museum controls. The S18 renderer does not unlock an unauthored
campaign ending. See `test_post_heist.gd` for actual child-process kills during
completion, authored inspection and sale at flush/replace/backup boundaries.

## P06 economy and profile extension

Schema 1 now accepts optional versioned `economy` and `profile` maps. Opening an
older valid save adds them atomically, preserving wallet/ownership/evidence and
boost. Legacy path totals and grants remain metadata; recorded P05 gameplay
sources derive new professional history without repaying money. Unknown first
completion dates are never invented. See [Economy.md](Economy.md) for fields,
event IDs, first labels, migration and simulation boundaries.

Generic reward/ad payloads cannot supply path grants or reserved job/path IDs.
Every committed gameplay candidate reconciles eligible first-event rewards and
validates grant totals, separate contact trust and profile selections. The new
`decoration:<item_id>` transaction uses its authored price and atomically debits,
owns and equips a registered earned look. Duplicate callbacks cannot charge
again. `test_economy.gd` covers legacy/P05 upgrades, provenance exclusions and
actual process termination at the three atomic write boundaries for this seventh
transaction kind; earlier transaction suites continue to pass.

## 2026-09-23 additions

**Boost budget epochs.** The `.budget` record gains `refills`. Within one epoch
the balance only decreases (lowest of primary/mirror wins); the newest epoch
wins across records. A refill commits the paid state first (`boost_refills`,
wallet, 120 seconds), then writes the new epoch. If the process stops between the
two writes, loading sees `state.boost_refills` ahead of the record and rewrites
the epoch without charging again. Records without `refills` are epoch 0.

**Authored content updates.** When an authored board changes under an
unfinished heist (`content_changed`), loading no longer locks the save. Only
that mode's in-flight session is dropped, its `art_id` is recorded in
`migration.content_reset_jobs`, status is `content_updated`, and the repaired
state is written once. Completions, ownership, grants and post-heist steps live
outside sessions and are unaffected. Story sessions validate against the
story-board variants (`data/story_overrides.json`), demo sessions against the
demo boards.
