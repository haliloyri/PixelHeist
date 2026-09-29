# Pixel Heist — AI implementation instructions

## Read first

1. Read `docs/GameDesign.md`, the canonical English product and story design.
2. Read root `ToDoList.md`, the canonical English implementation checklist.
3. Read `docs/Characters.md`, the canonical cast: names, species, looks and
   voices. Story characters are animals, never humans; use its visual specs in
   every art prompt.
4. Read `docs/ScreenStyleGuide.md` before any screen or UI artwork change;
   the approved Safehouse and shared components define the cross-screen style.
5. Inspect the actual files relevant to the current phase before editing.

Latest explicit user instructions take precedence. The Turkish design and
`ToDoList.tr.md` are synchronized reading companions. Older numbered notes and
the Turkish README describe the existing demo and historical decisions; do not
use them to override the current English specification. Speak to the user in
their chosen language, normally Turkish.

## Game language (2026-09-25, Halil)

- Everything the player sees in the game is in English: menus, HUD, buttons,
  story, dialogue, notifications, store items and in-image text in new art.
- Write all new player-facing text in English only. Do not add Turkish or other
  languages to game screens, and do not ship a language selector unless Halil
  asks for one again. This overrides the earlier en/tr/es/de launch plan.
- Talking to Halil stays in Turkish; this rule covers the game content only.

## Phase workflow

- Work from the requested phase and its dependencies. The current next phase
  is P16 (r13 redesign); use the checklist status rather than restarting.
- Preserve the existing Godot demo and save data while evolving it. Do not
  replace working mechanics merely to implement narrative or commerce.
- Use stable IDs for content, characters, events and products. Display names,
  translated strings and array positions must not become new save identities.
- English is the source language for new narrative, localization keys,
  technical identifiers and implementation documentation. Existing tr/es/de
  catalogs are kept in the repo, but the game is shown only in English (see
  Game language).
- A checked task means its implementation and acceptance evidence are complete.
  Keep partial work unchecked, record the remaining gap, and preserve the same
  task IDs and states in the English and Turkish checklists.
- Update the English design first when behavior changes, then its Turkish
  companion in the same change. Keep both document revisions aligned.
- Run `python3 tools/validate_planning_docs.py` after planning-document edits.
  This verifies structural consistency, not translation quality or gameplay.
- Run relevant existing/new gameplay checks for runtime changes. Tests must
  use isolated saves and must never reset the player's `user://progress.cfg`.
- Record the completed task IDs, changes, validation, remaining risks and next
  phase. Do not mark externally dependent release tasks complete without real
  device, platform or distribution evidence.

## Product constraints

- Design revision 2026-09-25-r13 is a casual redesign (Halil, 25 September
  2026). Implement it through phase P16; it supersedes conflicting pending
  tasks and r12 rules. The r12 design is archived in `docs/archive/`.
- Preserve the puzzle contract in design section 3: shared docks, sealed-color
  waiting, "?" packets, decoy timers, bottom-only entry from Chapter 3 and the
  doubled base pace. Undo, restart and the old shared 600-second 3x budget are removed;
  Out of Space and free 2x remain. A separate 300-gold 3x unlock lasts five
  wall-clock minutes (27 September user amendment).
- 100 levels = 10 named stages x 10 artworks = 10 museum floors (27 Sep).
  Preserve the 20 five-level story/claim IDs internally. An owned work may also
  appear in the player's ten-work private collection without leaving its floor.
  Original/pixel viewing and clean PNG photo export live inside S5. No automatic
  social posting; native share sheets require a real platform adapter.
- 13 screens only: S1 Safehouse, S2 Heist, S3 Level Complete, S4 Story,
  S5 Gallery, S6 Shop and pop-ups P1-P7. Do not add screens without the user.
- Story lives in S4 Story panels and the S3 win bubble. Keep the cast, the five
  fixed fragments (Chapters 2, 6, 10, 15, 20) and the three-way ending.
- Economy: gold, energy (max 10, lost only on failure or quitting a heist),
  boosters, chests. Purchases and ads go through provider interfaces with fake
  providers until the user approves real SDKs. No purchase or ad is required
  to finish the story.
- The base campaign has a complete ending. Optional later content must not
  contain its withheld resolution or silently become a launch requirement.

Do not deploy, publish, send external messages or initiate real purchases just
because they appear in a future checklist. Follow the user's authorization for
the actual action when that phase is reached.
