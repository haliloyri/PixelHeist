# Pixel Heist — ToDoList (English canonical)

Document: `PH-TODO` · Revision: `2026-09-25-r13` · Design: `PH-DESIGN / 2026-09-25-r13`

Source of truth: [English design](docs/GameDesign.md). Companion: [Turkish checklist](ToDoList.tr.md). AI agents must read the English files first.

**Scope:** finish the base 1.0 game through phased implementation. P00–P07 are complete, including the first playable case, independent target selection, durable heist-to-museum loop, production 3D heist presentation, economy/personal profile and the spatial museum/archive/news layer; the full game is not yet coded. **Next phase: P16 (r13 casual redesign, 25 September 2026).** P16 supersedes conflicting pending tasks in P08–P15.

**Tracking:** `[x]` means implemented and verified; `[ ]` means not complete, including partial work. Keep identical IDs/states in both languages. Add evidence beneath completed tasks. Record blocked work with its B-ID; continue independent tasks. Phase gate is complete only when its tasks and acceptance pass.

**Scope lock (r13, 25 September 2026):** five acts / 20 linear chapters / 5 heists each = 100 heists / 13 screens (6 full + 7 pop-ups) / English only. Energy, five compatible booster stocks (three gameplay buttons), gold, capped ads and purchases per the r13 design. The r12 lock (140 candidates, 40 closure jobs, 20 screens, four languages, 600-second boost budget) is superseded.

**Visual scope update:** dimensional pixels/scouts/carriers, spatial first-person museum travel, lively pop-culture entrance and celebration, and a themed game-modal family are mandatory base-game work. See [visual direction and references](docs/VisualDirection.md). P01–P07 are complete; P08 is next. Remaining visual work and acceptance continue in P08/P10/P11/P13.

## Current repository audit

Initial audit on 20 September 2026, updated after P07 runtime verification. See [P07 handoff](docs/P07-Implementation.md) for executed tests and platform limits.

| Area | Evidence | Status |
| --- | --- | --- |
| Godot project | `project.godot`, `scenes/main.tscn`; configuration identifies Godot 4.7; README records previous 4.7.1 validation | Clean import and main scene verified in P01 on Godot 4.7.1 |
| Content | Original three 15-entry files plus two separate story puzzles/details/locations | 17 works; first story case has six choices plus its fixed finale; remaining cases await authoring |
| Puzzle | `scripts/core/puzzle_state.gd`, `drone_routes.gd` | Shared docks, reservations, access, undo implemented |
| Presentation | `scripts/ui/`, `scenes/ui/`, `scenes/prototypes/` | Production 3D board/crew, entrance, return, reconstruction, success and modal family; perspective Camera3D museum corridor, elevators, approach and light/reduced-motion variants |
| Save | `scripts/services/`, `data/content_ids.json` | Stable IDs, migration, atomic recovery, flight/undo resume, independent boost and transaction ledger |
| Localization | `localization/`, `scripts/services/localization.gd` | 742 stable keys in en/tr/es/de; persistent language choice, contexts, plurals and fitting |
| Campaign / full game | `campaign_service.gd`, `campaign_view.gd`, `campaign_targets.json` | First case, post-heist flow, independent paths, personal profile and earned-credit looks, ten-floor museum, exhibitions, case file and news archive implemented; commerce/share, other cases and ending remain |
| Tests | Original suites plus localization/visual foundation/campaign and captures | P08: 29 suites / 86,557 checks including full-slice, tempo, refill and content-update suites; four-locale screen/motion review |

Do not mark a future task done because a similar demo widget exists. The existing README remains a demo runbook, not the release specification.

## Phase overview

| Phase | Depends on | Deliverable |
| --- | --- | --- |
| P00 | — | Design and planning baseline |
| P01 | P00 | Reproducible demo and architecture boundaries |
| P02 | P01 | Stable content IDs, persistence, and resume |
| P03 | P02 | Four-language and visual foundation |
| P04 | P02, P03 | Target trade-offs and campaign selection |
| P05 | P02, P03, P04 | Complete heist-to-museum flow |
| P06 | P02, P04, P05 | Economy, four paths, and personal memories |
| P07 | P03, P05, P06 | Museum, exhibitions, archive, and news |
| P08 | P01–P07 | Playable vertical slice and design validation |
| P09 | P02, P03, P06, P08; live integration also B03–B06 | Workshop, permanent purchases, and ad reward |
| P10 | P03, P07, P08 | Personal sharing and export |
| P11 | P08; localization from P03 | Content pipeline and first three levels |
| P12 | P11 | Complete five-act campaign and endings |
| P13 | P09–P12; B01, B02, B06 | Device performance, accessibility, and final localization |
| P14 | P13; B01–B08 | Release candidate and store readiness |
| P15 | P14; successful distribution | Launch verification and maintenance handoff |
| P16 | P02, P05, P07; r13 design | r13 casual redesign: minimum screens, linear story, economy |

Phase numbering is a work sequence, not separate game levels. P09 and P10 can follow the slice independently while content progresses. Every new runtime component below is **planned** unless already identified in the audit.

## P00 — Design and planning baseline

**Dependencies:** —  
**Files / outputs:** docs/GameDesign.md; docs/10-pixel-heist-oyun-cercevesi-ve-ekranlar.md; ToDoList.md; ToDoList.tr.md; AGENTS.md

- [x] **P00-01** — Publish the English canonical design and Turkish companion, revision 2026-09-20-r3.
- [x] **P00-02** — Replace correlated offer/fame examples with four independent motivations and explicit opportunity costs.
- [x] **P00-03** — Define canonical global cast, en/tr/es/de launch languages, and localization requirements.
- [x] **P00-04** — Inspect the actual project and record implemented demo features separately from planned production systems.
- [x] **P00-05** — Create matching phased checklists and an English-first AI entry point.
- [x] **P00-06** — Validate documentation links, revisions, task IDs/states, screen IDs, cast, and campaign totals.

**Acceptance gate:** Both designs and checklists agree on requirements, IDs, status, cast, screens, and content totals. This gate proves documentation only.

Evidence: design/checklist files, repository inspection of `project.godot`, `scripts/main.gd`, puzzle/UI code, and the three 15-entry data files. Run `python3 tools/validate_planning_docs.py` for structural synchronization. This check does not replace native translation review or runtime tests.

## P01 — Reproducible demo and architecture boundaries

**Dependencies:** P00  
**Files / outputs:** project.godot; scenes/main.tscn; scripts/main.gd; tests/; tools/

- [x] **P01-01** — Record the working Godot version, command, import/export prerequisites and create version-control/backup policy before broad changes.
- [x] **P01-02** — Run existing puzzle, flow, drone, expansion, museum, columns, bottom-entry, boost, anticipation and ambience tests; preserve logs and platform caveats.
- [x] **P01-03** — Capture current home/heist/museum in the real renderer and inspect sc references; record the approved layout and preserved mechanic contract.
- [x] **P01-04** — Separate current behavior from proposed services: campaign, saves, economy, narrative, localization, commerce, sharing. Refactor incrementally with behavior checks.
- [x] **P01-05** — Add a repeatable project-validation command and deterministic test fixtures using isolated temporary saves, never the player save.
- [x] **P01-06** — Define capability adapters for desktop/mobile and no-provider fallbacks; keep external SDKs out of puzzle rules.

**Acceptance gate:** A clean copy opens in the agreed Godot version, shows an editable main scene, runs the existing tests, and preserves all puzzle behavior.

Evidence: [P01 handoff](docs/P01-Implementation.md), [development/backup policy](docs/Development.md), and [architecture boundaries](docs/Architecture.md). Godot 4.7.1 clean import/start passed; all ten existing suites plus the new service suite passed (15,146 checks). Six real-renderer states and all four sc references were inspected. Logs, captures and source hashes: `artifacts/validation/p01-validation/`; final runner verification: `artifacts/validation/p01-final/`. Save format and puzzle mechanics are preserved. Device validation remains pending; P02 persistence/resume evidence follows below.

## P02 — Stable content IDs, persistence, and resume

**Dependencies:** P01  
**Files / outputs:** scripts/main.gd; scripts/core/puzzle_state.gd; data/*.json; planned SaveService and content schemas

- [x] **P02-01** — Define versioned schemas and stable art_id, level_id, character_id, event_id, pack_id; map all 15 legacy numeric indices explicitly.
- [x] **P02-02** — Separate campaign beats, ever-acquired works, current ownership, physical/memory exhibit slots, clues, labels, news, wallet and path grants.
- [x] **P02-03** — Implement atomic save/backup, schema migration, validation, corrupt-save recovery and explicit demo/story mode separation.
- [x] **P02-04** — Persist mid-heist board, lanes, active carriers, reservations/pickup/delivery phase, queue timers, deterministic mystery state and undo snapshot.
- [x] **P02-05** — Define safe resume of in-flight visuals from saved logical state; never re-award a removed pixel or replay a delivered payload.
- [x] **P02-06** — Keep real-time boost expenditure independent of rewind; save at safe checkpoints, app suspension, exit and budget exhaustion.
- [x] **P02-07** — Create idempotent transaction IDs for completion, inspection, disposition, rewards, entitlements and ad grants; test interrupted/repeated callbacks.

**Acceptance gate:** Old demo saves migrate without loss; kill/relaunch at pickup, delivery, inspection and sale never loses or duplicates pixels, art, credits or boost.

Evidence: [P02 handoff](docs/P02-Implementation.md), [schema and continuation contract](docs/Persistence.md). All seven tasks are implemented with isolated migration/recovery fixtures, actual process kills at pickup/delivery and three write stages for all six transaction kinds, repeated-callback checks, and all 15 authored checkpoint round-trips. Supporting runtime evidence: `artifacts/validation/p02-callbacks/`; full gate: `artifacts/validation/p02-final/`. Inspection/economy/commerce player flows remain P05/P06/P09; no live provider is enabled. Mobile lifecycle and storage performance remain device work.

## P03 — Four-language and visual foundation

**Dependencies:** P02  
**Files / outputs:** project.godot; scripts/; scenes/; data/; localization/; docs/Localization.md; docs/RenderingDecision.md; scenes/prototypes/

- [x] **P03-01** — Extract player-facing scene/script/content strings into stable keys and English source text; choose CSV/gettext workflow with context and plural support.
- [x] **P03-02** — Add en/tr/es/de catalogs, English fallback, supported-device-language default and persistent manual language selection.
- [x] **P03-03** — Migrate the canonical cast and speaker IDs without changing actual artist/place identities; keep spoilers out of untranslated speaker metadata.
- [x] **P03-04** — Use named placeholders and proper plural/localized number handling; do not derive store country or price from the chosen language.
- [x] **P03-05** — Audit fonts, Turkish casing, Spanish punctuation, German expansion, dynamic relayout, and pseudo-localized screens.
- [x] **P03-06** — Add missing-key/placeholder/locale parity checks and a context glossary for all future story and storefront content.

- [x] **P03-07** — Define the lively designer-toy/pop-culture art system: depth, lighting, material, typography, palette, original motifs and shared button/modal states; use docs/VisualDirection.md.
- [x] **P03-08** — Prototype volumetric artwork pixels, scouts and five carrier drones plus a perspective museum room; compare real-time 3D versus 2.5D production costs while preserving the 2D puzzle state.
- [x] **P03-09** — Prepare high-fidelity entrance, heist, museum, themed-modal and success mockups plus a short motion study; establish the rendering approach before implementing P05/P07 visuals.

**Acceptance gate:** The existing 15-work demo switches en/tr/es/de without mixed languages, missing keys, changed saves, broken placeholders or clipped controls. Visual mockups and a representative depth-rendering prototype also establish readable materials and the museum camera approach before P05/P07.

Evidence: [P03 implementation report](docs/P03-Implementation.md), [localization contract/glossary](docs/Localization.md), [rendering decision](docs/RenderingDecision.md). All nine tasks are implemented: 352 keys in four catalogs, persistent language choice, canonical public speaker labels, layout/glyph checks, shared art tokens, two renderers over identical puzzle state, a five-frame perspective room, five screen studies and a 16-second motion clip. Full gameplay/persistence gate: `artifacts/validation/p03-final/`; final prototype refinement: `artifacts/validation/p03-presentation-final/`. Production visuals remain P05/P07; native-speaker editorial and real-device performance gates remain P11/P13.

## P04 — Target trade-offs and campaign selection

**Dependencies:** P02, P03  
**Files / outputs:** S03–S05; scripts/ui/campaign_view.gd; scripts/services/campaign_service.gd; data/campaign_targets.json; story_* data; tests/

- [x] **P04-01** — Add independent offer ranges, fixed recognition, authored research link, tags and context-dependent exhibition fit to target data.
- [x] **P04-02** — Author six selectable targets plus one finale for the first level, including expensive/unknown and famous/low-offer counterexamples.
- [x] **P04-03** — Implement three diverse recommendations plus free Other targets; evaluate real collection state, not purchased theme ownership.
- [x] **P04-04** — Show expected offer if sold, lead/collection reason, meaningful gain and opportunity cost; handle empty collections and fewer remaining candidates honestly.
- [x] **P04-05** — Add dominance and independent-axis validation with offer-range comparisons; warn on weak differences without inventing live bonuses.
- [x] **P04-06** — Implement four distinct selectable jobs, fixed finale reveal/unlock, two deferred works and separate demo all-unlocked behavior.
- [x] **P04-07** — Exercise all 360 selectable orders at campaign-state level per level; sample full puzzle flows and simulate four single-motivation strategies.

**Acceptance gate:** Players can compare wealth/fame/research/collection without a universally best card; all legal four-of-six orders reach the fixed finale.

Evidence: [P04 implementation report](docs/P04-Implementation.md) and [campaign contract](docs/Campaign.md). `artifacts/validation/p04-verified/` passes clean import/startup, 17 suites / 26,671 checks and 89 captures. All 360 orders for the one authored case reach its fixed finale; four single-motivation strategies and actual flights for both added puzzles and the finale pass. Original demo mechanics/data and saves are preserved. There are 17 puzzle definitions and 459 complete en/tr/es/de keys. The other 19 case headers are explicitly unavailable content; their authoring and 360-order checks remain P11/P12. P05 is next; no full campaign ending, sale flow, production museum or release is claimed.

## P05 — Complete heist-to-museum flow

**Dependencies:** P02, P03, P04  
**Files / outputs:** S01, S06–S11, S17; scenes/; planned transition/narrative views

- [x] **P05-01** — Create editable scene shells and router/back-navigation rules for all 20 screens; implement this phase screens with loading/empty/error states.
- [x] **P05-02** — Commit completion before success presentation and expose one primary continue action; queue optional notifications without modal stacking.
- [x] **P05-03** — Implement reusable city-based van return with cosmetic hook, skip, reduced motion, paused boost and at most two dialogue bubbles.
- [x] **P05-04** — Implement fast reconstruction and four authored inspection outcomes; archive evidence before any sale and show no fabricated guaranteed clue.
- [x] **P05-05** — Implement keep/sell/return/loan eligibility and one consequence confirmation, plus Store for now and pending-inspection resume.
- [x] **P05-06** — Add returning-player recap, first-job onboarding, pause/blocked explanations and locale-aware accessible settings without interrupting active choices.

- [x] **P05-07** — Render artwork pixels as beveled blocks with top/side faces and contact shadows; reveal the tray on removal and show lift height without changing occupancy or access rules.
- [x] **P05-08** — Build volumetric scout bodies, rotor pods, material highlights and magnetic lifted payloads; preserve closest-accessible targeting, own-carrier return and ASMR timing.
- [x] **P05-09** — Build full-bodied carrier drones and shaped docks with legible numeric faces; queued/waiting rotors remain folded, first launch opens them, and zero payload rises toward camera then exits sideways.
- [x] **P05-10** — Replace the plain entrance with a dimensional logo, animated night-heist diorama, signature drone and one clear Play/Continue CTA; do not delay input for an intro.
- [x] **P05-11** — Implement a reusable game-modal family for briefing, inspection, news, success, settings and disposition/purchase: illustrated headers, tactile buttons, depth, safe focus/back behavior and four-language scroll layouts.
- [x] **P05-12** — Choreograph S08 last delivery → artwork reveal → success badge/drone confetti → base reward/Continue, with early skip, soft audio and reduced motion; give S18 a personal museum finale.

**Acceptance gate:** One completed heist goes through success, skippable return, reconstruction, inspection, disposition and museum with correct persistence at every step. Volumetric board/crew, designed entrance, themed modals and the success sequence meet the visual brief without altering puzzle results.

Evidence: [P05 implementation report](docs/P05-Implementation.md). `artifacts/validation/p05-final/` passes clean import/startup, 19 suites / 27,229 checks, 167 captures and 10.5-second motion. Final entrance refinement passes `artifacts/validation/p05-presentation-final/`. Completion, authored inspection and sale survive actual process kills at all three write stages. Four-language flow, eligible decisions, archived evidence, cold resume, hit-area projection and GPU tile removal pass. There are 534 localized keys. S18 is a save-driven presentation with its full-ending route gated until P12; news/purchase use tested shared component shells, with their content/providers remaining P07/P09. Only the first case is authored. P06 is next; real-device performance, native-speaker review and observed playtests remain open.

## P06 — Economy, four paths, and personal memories

**Dependencies:** P02, P04, P05  
**Files / outputs:** S11, S12, S15, S19; economy service/panels; data/economy.json; economy tests/captures

- [x] **P06-01** — Implement one spendable credit wallet, base job payments and authored buyer offers; show conditional sale income separately.
- [x] **P06-02** — Implement wealth/renown/insight/curation only; track contact trust separately and remove obsolete four-skill assumptions.
- [x] **P06-03** — Exclude ad credits, paid cosmetics and test grants from lifetime Wealth; do not reduce Wealth when credits are spent.
- [x] **P06-04** — Define first-event reward ledger, per-path rank tuning and masterwork_eligible jobs; test replay, undo, exhibit/rebuild and sale-loop exploits.
- [x] **P06-05** — Implement six personal labels, one primary artwork label, three pinned jobs and choice-based profile summaries.
- [x] **P06-06** — Author earned-credit decoration prices and first useful free purchase; simulate keep-only, sell-focused, research-focused and fame-focused economies.

**Acceptance gate:** Keeping, selling, returning and research choices create visible trade-offs; free play finishes the campaign without duplicate grants or stat gates.

Evidence: [P06 implementation report](docs/P06-Implementation.md) and [economy contract](docs/Economy.md). `artifacts/validation/p06-regression/` passes 21 suites / 85,454 checks and 235 captures; final pin-error handling passes 117 economy checks in `p06-final-check/`. Four policies × all 360 first-case orders complete without paid/ad income or stat gates. Six labels, three pins, four five-rank paths, separate contact trust and six earned looks are implemented in 622 en/tr/es/de keys. Atomic purchase interruption, P05 migration, actual-flight replay/undo and physical-vs-memory grants pass. Only the first case is authored: the 100-fee projection is explicitly synthetic, and full-campaign balance/completion remain P08/P11/P12/P13. P07 is next.

## P07 — Museum, exhibitions, archive, and news

**Dependencies:** P03, P05, P06  
**Files / outputs:** S02, S12–S16; scripts/ui/gallery.gd; scenes/ui/gallery.tscn; planned archive/news data

- [x] **P07-01** — Decouple level IDs from museum floors and artwork indices; support ten floors/five frames, 140+ storage and existing elevator movement.
- [x] **P07-02** — Implement explicit original, sold, returned, loaned and memory-display states; no photo can satisfy a physical collection requirement.
- [x] **P07-03** — Implement theme selection, tap-to-place/drag alternatives, first exhibition milestones and current-versus-historical completion.
- [x] **P07-04** — Build sourced real-art details separately from fictional mission ownership, including category/tags and localized reading layout.
- [x] **P07-05** — Build five-fragment case file with automatic verified links, known/unknown recap and optional private notes.
- [x] **P07-06** — Implement authored news triggers, multiple voices, persistent archive, optional saved album, three featured clippings and no repeat grants.

- [x] **P07-07** — Build a spatial Night Museum room with floor/wall depth, thick frames, spotlights and dimensional elevator entrances; retain five positions and first-person view without a thief avatar.
- [x] **P07-08** — Implement constrained perspective-camera corridor travel, artwork approach/return and elevator entry with parallax; preserve floor/focus/selected frame and offer touch plus keyboard navigation.
- [x] **P07-09** — Implement motion-comfort and lower-quality room variants: no default head bob, short/faded transitions, reduced shadow cost and retained visible depth; never fall back to an indistinct flat card list.

**Acceptance gate:** The player can curate ten independent floors, inspect originals/memories, read progress and news, and return to the next job without losing ownership. Camera movement, artwork approach and elevator entry visibly convey room depth in normal and reduced-motion modes.

Evidence: [P07 implementation report](docs/P07-Implementation.md) and [art-record source audit](docs/P07-ArtSources.md). `artifacts/validation/p07-final/` passes clean import/startup and 25 suites / 86,288 checks with zero failures (Godot 4.7.1, isolated saves). `p07-museum-faults/` covers 180-work storage, all 50 frame IDs, physical-vs-memory rules, sale/loan/return, migration and process kills at three atomic-write stages during placement. `p07-visual-linux/` holds 184 captures in en/tr/es/de plus pseudo-expanded text and the museum motion clip; review found no clipping or missing keys. Four legacy expectations written for the old 15-frame layout/strict loan-path equality were corrected to the ten-floor contract and one-time curation milestones. Captures used a software renderer (Mesa llvmpipe); real-GPU/device frame cost, observed usability and native-language review remain P08/P11/P13. Only the first case is authored; full-campaign news/fragments remain P12. P08 is next.

## P08 — Playable vertical slice and design validation

**Dependencies:** P01–P07  
**Files / outputs:** One complete level/seven candidates; artifacts/; new playtest report

- [ ] **P08-01** — Finish first-level art, authored queues, four shared beats and finale plus two deferred targets at representative quality.
- [x] **P08-02** — Run a full slice from fresh save and migrated demo save through selection, puzzle, story, economy and museum.
- [x] **P08-03** — Review all screen states against sc-derived interaction layout and current visual direction; record and fix clipping, contrast and input issues.
- [ ] **P08-04** — Observe real players choosing among independent motivations; collect explanations rather than only card click counts.
- [x] **P08-05** — Measure job duration, inactive waiting, 3× budget exhaustion and repeated transition tolerance; revise content/tempo without silently changing core rules.
- [ ] **P08-06** — Approve the slice gate with evidence before generating the remaining catalog; carry unresolved issues into named tasks.

- [x] **P08-07** — Review stills and motion captures for volumetric pixels/scouts/carriers, perspective museum navigation, entrance, themed long-content modal and success in normal/reduced-motion modes before scaling assets.
- [x] **P08-08** — Verify the new visual layer preserves reference-solution results, hit targets, five-dock readability, hidden/revealed packet states, forbidden-edge routing and independent reward/boost timing.
- [ ] **P08-09** — Restyle the heist screen (S06) to the approved "Bit's night heist" toy language (backdrop, HUD, artifact frame, carriers and toolbar) against `artifacts/artifacts/heist-v2-level1.png`; keep every puzzle/save/hit-target rule and existing test result unchanged.

**Acceptance gate:** A complete five-job case works in four languages; observed players explain sacrifices, enjoy the return loop, and find the next action. Still and motion evidence must pass the visual-direction acceptance before mass asset production.

Evidence (in progress): [P08 report](docs/P08-Implementation.md) and [playtest protocol](docs/P08-Playtest.md). `artifacts/validation/p08-final-a/`–`c/` pass 27 suites / 86,468 checks. `test_slice.gd` (93 checks) completes the first case from a fresh story save and from a migrated demo save through every screen in four locales. `test_slice_tempo.gd` (87 checks) proves boost and reduced motion never change outcomes on all 17 boards, checks hit targets and dock separation, and records tempo. Screen/motion review found and fixed collapsed S16 button text and two capture-fixture defects. User decisions of 23 September are implemented and verified in `p08r2-final-a/`, `-b2/`, `-c/` (29 suites / 86,557 checks): base pace doubled; empty 3× refillable for 240 earned credits (120 s, durable epoch ledger); story-only 432/418-pixel Sun Seal and Sapphire Cup boards; queue author and tests now reject routes that block under overlapping play (four Level 3 boards re-authored); changed boards drop only the affected unfinished heist instead of locking a save. Remaining: P08-01 — Ivory Travel Clock and Workshop Swatches are now the short boards (≈1.5 min) and beats are single lines; P08-04/P08-06 need observed players.

## P09 — Workshop, permanent purchases, and ad reward

**Dependencies:** P02, P03, P06, P08; live integration also B03–B06  
**Files / outputs:** S08, S19; planned commerce adapters/ledger; platform configuration

- [ ] **P09-01** — Build one earned-credit decoration catalog and two exact permanent packs: Night Signature and Art Deco Salon; protect gameplay color readability.
- [ ] **P09-02** — Implement reversible own-museum/drone/van previews and ownership-aware pack UI; avoid duplicate/overlapping first-release packs.
- [ ] **P09-03** — Use fake providers first, then validated platform billing adapters with localized prices, pending/cancel/fail/success, restore and refund/revocation reconciliation.
- [ ] **P09-04** — Define entitlement verification, secure platform transaction handling, offline last-known ownership and cross-device/account limitations explicitly.
- [ ] **P09-05** — Implement one opt-in first-completion ad placement with no first-heist offer, one reward/job and proposed two/UTC-day cap.
- [ ] **P09-06** — Grant only verified ad bonuses; reconcile duplicate/delayed callbacks and day boundary, pause audio/game/boost, and test unavailable/offline/cancel paths with test ads.
- [ ] **P09-07** — Confirm audience/privacy configuration and vendor behavior before live IDs; keep purchase failure and ad refusal outside campaign gates.

**Acceptance gate:** Sandbox purchases/restores/refunds and ad failures are correct; base gameplay remains usable offline; no live charges occur in tests.

## P10 — Personal sharing and export

**Dependencies:** P03, P07, P08  
**Files / outputs:** S20; S08/S12/S14/S15 entry points; planned sharing adapter

- [ ] **P10-01** — Implement free heist headline, five-work exhibition and disposition-memory templates using actual save data.
- [ ] **P10-02** — Add localized preview, optional call sign, clear ownership labels, game signature and safe image export at useful share sizes.
- [ ] **P10-03** — Implement platform share/save adapters with cancel/failure and desktop fallback; never send automatically or require sharing for rewards.
- [ ] **P10-04** — Validate spoiler-free templates and private-data exclusion; opening a share sheet is not a confirmed external post.
- [ ] **P10-05** — Add only verified store/art-preview links when destinations exist; no locked-level bypass or promised unimplemented deferred deep link.

- [ ] **P10-06** — Apply original pop-culture/sticker typography and dimensional museum/crew framing to still-share cards while retaining real artwork colors, ownership and spoiler protection.

**Acceptance gate:** Cards accurately reflect a player choice, save locally and open supported share sheets without auto-posting or leaking spoilers/private notes.

## P11 — Content pipeline and first three levels

**Dependencies:** P08; localization from P03  
**Files / outputs:** data/; tools/build_content.py; tools/rebuild_queues.gd; tools/chapter_two.py; tools/chapter_three.py; asset credits

- [ ] **P11-01** — Create an approved catalog schema with artwork/rights/source records, visual brief, fictional mission, four axes, theme links, puzzle parameters and fixed clue IDs.
- [ ] **P11-02** — Migrate and preserve all 15 current works, add six candidates, and distinguish source-generation inputs from generated outputs.
- [ ] **P11-03** — Automate palette readability, per-color capacity balance, route legality, reference solution and actual-drone completion checks for every generated board.
- [ ] **P11-04** — Write final English story beats/art facts and four-language content for the first three levels; verify real facts using primary museum sources.
- [ ] **P11-05** — Maintain media rights/attribution and original-fiction labels for every art, font, city pattern, sound and pack component.
- [ ] **P11-06** — Play and review every new work at 1× and 3× plus bottom-entry/waiting-color cases; tune challenge with observed data.

- [ ] **P11-07** — Create reusable beveled-pixel materials, drone/carrier variants, modular room/elevator assets and illustrated modal/button resources with measured quality tiers; keep canonical colors and source assets editable.

**Acceptance gate:** Twenty-one candidate works and 15 main jobs are complete, solvable, localized and narrative-consistent; repeatable generation does not destroy authored changes.

## P12 — Complete five-act campaign and endings

**Dependencies:** P11  
**Files / outputs:** Level catalog; narrative/news/exhibition data; S17, S18

- [ ] **P12-01** — Expand through Level 8: 56 candidates/40 main jobs, first two acts, fragments at Levels 2 and 6.
- [ ] **P12-02** — Expand through Level 12: 84 candidates/60 main jobs, Mr. Frost revealed at 10 and human stakes/exhibition at 11–12.
- [ ] **P12-03** — Expand through Level 16: 112 candidates/80 main jobs, press consequences, fragment at 15 and custody alternative.
- [ ] **P12-04** — Complete Levels 17–20: 140 candidates/100 main jobs, device reveal at 19, fifth fragment at 20 and definite final resolution.
- [ ] **P12-05** — Implement all three final approaches with prior sale/return/keep/publication variations and the actual final museum layout.
- [ ] **P12-06** — Author 40 deferred completion jobs and their post-ending context; no repeated main-clue grant or retroactive ending rewrite.
- [ ] **P12-07** — Complete 20 finale articles, approximately 25 event articles, exhibition themes, labels and all four localized catalogs with continuity/rights review.
- [ ] **P12-08** — Run campaign-state permutations, four-motivation economy simulations, every authored board solution and end-to-end samples per act/ending.

**Acceptance gate:** 140 distinct candidates support 100 main jobs and 40 post-story jobs; all three endings resolve the mystery and reflect earlier decisions.

## P13 — Device performance, accessibility, and final localization

**Dependencies:** P09–P12; B01, B02, B06  
**Files / outputs:** Exports; device captures; full test suite; localization catalogs; audio/assets

- [ ] **P13-01** — Choose actual minimum/representative devices and budgets, then measure FPS/frame time, memory, thermal/battery behavior, load times and package size.
- [ ] **P13-02** — Test safe areas, long/narrow screens, touch targets, multi-touch/cancel, app background/resume and OS interruption across all key flows.
- [ ] **P13-03** — Validate text scaling, contrast, focus/keyboard navigation, reduced motion and independent sound/music; offer accessible color differentiation without replacing numbers with letters.
- [ ] **P13-04** — Have native reviewers check en/tr/es/de dialogue, artwork context, jokes, glossary, store text and every screen for truncation; resolve all missing strings.
- [ ] **P13-05** — Run audio peak/mix and repeated ASMR listening checks on speakers/headphones; preserve pleasant pickup at overlapping scout rates.
- [ ] **P13-06** — Stress save corruption/migration, full storage, zero boost, interrupted purchase/ad/share, offline launch and long sessions; fix and recheck regressions.
- [ ] **P13-07** — Revisit 10–16 hour target and trade-off evidence with full-campaign player sessions; do not declare engagement or revenue validated from automated tests.

- [ ] **P13-08** — Profile full-board depth rendering, overlapping scouts, five carriers, museum camera transitions and success particles on target devices; lower visual cost without hiding pixels or changing simulation timing.
- [ ] **P13-09** — Validate tactile modal/button states, color identity under lighting, four-language text expansion, depth legibility, motion comfort and reduced-motion celebrations on the minimum display size.

**Acceptance gate:** Four languages and all critical flows pass on the agreed minimum/representative Android and iOS devices, with measured frame/memory budgets and no release blockers.

## P14 — Release candidate and store readiness

**Dependencies:** P13; B01–B08  
**Files / outputs:** Export presets; signing setup; localized store assets; release checklist

- [ ] **P14-01** — Finalize bundle/application IDs, versioning, exports, certificates/signing and store accounts using owner-provided credentials securely.
- [ ] **P14-02** — Produce localized listings, truthful screenshots/trailer, icons, content rating, support contact, privacy disclosures and media credits.
- [ ] **P14-03** — Recheck current platform billing/advertising/privacy requirements and market-specific availability; prepare product IDs, review notes and restore demonstration.
- [ ] **P14-04** — Run install/update/reinstall, entitlement restore, old-save migration and offline smoke tests on signed builds in internal testing channels.
- [ ] **P14-05** — Define production logging/crash reporting and minimal event measurement, retention/deletion, SDK kill switches and support/recovery runbooks.
- [ ] **P14-06** — Review the concrete release candidate, known issues and scope; submit/publish only within the owner-authorized release action.

**Acceptance gate:** Signed release candidates install and upgrade correctly; store products, disclosures, privacy/support and reviewer access are ready with no placeholder production credentials.

## P15 — Launch verification and maintenance handoff

**Dependencies:** P14; successful distribution  
**Files / outputs:** Release evidence; support/runbooks; changelog; ToDoList.md

- [ ] **P15-01** — Verify real store download, clean start, upgrade, core offline play and account-specific entitlement behavior without making unauthorized purchases.
- [ ] **P15-02** — Review crash/save/commerce/ad failures and actual player feedback; prepare scoped fixes and safe rollback or capability disablement.
- [ ] **P15-03** — Complete source/build instructions, asset/source inventory, schema migration history, known limits and support documentation.
- [ ] **P15-04** — Update both checklists with evidence; classify any remaining task as an explicit deferral instead of silently calling it complete.

**Acceptance gate:** The distributed version is verified, critical issues resolved, restoration/support usable, and the full 1.0 Definition of Done is evidenced.

## P16 — r13 casual redesign: minimum screens, linear story, economy

**Dependencies:** P02, P05, P07; design revision 2026-09-25-r13; live commerce also B03–B06  
**Files / outputs:** docs/GameDesign.md; docs/10-pixel-heist-oyun-cercevesi-ve-ekranlar.md; AGENTS.md; scripts/main.gd; scripts/ui/lobby.gd; scenes/ui/; scripts/services/; data/; tests/

Implements the 25 September 2026 pivot: 6 full screens + 7 pop-ups, 20 linear chapters × 5 heists, automatic Gallery, boosters, energy, gold, capped ads and purchases, English only. Supersedes any conflicting pending task in P08–P15. The Safehouse lobby (S1) already exists.

- [x] **P16-01** — Rewrite the English design and Turkish companion as revision 2026-09-25-r13; archive r12; update AGENTS.md, both checklists and the planning validator.
- [x] **P16-02** — Back up the whole project before runtime changes.
- [x] **P16-03** — Play opens the next heist directly; skip S01, S03, S04, S05 and the briefing modal.
- [x] **P16-04** — Make chapters linear: 20 × 5 = 100 heists; the existing 15 works fill Chapters 1–3; drop the 40 unchosen candidates; migrate old completion to the new order.
- [x] **P16-05** — Remove inspection and keep/sell/return/loan; every acquired artwork appears in the Gallery, including r12 sold/returned/loaned works.
- [x] **P16-06** — Delete removed screens and systems (S01, S03–S05, S09–S20, screens registry, flow panels, news, case file, memory studio, four paths, contact trust, exhibition themes, van looks) and their tests; move the demo to a developer menu.
- [x] **P16-07** — Lock the game to English; remove the language selector and device-language detection.
- [x] **P16-08** — Simplify the heist top bar: Pause, level ribbon with difficulty tag, free 2× toggle; remove the 3× budget, refill, sound, help, undo and restart.
- [x] **P16-09** — Implement Extra Dock, Zap, Scout Fly and Master Key with saved stock and automated tests.
- [x] **P16-10** — Detect a jammed heist and show P2 Out of Space (Continue +1 Dock, Watch Ad, Retry, Home).
- [x] **P16-11** — Hand-pointer tutorial tips for Heists 1–4.
- [x] **P16-12** — Shared pop-up template in the Safehouse copper/brass style.
- [x] **P16-13** — P1 Settings merged with Pause (Resume, Home −1 energy).
- [x] **P16-14** — S3 Level Complete: painting animation, win bubble, crew card, reward row, Continue, 2× Coins slot.
- [x] **P16-15** — Write story text: 100 win bubbles, 20 × 3 comic panels, opening panel and three endings, in English.
- [x] **P16-16** — S4 Story: panels, Skip, chapter chest, fragment board, ending cards.
- [x] **P16-17** — S5 Gallery (Paintings corridor one floor per chapter, Crew tab) and P7 Painting Detail with Share.
- [x] **P16-18** — Safehouse wiring: level number on Play, badges, avatar to Crew, hidden Event button, Gallery tab.
- [x] **P16-19** — Gold and energy: win rewards, stars, 10 energy with 20-minute refill, P3 Out of Energy.
- [x] **P16-20** — Chests and P4 Reward: Daily, Star Chest, Chapter Chest.
- [x] **P16-21** — S6 Shop and P6 Get Booster with gold-only items first.
- [x] **P16-22** — Purchase provider interface with a fake provider, seven packs, restore, P5 Offer.
- [x] **P16-23** — Ad provider interface with a fake provider, four rewarded placements, capped interstitials, No Ads.
- [ ] **P16-24** — Real store and ad SDK integration after separate owner approval (B03–B06).
- [ ] **P16-25** — Interface art: Gallery tab icon, chest states, pop-up frame, completion badge, Out of Space and energy art.
- [ ] **P16-26** — Characters: ten crew bugs and Rocco/Sprocket bubble portraits.
- [ ] **P16-27** — Comic panels: 20 × 3 plus opening and endings; approve one chapter's style first. *In progress:* Chapter 1 (opening + 3 panels) painted, approved and wired in (`assets/story/`, `STORY_ART` in `tools/build_chapters.py`); style and characters in `docs/Characters.md`.
- [x] **P16-28** — Automated tests: flow, r12 save migration, economy simulation; all suites green.
- [ ] **P16-29** — Device testing on iOS and Android; tune energy, prices and difficulty after playtests.
- [ ] **P16-30** — Produce the 85 heist puzzles and artworks for Chapters 4–20 (art rights, pixel boards, solvable queues, facts); until then play stops after Chapter 3 with "More heists coming soon!". *Research, 27 September 2026:* [100 open-access artwork candidates](docs/research/PublicDomainArt100.md) with individual museum rights evidence and image references; a selection pool, not 100 playable heists. Original images and level/floor placement are now covered by P16-39 (image-only user scope); release-territory review, pixel boards, solvable queues and complete gameplay/story content remain.
- [ ] **P16-31** — 26 September 2026 heist feedback pass: bottom-only entry on every board (Chapter 2 queues re-authored), ants-only 2× and half-speed 1× ants, door walk with door glow, bottom-frame passages, rotors unfold only for take-off with banking departures, multi-colour decoys, slim expiry bar, cube-sized highlight, new level plate and 2× chip, soft wooden pickups with haptics, adventure music. *Code in place; needs a Godot `tools/validate_project.py` run, a visual check and device feel test.*
- [x] **P16-32** — Approved v4 gameplay screen: museum art, five platforms, three-column queue, compact three-power toolbar, Row Beam and compatible resumes. Desktop implementation, six GPU captures and all six regression suites verified (7,329 checks; ambience rerun with CoreAudio); see [handoff](docs/HeistV4Implementation.md). Real-device acceptance stays in P16-29.
- [x] **P16-33** — Latest heist feedback: bold typography without duplicate native text, grounded top-down color-matched ants, no tap frames, exact-budget 20–45 packets, safe legacy queue conversion, working door glow and take-off-only rotors with ant emblem. Seven suites / 8,014 checks and four GPU captures passed; device acceptance stays P16-29. [Record](docs/HeistFeedbackImplementation.md).
- [x] **P16-34** — Distance-synchronized articulated walking, visible Row Beam pixel transfer/dissolve, pause/reduced-motion handling and final-row reward timing. Eight suites / 8,038 assertions passed; final 24-check rerun and GPU animation capture passed. [Record](docs/MotionFeedbackImplementation.md).
- [x] **P16-35** — Red-bee heist opening: original artwork, top-down carrier entering from below and hovering in the lower queue, ten beam scouts returning to its hatch before a top-edge exit, pixel-board reveal and delayed cube queues; pause/resume/reduced motion and paired sources for 15 existing works. Six suites / 1,189 checks verified initially; latest top-down return correction: 39 intro checks and 216 GPU frames passed; 100-work production remains P16-30 and device acceptance P16-29. [Record](docs/HeistIntroImplementation.md).
- [x] **P16-36** — Approved museum/crew home reference, live level/wallet/chapter progress, Shop/Home/Museum navigation, preserved energy/rewards and read-only Case File story replay. 17 home checks, 353 existing flow checks and three desktop GPU captures passed; [record](docs/LobbyReferenceImplementation.md).
- [x] **P16-37** — 10 named stages / 100 level slots, ten museum floors with originals/pixels, saved ten-work collection and clean PNG photo exports. Existing content/save identities preserved; 85 unproduced puzzles and native mobile sharing remain separate. Eleven suites / 8,156 assertions and eleven GPU artifacts passed; [record](docs/StagesMuseumImplementation.md).
- [x] **P16-38** — Replace the horizontal floor corridor with a vertically scrolling two-column exhibition of ratio-preserving frames; show sourced locked originals with lock-only status, open detail by tapping artwork, and keep collection actions owned-only. Floor order, lock behavior, portrait/landscape ratios and desktop captures passed: 72 museum + 353 flow checks and 16 GPU captures. [Record](docs/MuseumGridImplementation.md).
- [x] **P16-39** — Place 85 downloaded museum originals into Levels 16–100, retain the first 15 works, and populate ten floors without creating pixel boards or playable queues. Verify image provenance, stable mapping, preview-only behavior and isolated-save regression checks; [record](docs/OriginalArtworkPlacement.md).
- [x] **P16-40** — Replace Museum tab, footer, floor, original/pixel, collection and photo controls with distinct icon-only buttons; retain visible non-button floor/format data and hover labels. Isolated museum/flow validation passed (90 + 353 checks) with 16 GPU captures; [record](docs/MuseumIconNavigation.md).
- [x] **P16-41** — Pilot source-sampled Sun Seal pixels: 32×32 original-derived RGB cells, four independent drone matching groups, solvable queues, matching museum/gameplay/cargo views and old-board checkpoint compatibility. Verify a complete real-flight win and side-by-side renderer captures; [record](docs/SunSealSourcePixels.md).
- [x] **P16-42** — Enlarge Sun Seal pixels to 16×16, merge transitions into five playable colors, expose three cube faces and a contrasting cool backing; preserve 32×32 and older checkpoints, verify full completion and renderer captures. [Record](docs/SunSealLargeCubes.md).
- [x] **P16-43** — Slightly reduce Sun Seal cell size with an 18×18 / 324-pixel board, remove all inter-cell backing gaps while retaining three shaded faces and five matching colors, preserve older checkpoints and verify solvability/screenshots. [Record](docs/SunSealGapless.md).
- [x] **P16-44** — Expand Sun Seal to 32×32 at unchanged pixel pitch; route slimmer ants directly through the shortest permitted approach, preserve prior checkpoints, verify completion and GPU layout. [Record](docs/SunSealExpanded.md).
- [x] **P16-45** — Reduce Sun Seal to 15×15 at the same cell pitch, show stronger cube front faces, enlarge ants, reveal most queued cube colors, tighten queue rows, move the name and progress above the board, improve the speed glyph, and add a confirmed 300-gold five-minute 3× unlock with save/expiry coverage. [Record](docs/SunSeal15Speed.md).
- [x] **P16-46** — Keep Artwork Detail open while its original/pixel control swaps only the artwork image in place; preserve the current view through collection edits and verify both directions with isolated saves and GPU captures. [Record](docs/MuseumDetailInPlaceToggle.md).
- [x] **P16-47** — Match Sun Seal's on-screen cell pitch to The Gleaners, sample its square original into a proportional 22×22 / 484-cell board, preserve earlier checkpoints, and verify a full win plus portrait GPU captures. [Record](docs/SunSealGleanersScale.md).
- [x] **P16-48** — Add Play Again to owned, playable Artwork Detail; launch the selected artwork's fresh heist through the existing energy gate, hide the action for locked/unauthored works, and verify navigation plus mobile layout with isolated saves. [Record](docs/MuseumDetailReplay.md).
- [x] **P16-49** — Match Museum upper and lower navigation to the Safehouse footer, replace floor arrows/system menu with a themed right-side floor directory, and verify selection, dismissal, save isolation and portrait layouts. [Record](docs/MuseumHomeNavigation.md).
- [x] **P16-50** — Rebuild Sapphire Cup from its original as a 22×22, five-color raised-pixel board matching Sun Seal's scale and rules; preserve old checkpoints, author a solvable queue, and verify a full win plus portrait captures. [Record](docs/SapphireCupSourcePixels.md).
- [ ] **P16-51** — Refine Stage 1 Levels 3–10 pixel art to the latest 32-row, color-readable presentation over the existing puzzles; preserve save identities and verify the actual heist and Museum frames. The 22-row board replacement and 48-row visual pass were rejected for visual quality. [Record](docs/StageOneSourcePixels.md).
- [x] **P16-52** — Apply the shared heist title and progress placement to every playable artwork and resumed legacy board; retain board dimensions and bottom ant passages, and verify isolated layouts and portrait captures. [Record](docs/SharedHeistHud.md).
- [x] **P16-53** — Share the exact illustrated Safehouse footer with Museum, enrich Museum art and typography, and document the reusable screen style. Follow-up: compact the exhibition header to one row and move collected counts into the floor directory. 479 isolated desktop checks passed; 25 GPU/PNG artifacts verified; [record](docs/MuseumSharedStyle.md).
- [x] **P16-54** — Refine Museum tab underline and Painting Detail controls; separate Collection action shelves, add three saved arrangements and direct room swapping/reordering with legacy-save compatibility. 648 isolated checks and 28 GPU/PNG artifacts passed; [record](docs/CollectionLayouts.md).
- [x] **P16-55** — Remove the Museum footer, add upper-left Safehouse back navigation with Edit/Photo exit behavior, and reclaim the footer height for artwork. 590 isolated checks and 28 GPU/PNG artifacts passed; [record](docs/MuseumBackNavigation.md).
- [x] **P16-56** — Restyle Settings/Pause, Crew and Rewards using the shared navy/brass language; add in-place persisted switches, individual crew portraits and readable equip/lock cards, clear reward readiness and truthful itemized receipts. 712 checks passed; 50 captures produced with representative visual review; device acceptance remains P16-29. [Record](docs/SettingsCrewRewards.md).
- [x] **P16-57** — Restyle Level Complete with the shared victory card, joyful canonical Rocco/Sprocket art, finite confetti, staged stars and reduced-motion support; preserve win rewards, optional ads and Story routing. 481 isolated checks, 10 portrait captures and 84 animation frames passed; device acceptance remains P16-29. [Record](docs/LevelCompleteCelebration.md).
- [x] **P16-58** — Add finite confetti and a chest pop to reward receipts, preserving immediate dismissal, reduced motion, suspension and exactly-once grants. 146 isolated checks, six portrait captures and 84 animation frames passed; device acceptance remains P16-29. [Record](docs/RewardCelebration.md).
- [x] **P16-59** — Rebuild Case File as ten stage dossiers with spoiler-gated premises/recaps, milestone replay, readable scenes, previous/next navigation and selected-ending replay; preserve all save and claim identities. 455 isolated checks passed; 22 portrait captures produced with representative visual review. Device acceptance remains P16-29; [record](docs/CaseFileStages.md).
- [x] **P16-60** — Author Stage 1 opening/finale art and short dialogue; replace Case File prose reports with direct scene viewing gated by artwork completion, and connect Stage 1 live scenes while preserving save/claim IDs. 419 isolated checks passed; 14 portrait GPU captures produced with representative visual review; [record](docs/StageOneStoryScenes.md).
- [x] **P16-61** — Move Stage 1 opening/finale dialogue into named speech balloons on the illustrations; remove the lower text area in live Story and Case File, preserving uncropped art and navigation. 51 isolated Case File checks passed; 14 portrait captures produced with representative visual review; [record](docs/StageOneStoryScenes.md).
- [x] **P16-62** — Add six large illustrated Safehouse reward/ad/No Ads shortcuts, a two-column reward-card overview and matching receipt/offer art; preserve claim/provider boundaries and focus. 505 isolated desktop checks passed; 29 portrait GPU captures produced with representative visual review. Device acceptance remains P16-29. [Record](docs/IllustratedRewards.md).
- [x] **P16-63** — Apply the approved simplified Safehouse background, retaining existing controls and reward flows; verify standard/tall portrait readability. [Record](docs/SimplifiedSafehouse.md). 38 isolated lobby checks and seven GPU captures passed; standard/tall layouts reviewed.
- [x] **P16-64** — Replace ornate reward medallions with the approved satin-enamel object icons across Safehouse, rewards and offers; move shortcut labels below silhouettes and verify portrait layouts. [Record](docs/EnamelRewardIcons.md). 80 isolated checks and 29 GPU captures passed; standard/tall layouts reviewed.
- [ ] **P16-65** — Unify footer and Case File with the satin-enamel icon family, remove the redundant bronze chest, and restyle Start Heist with an honest disabled More Soon state. Verify navigation, focus, claims and portrait layouts. [Record](docs/HomeControlsEnamel.md).

**Acceptance gate:** A new player goes Safehouse → Heist → Level Complete → Safehouse with at most one pop-up at a time; each chapter finale shows Story; all 13 screens work in English; r12 saves migrate without losing completed art; no real purchase or ad occurs in tests.

Evidence P16-01: r13 designs, archive copies in docs/archive/, updated AGENTS.md and validator; `python3 tools/validate_planning_docs.py` passes. Evidence P16-02: `.backups/pre-redesign-2026-09-25.tgz` (whole project except .godot).

Evidence P16-03–P16-23, P16-28: see [P16 implementation record](docs/P16-Implementation.md). `tools/validate_project.py` passes (test_puzzle 6,579, test_r13_store 72, test_r13_boosters 34, test_r13_flow 351 checks; 0 failures). Remaining: P16-24 needs owner approval for real SDKs; P16-25–27 have code-drawn placeholders only; P16-29 needs real devices; P16-30 content production.

## Production decisions and external inputs

These items are not reasons to stop P01–P08. Resolve them when their dependent work starts; credentials, actual device access, human review and store approval cannot be invented by coding.

| ID | Decision / input | Impact |
| --- | --- | --- |
| B01 | Shipping platforms and initial store countries | Portrait Android+iOS assumed; confirm before export/SDK choices. |
| B02 | Minimum devices, OS versions, performance budgets | Need representative devices before acceptance in P13. |
| B03 | Publisher accounts, app IDs, signing access | Owner/platform input; do not fabricate credentials. |
| B04 | Price tiers, product IDs, store products | Design mock prices are not production prices. |
| B05 | Billing/ad adapters and any verification service | Evaluate Godot compatibility, support cost and test/production separation. |
| B06 | Audience rating, privacy, consent and legal publisher text | Required for actual SDK configuration and store release. |
| B07 | Native-language review and asset rights evidence | Draft translations and source links alone do not complete editorial/rights review. |
| B08 | Approved release scope and submission timing | Review a concrete signed candidate; this checklist does not itself publish anything. |

## Definition of Done — base 1.0

Revised for r13 on 25 September 2026; the r12 definition is superseded.

- 100 paintings have distinct IDs, valid artwork/rights records, one factual line and solvable authored queues across 20 linear chapters.
- The 13 screens and their transitions work in English, including offline, cancelled, error and resumed states where relevant.
- The five fixed fragments, 100 win bubbles, chapter Story panels and three endings are complete and coherent. No purchase or ad is necessary to finish.
- r12 save migration and mid-heist resume are safe; no lost or duplicated art, gold, energy, boosters, stars or entitlements under interruption.
- Energy, boosters, chests, Shop, seven packs with restore, and capped rewarded/interstitial ads work with correct offline and failure handling.
- Automated checks and agreed real-device acceptance are recorded; no release-blocking defect remains.
- Signed builds, store/support/privacy assets and restoration are ready on the chosen platforms; follow P14–P15 for actual release.

## Explicitly post-1.0

Live events (the hidden Event: Apples button), a season pass, the standalone Venice adventure, video export, accounts/cloud sync and any language other than English. Do not include these in base completion metrics unless the user expands scope.

## Per-phase handoff

Record completed task IDs, changed files, executed checks/results, screenshots where useful, open defects/decisions, save compatibility and the next phase. Update English first, then Turkish in the same change. Never check a box merely because code compiles.
