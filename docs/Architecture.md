# Pixel Heist — runtime boundaries

P01–P04 implementation, 20 September 2026. Product behavior remains governed by
[GameDesign.md](GameDesign.md); this document describes code ownership, not
completion of the planned campaign.

## Existing runtime

| Boundary | Current owner | Responsibility |
| --- | --- | --- |
| Puzzle rules | `scripts/core/puzzle_state.gd` | Board, reachable cells, queues, shared docks, reservations, logical pickup/delivery, undo |
| Routes | `scripts/core/drone_routes.gd` | Legal entry/return paths; no saving, commerce, or narrative |
| Orchestration | `scripts/main.gd` | Demo/story content projection, selection, simulation clock, flights, boost, completion and screen flow |
| Campaign | `scripts/services/campaign_service.gd`, `data/campaign_targets.json` | Independent target comparisons, physical collection fit, ordered choices, fixed finale, deferred IDs |
| Localization | `scripts/services/localization.gd`, `localization/` | English keys, en/tr/es/de catalogs, persistent locale, fallback, plurals and text fitting |
| Stable identity | `scripts/services/content_catalog.gd`, `data/content_ids.json` | Explicit legacy mapping, artwork lookup, frame IDs and puzzle fingerprints |
| Save state and transactions | `scripts/services/save_service.gd`, `save_schema.gd` | Migration, mode separation, validation, ownership/reward ledger and durable boost expenditure |
| Persistence IO | `scripts/services/atomic_store.gd` | Checksummed, flushed temporary writes, atomic replacement and committed mirror |
| Legacy import | `scripts/services/legacy_save_store.gd` | Read-only ConfigFile migration source; writer retained for fixtures |
| Resume and demo bridge | `scripts/services/heist_checkpoint.gd`, `demo_progress_adapter.gd` | Matched logical/visual/undo checkpoints and transient numeric UI projection |
| Presentation | `scenes/ui/`, `scripts/ui/` | Editable scene shells, drawing, controls, gallery movement, celebration |
| Sound | `scripts/core/ambience.gd`, main's pickup voices | Existing independent music/rotor mix and pickup feedback |
| Platform boundary | `scripts/platform/capabilities.gd` | Explicit source URL opening; no-provider purchase/ad/share results |

`main.gd` keeps its existing `_load_progress`/`_save_progress` entry points.
The original `user://progress.cfg` becomes a read-only migration source. New
state uses `.v1`/`.v1.bak` and independent `.budget`/`.budget.bak` files. Numeric
indices remain a transient demo UI concern; saved identities are explicit IDs.
Missing saves initialize the demo; unreadable/future/incompatible saves lock
instead of silently resetting. See [Persistence.md](Persistence.md) for the
format, recovery guarantees, transaction IDs and continuation contract.

The store and capability objects are injectable before `_ready`. Tests assign
an isolated save path at scene construction, then explicitly enable persistence
only when testing it. Puzzle code has no dependency on either boundary.

## Phase service boundaries

| Phase | Service | Owned state / boundary |
| --- | --- | --- |
| P05 (implemented) | Narrative and screen routing | Shared beats, inspection, pending disposition, skippable presentation, recap |
| P06 (implemented) | Economy and profile | Wallet, eligibility, independent path events, one-time grants and personal labels |
| P07 | Collection/archive/news | Ownership versus memories, ten floors, clues, curated exhibitions and authored articles |
| P09 | Commerce | Provider verification and reconciliation; entitlements/ads never alter puzzle rules |
| P10 | Sharing/export | Local image rendering and user-triggered OS sheet; no automatic sending or rewards |

Extract one responsibility per phase and keep the existing mechanic tests green.
Do not create empty campaign/economy services that imply gameplay exists.
P04's implemented first-case selection and mode/save boundary are documented in
[Campaign.md](Campaign.md); the other 19 authored cases remain future content.
Final delivery commits through `_record_win` before success. P05 consumes
that durable result via `post_heist_service.gd` for return, inspection, disposition
and case recap. `depth_heist.gd` projects the unchanged logical puzzle into 3D;
`story_stage.gd` renders reward-free dioramas. `flow_screen.gd`, twenty editable
`scenes/flow/s*.tscn` shells and `modal_card.tscn` share localized reading/input
regions. Future screen shells do not unlock their unfinished features. P02's local
transaction boundary does not replace future provider verification or authored
eligibility rules. Keep those out of puzzle state and rendering callbacks.

P06 adds `economy_service.gd` to the atomic save commit. It derives one-time
professional grants from authored gameplay records, keeps contact trust separate
and validates profile/cosmetic state. `economy_panels.gd` renders S12/S15/S19;
preview and diorama code cannot spend or grant. Purchases here are earned-credit
looks only; provider-backed commerce remains P09. See [Economy.md](Economy.md).

## Capability contract

The current adapter works without a provider on desktop, Android, and iOS.
`supports(name)` is true only for enabled `external_url`. The details screen
calls `open_external_url` only after the player presses its source button.
Only HTTP(S) URLs are forwarded. Results distinguish `opened`, `failed`, and
`unavailable`; opening a URL is not evidence the user viewed its content.

`purchase(pack_id)`, `restore_purchases()`,
`show_rewarded_ad(placement_id)`, and `share_image(image_path)` return
`status: unavailable`, `reason: no_provider`. These calls have no side effects
and do not grant money, ownership, rewards or a successful share. There is no
SDK, product configuration, network request, price or provider auto-detection.

P09 will supply fake/test providers first and model pending, cancelled, failed,
verified and reconciled outcomes through stable request/transaction IDs. The
service, not a puzzle object or a presentation callback, will validate grants.
P10 will add an image-save action independent of the share sheet. Desktop or
mobile without native sharing will retain local export; that UI is not built
in P01. Capability absence must never prevent offline play or campaign progress.

The URL opener can be replaced with a callable and external links disabled.
`test_services.gd` uses that seam to verify unavailable operations, invalid
schemes, OS failures and delegation without opening a browser or contacting a
service. Device-specific billing, ads, file destinations, safe areas and OS
resume still need their later platform acceptance gates.
