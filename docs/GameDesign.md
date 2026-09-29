# Pixel Heist — The Missing Inventory

**Canonical English game, story, screen, and economy design**

Document: `PH-DESIGN` · Revision: `2026-09-25-r13` · Language: `en`  
Date: 25 September 2026  
Companion: [Turkish design](10-pixel-heist-oyun-cercevesi-ve-ekranlar.md)  
Implementation: [ToDoList.md](../ToDoList.md) / [Turkish checklist](../ToDoList.tr.md)  
Previous revision: [r12 archive](archive/GameDesign-r12.md) (history only; it no longer governs behavior)

This is the authoritative design for AI-assisted implementation, not a claim that these features exist. Latest explicit user instructions take precedence; update this file and the Turkish companion together.

**r13 is a product pivot (Halil, 25 September 2026).** The game becomes a casual, story-led pixel puzzle in the style of Food Hunt: one tap from the Safehouse into a heist, one screen of reward, back again. Target selection, per-artwork disposition, the four development paths, news, case file, memory studio and most intermediate screens are removed. The story, cast, twenty chapters, five archive fragments and three-way ending remain.

## 1. Product promise and agreed direction

**Steal famous paintings pixel by pixel with a crew of robot bugs, and uncover the inventory someone is trying to erase.**

- **100 levels, 10 named stages of 10 artworks each, in fixed order.** Each stage maps to one of ten museum floors. The 20 existing five-level story beats remain internal identities: two beats per stage; five acts of two stages. This 27 September amendment supersedes the former player-facing chapter structure.
- **13 screens in total: 6 full screens and 7 pop-up windows.** One screen does one job. Text is minimal (section 15).
- The existing color-and-dock puzzle stays the core. Boosters, energy and gold wrap it (sections 3 and 12).
- Monetization: gold packs, a one-time Starter Pack, No Ads, timed offers, rewarded ads and limited interstitials (sections 13 and 14). The main story never requires payment; it can require waiting for energy.
- **Every player-facing string is English.** No other language ships (section 16).
- The base campaign has a complete ending. Nothing withheld for later content.

Counts and durations are design targets, not measured results.

## 2. Decisions that replaced r12

All ten were accepted by Halil on 25 September 2026. Open-question defaults (energy cap 10; bottom tab "Gallery" instead of "Upgrades") were confirmed the same day.

| # | Topic | r12 | r13 |
| --- | --- | --- | --- |
| 1 | Energy | None; failure free | 10 energy, lost only on failure or quitting a heist |
| 2 | Target selection | Choose 4 of 6 candidates, then a finale | Linear chapters; the 40 unchosen candidates are dropped |
| 3 | Artwork fate | Inspect, then keep / sell / return / loan | Every stolen painting goes straight to the Gallery |
| 4 | Progression | Wealth, Renown, Research, Collecting paths | Removed; stars, chests and the Crew instead |
| 5 | Undo and restart | Free and unlimited | Removed; the Zap booster and Out of Space replace them |
| 6 | Speed | 600-second shared 3× budget with credit refill | Free 2× toggle; optional 300-gold 3× for five minutes |
| 7 | Money and packs | No purchasable currency; cosmetic packs only | Gold packs, No Ads, Starter Pack, timed offers |
| 8 | Ads | One optional rewarded placement | Four rewarded placements plus capped interstitials |
| 9 | Side systems | News album, case file, memory studio, contact trust, exhibition themes, van looks | Removed; story lives in the Story screen and win bubbles |
| 10 | Screens | 20 screen shells plus separate modals | 6 full screens plus 7 pop-ups |

## 3. Puzzle contract

Preserved from r12:

- Choose a front color carrier, not individual pixels. A valid carrier may enter **any empty active dock**.
- Scouts collect matching, reachable, unreserved pixels, never cross filled pixels, and approach from the closest permitted frame entry.
- A real artwork color that is sealed inside stays selectable; its carrier waits until a scout can start. Rotors remain folded during platform work and unfold only for the completed carrier’s take-off.
- Some rear packets show "?"; their color and capacity reveal at the front row.
- Only colors absent from the artwork have expiry bars. Real colors never expire.
- New heists use five shared docks. Authored queues remain three lanes in Chapters 1–2 and five in Chapter 3; five-lane queues page in groups of three without changing their order. Existing saved heists retain their previous dock capacity until completion. **Every board is entered from below only** (Halil, 26 September 2026): the side and top frame rails are always sealed. Later layouts combine existing rules; no reflex or chase mechanics.
- Base pace is the r12 doubled pace for carriers, departures and timers; the ants' 1× pace is half of it (26 September 2026). Quiet rotor ambience, soft wooden pickup sounds with a light haptic tick, and reduced motion stay.

Changed in r13:

- **Undo and Restart buttons are removed.** A player who jams the docks gets the Out of Space window (P2).
- **Speed:** free 1×/2× toggling and a separate 3× control affect **only the ants' pace** (walking, spawning, pickup lift). Activating 3× costs 300 in-game gold and lasts five wall-clock minutes across heists, including paused/background time; the unlock deadline persists in the save. The remaining time appears on the 3× chip, a P6-style confirmation shows the price before any deduction, and expiry falls back to free 2×. Re-entering 3× before expiry costs nothing. Carriers, departures, decoy and queue timers keep the base pace. The old shared 600-second budget, its 240-credit refill and automatic acceleration remain removed.
- **Heist presentation amendments (Halil, 26 September 2026):**
  - Ants leave and re-enter each carrier through the door on its player-facing side, walking round the cube's flank; the door glows in the carrier color while its ants work; platform lights remain off (latest 27 September feedback).
  - Ants take direct diagonal paths across open space between cube flanks and the painting, choosing the shortest permitted approach including the empty-cell route and either cube flank. They use the available passage width, with no shared horizontal approach lane; their bodies and legs are 20% narrower with unchanged length. Ants reach the painting through two passages in the bottom frame rail, 3–5 painting pixels wide, halfway between each corner and the title plaque. The first ant pecks the rail three times, then the passage breaks open (ants queue under it meanwhile) and stays open for the heist.
  - Carrier rotors stay folded on active docks and in the queue, unfolding only for take-off (latest 27 September feedback); a departing carrier banks towards the side it leaves by.
  - Unwanted packets (colors absent from the painting) come in several colors, not only pink. Their expiry bar is slim and sits right under the cube; tapping a cube produces no surrounding selection/focus frame.
- **27 September 2026 / approved v4 screen:** navy museum, antique brass trim, top-down robot ants in the matching carrier color, static Lora Bold numerals, short wide carriers sharing one master body. Ants walk with alternating grounded legs, without a flight bob. The tripod gait follows actual route distance: 2× travel produces 2× stepping, while pause, gate waiting and pickup dwell stop the feet; reduced motion holds a neutral stance. When the face count reaches zero, it is replaced by the same top-down ant emblem; the finished carrier then unfolds its rotors and departs. Carrier enamel follows the artwork's actual palette; brass and ivory numbers remain constant. Keep a large ant travel area between the painting and five individual dark platforms. Show three complete waiting rows of three columns, then only the tops of a fourth row. No selection frame is drawn around tapped or selectable packets. Longer portrait viewports add travel space, keeping carriers/queues against the footer.
- **Large capacities (latest 27 September feedback):** author new real-color packets in the 20–45 range, using values such as 20/24/30/32/37/40/45 and exact-budget remainders. Never invent pixels to reach 20: colors with fewer than 20 pixels use their actual total, and active counters naturally descend below 20. Sum of unlaunched and undelivered real-color capacity equals the remaining board plus pixels carried by ants. Displayed active counts exclude picked pixels still returning home. Decoys consume no artwork budget and their displayed count is capped by total board pixels remaining.
- The large-queue version is stored separately from legacy authored levels. Old checkpoint hashes remain accepted only for the identical legacy artwork; when safe, only unlaunched queues are repacked after a solver proves completion. Board, active carriers, reservations, wallet and stars remain intact; an unsolved migration keeps the original queue. Migration is idempotent. Existing dock counts and paid extras are preserved.
- **Three large icon-only powers** in a compact bottom toolbar (102/1280 design-height units); stock remains saved and is available in tooltips/Get Booster. Two legacy powers remain accessible from Pause, preserving owned stock and stable IDs:

| Location / icon | Booster (stable ID) | Effect |
| --- | --- | --- |
| Toolbar / platform + | Extra Dock (`extra_dock`) | One extra shared dock for this heist; maximum two extras |
| Toolbar / horizontal beam | Row Beam (`row_beam`) | Clears the lowest occupied pixel row; blocked without charge while an ant reserves a pixel on that row. Removes matching queued/idle active capacity, so pixels cannot be collected twice |
| Toolbar / return arrow | Recall (`zap`) | Returns the chosen idle carrier to its original queue; retains the existing Zap save ID |
| Pause / legacy power | Scout Fly (`scout_fly`) | Reveals every mystery packet |
| Pause / legacy power | Master Key (`master_key`) | The next carrier ignores entry-side restrictions |

- **Row Beam feedback (27 September):** the cleared row briefly flashes, then each removed pixel follows a staggered curved path toward the drone boxes below. Color-matched trails shrink and dissolve before reaching the box; this is cosmetic, not a second delivery. Pause/suspension freezes the effect. The last row finishes its dissolve before Level Complete opens. Reduced motion uses a short local fade. The effect uses a readable fixed duration, independent of the ants-only 2× speed.

- Row Beam follows existing booster stock/300-gold rules. Older saves gain zero Row Beam stock and retain wallet, energy, progress and all legacy stock. New products are not created; existing “each booster” grants include Row Beam, with previously fulfilled purchases still idempotent.

- Tapping a booster with zero stock opens Get Booster (P6).
- **Failure:** when every active dock holds a carrier that cannot work and no free dock remains, the heist is jammed and P2 opens.
- **Stars:** 3 stars when no booster or continue was used, 2 with one, 1 otherwise.

## 4. Campaign structure

| Term | Definition | Amount |
| --- | --- | --- |
| Stage | Named group of ten artwork levels | 10 |
| Level / Heist | One artwork puzzle | 100 |
| Story beat (internal chapter ID) | Existing story/claim milestone | 20, at every fifth level |
| Museum floor | The corresponding stage's permanent exhibition | 10 floors × 10 frames |
| Private collection | Owned artworks chosen by the player; originals remain on their floors | One room, up to 10 distinct works |

Approved stage names and ranges are canonical in `data/stages.json`: The First Commission (1–10), Hidden Routes (11–20), Sealed Shipment (21–30), The Silent Auction (31–40), Double Entry (41–50), Missing Voices (51–60), Behind the Labels (61–70), The Cost of Trust (71–80), The Last Offer (81–90), Whose Museum? (91–100).

Every fifth level retains its existing story/claim event; the fifth is a mid-stage milestone, the tenth completes the stage. Existing chapter claim IDs and amounts are preserved, preventing duplicate rewards during migration. The five fragments remain at Levels 10/30/50/75/100. Stage names are story themes, not rigid art-period constraints. Existing 15 authored puzzles remain unchanged. Original-image assignments for Levels 16–100 do not become playable content. The 27 September image-only request fills all 100 museum positions while deferring new pixel boards and queues.


- Heists unlock strictly in order. Replaying a won heist is allowed and pays a reduced reward (section 12).
- The fifth heist of each chapter is its **finale**, using the r12 finale artworks (section 6).
- The existing 15 works fill Chapters 1–3 in their current order; their three finales stay Moon Gate Mask, Water Lilies and Apples and Oranges.
- Difficulty tags shown on the Heist level ribbon: none, **HARD** (red) or **SUPER HARD** (purple). Roughly one HARD per chapter from Chapter 2 and one SUPER HARD per act from Act II.
- Aim for 2–5 minutes per heist. Do not lengthen play by slowing drones.
- The all-unlocked 15-work demo moves to a developer menu; it is not player-facing.

**Original-image placement amendment (27 September):** All 100 level/floor positions have assigned original images, preserving the first 15 IDs and their three fictional story pieces. A future work can be previewed with its title, artist, date and source museum before acquisition. Where no pixel board exists, the floor retains the original (labeled Original in pixel mode), and its detail has no pixel toggle. Browsing does not unlock a heist or grant collection ownership.

**Sun Seal close-packed revision (27 September):** Level 1 uses 22×22 cells (484 pixels). Its screen-cell pitch matches The Gleaners (28×22 cells in the same 436×290 heist viewport): 290/22 ≈ 13.18 screen units. Sun Seal's square original therefore forms a 290×290 board, centred horizontally below the raised top frame. Five explicit gameplay colors remain shared by pixels, carriers and cargo; exact reproduction is not required. Top, deeper front-facing and right faces fill each cell completely, with no backing gaps between occupied cubes, in gameplay and museum previews. The cool lavender-blue backing (`#7c87b7`) is absent from the playable palette and is revealed only when pixels are collected. Existing 15×15, 32×32, 18×18, 16×16 and older checkpoints retain their own logical boards and queues.

**Sapphire Cup source-pixel revision (27 September):** Level 2 uses the same 22×22 / 484-cell square board and screen-cell pitch as Sun Seal. Sample its existing fictional original into five shared gameplay colors—museum navy, deep cobalt, sapphire blue, porcelain ivory and gold—with the fine gold rims preserved by source-color coverage. Use the same gapless raised cubes, distinct cool backing, top-frame placement, bottom-entry rules and authored solvable packet queue. The Gallery and heist show the same board. Previous Sapphire Cup checkpoints keep their own original board and queue; fresh attempts use the source-derived board.

**Stage 1 readable pixel presentation (27 September, latest Halil feedback):** Levels 3–10 use source-derived pixel-art images at 32 pixels high with artwork-dependent 16–24 color palettes. Distinct blue, gold and red regions must remain legible at the actual heist and Museum frame size; each pixel is visibly larger than in the rejected 48-row pass. These images are a visual layer over the existing authored puzzle cells, carrier palettes and queues: gameplay budget, pacing and checkpoint identity do not change. In the heist, each collected logical cell hides its corresponding image region; in the Gallery's pixel mode, the complete image is shown. The first two approved source-derived boards keep their existing appearance. Preserve each original image and its natural aspect ratio in Museum detail. The rejected 22-row replacement boards lost recognisable forms, while the later 48-row visual layer made pixels too small and colors hard to distinguish.

**27 September presentation amendment:** Level 1 ants are slightly larger and keep distinct shortest routes. Only a minority of rear Sun Seal packets carry an unrevealed "?"; other waiting boxes show their actual painting color. The three-column waiting rows have a smaller vertical gap. On every heist, including resumed legacy boards, the painting name sits on the top frame, with the pixel count and bar between the level plate and that frame. The progress bar is slim and fills in museum brass; its count is centered beneath it. Older board sizes remain unchanged; their frame and board shift down only enough to clear the shared HUD.

## 5. Story: The Missing Inventory

### Premise

Rocco "Pixel" takes jobs for money and recognition. His partner Sprocket has adapted a pixel-transfer device that separates art into transportable pieces and rebuilds it. Their robot-bug crew does the carrying.

An anonymous client, **the Curator**, orders pieces from Baron Glimmer's private collection. At the end of Chapter 1, Rocco finds his own device on the delivery inventory. He breaks the delivery and keeps the works in his Safehouse gallery. This is the inciting incident, not the final revelation.

Years earlier, a restoration network altered ownership histories. Glimmer finances it through the fictional **Atlas Foundation**. Restorer **Barnaby Bramble** saved the original records and split them into five small archives hidden inside five specific artworks. The inventory is evidence, not a treasure map.

Sprocket's device can read an object's surface, support and added conservation layers only after a full transfer, which is why the whole artwork must be stolen. This is an invented premise, stated once.

The Curator is **Mr. Frost**, a former cultural-asset researcher who wants the archive and the device under his own control. Journalist **Quill** checks claims. All criminal owners and institutions are fictional; real artists and museums are never accused.

### Cast and voice

> **Cast (Halil, 25 Sep 2026):** every story character is a male animal with an English cartoon name — Rocco (ferret), Sprocket (mouse), Quill (barn owl), Mr. Frost (arctic fox), Baron Glimmer (magpie), Tuck (tortoise), Barnaby Bramble (badger). Species, looks and voices: [Characters.md](Characters.md).

| Character | Want and conflict | Where the player meets them |
| --- | --- | --- |
| Rocco "Pixel" | Freedom and recognition; can confuse possession with protection | Win bubbles, Story panels |
| Sprocket | Protect and understand the device | Win bubbles, Story panels |
| Quill | Find and verify an erased history | Story panels from Act II |
| Mr. Frost / the Curator | Control the archive | Coded messages, later direct scenes |
| Baron Glimmer | Protect his status as a collector | Story panels, final confrontation |
| Tuck | Keeps the Safehouse gallery running; teases Rocco's taste | Occasional win bubbles |
| Barnaby Bramble | Deceased restorer who preserved the inventory | Archive fragments |

Humor comes from taste meeting practical trouble; victims and restitution are never punchlines. Examples: Sprocket: "The client asked for something small." Rocco: "They meant the budget." — Sprocket: "You left the frame?" Rocco: "I respect their decorating choices."

## 6. Five acts and twenty chapters

These twenty internal story beats retain their IDs and pair into ten player-facing stages (section 4). Each beat has four heists plus one fixed story milestone. Finale titles are fictional unless identified as real-art interpretations.

| Chapter | Case / atmosphere | Finale artwork | Story result | Puzzle emphasis |
| --- | --- | --- | --- | --- |
| 1 | First Commission — Glimmer's sample collection | Moon Gate Mask | Device appears on the order; Rocco redirects delivery | Three docks, safe waiting |
| 2 | False Owners — private European exhibitions | Water Lilies | Fragment 1; label and history conflict | Small payloads, mysteries, decoys |
| 3 | Lower Threshold — Paris restoration chain | Apples and Oranges | Detect a copied mark | Five docks, bottom-only access |
| 4 | Harbor Collection — fictional Istanbul depots | Shore Ledger | Confirm Atlas's shipping link | Disjoint shapes, narrow openings |
| 5 | Wrong Address — transport collection | Return Ticket | Separate a false label from the true route | Flowing queue reading |
| 6 | Sealed Shipment — harbor archive | Blue Shipping Plate | Fragment 2; the transfer network | Opening inner colors |
| 7 | Silent Auction — private Vienna invitation | Gold-Faced Clock | Buyers' influence; the Curator's old signature | Close hues, queue planning |
| 8 | Unsigned Letter — exhibition designer's storage | Half an Invitation | Quill verifies the signature | Familiar-rule act closure |
| 9 | Two Collections — Amsterdam salons | Double-Labeled Landscape | One record assigned to two objects | Islands, spare-dock planning |
| 10 | Double Entry — restoration archive | Twice-Written Portrait | Fragment 3; Mr. Frost reveals himself | Early inner-color consequences |
| 11 | Missing Voices — family/community archive | Entrusted Chest | Records connect to living people | Calmer color groups |
| 12 | Open Door — closed exhibition depot | Exhibition No. 12 | Rocco's first public showing | Moderate, flowing closure |
| 13 | Polite Threat — Atlas invitation | Silver Card Case | Glimmer attacks Rocco through the press | Mystery packets |
| 14 | Whose Story? — publisher's collection | Before the Press | How testimony was altered | Shorter breathing space |
| 15 | Pressure After Dark — closed exhibition | Closed Window | Fragment 4; beneficiaries identified | Edge rules plus mysteries |
| 16 | The Cost of Trust — preservation network | Three-Key Box | An alternative to Mr. Frost's control | Planned act closure |
| 17 | Missing Page — moving Atlas archive | Cut Album | Destruction order discovered | Inner colors and passages |
| 18 | Last Offer — Glimmer's negotiating room | Untitled Bust | Offer of silence | Short, definite pressure |
| 19 | Final Inventory — private showcase | Study No. 0 | Device's origin in Barnaby's work | Mastery of familiar rules |
| 20 | Whose Museum? — Glimmer's principal collection | Night Atlas | Fragment 5; complete archive; final choice | Authored final queue |

| Act | Chapters | Purpose | Payoff |
| --- | --- | --- | --- |
| I — Commission to Suspicion | 1–4 | Protect the device, question the client | First fragment, independent goal |
| II — Following the Collection | 5–8 | Connect the movement of objects | Second fragment, verified signature |
| III — Whose Past? | 9–12 | Understand the people in the records | Third fragment, Mr. Frost's identity |
| IV — Against the Night | 13–16 | Defend the account, build allies | Fourth fragment, press conflict |
| V — The Last Job | 17–20 | Complete the evidence and decide | Complete archive, definite ending |

## 7. How the story is told

The story lives in exactly three places:

1. **Story screen (S4)** at the start of Chapter 1 and after every chapter finale: three comic panels, one or two speech bubbles each, at most eight words per bubble, always skippable. Fragment chapters (2, 6, 10, 15, 20) end on a five-slot evidence board: "Fragment 2 / 5".
2. **Win bubble on Level Complete (S3):** one line, at most eight words, from Rocco, Sprocket or Tuck, authored per heist (100 lines). A discovered clue is stated here: "That's not the artist's mark."
3. **Painting Detail (P7):** the artwork's title, artist and year, and one factual line. Real-art facts stay separate from fictional allegations.

**Ending.** After the Chapter 20 finale, the Story screen offers three approaches as large cards with one line each: **Open Inventory** (publish everything, including what exposes Rocco), **Custodian Network** (entrust the record to independent researchers and communities), **Final Bargain** (break Glimmer and Mr. Frost through a private deal). This is the game's only story choice. Each has its own closing panels. The Gallery stays playable afterward.

Continuity rules: fragment carriers are fixed; an already-found fact is never withdrawn; Glimmer learns through the press, not omniscience; Barnaby died before the story begins; the device's link to Barnaby is verified in Chapter 19.

**Stage 1 illustrated-scene amendment (28 September, P16-60):** replace the first-launch opening with the new rooftop scene and two approved lines; Start Heist uses the existing opening flag and starts play. After the first Level 10 win, Level Complete Continue opens the new Safehouse discovery scene directly. Its return action claims the existing false_owners chest once, marks the same story ID and returns to Safehouse with the normal reward receipt; it replaces the old completion/prose/fragment navigation for this stage ending. The fragment remains associated with the same Level 10 milestone. The Level 5 milestone/claim and later stages are unchanged. Stage 1 artwork and lines are authored in data/stage_scenes.json and shared with read-only Case File. Replayed wins do not automatically replay the finale.

**Stage 1 speech balloons (29 September, P16-61):** opening/finale dialogue appears in named, tailed speech balloons on the illustration, positioned clear of faces and evidence. Remove the separate text area below the image. Use the same presentation in live S4 and Case File replay; keep the artwork uncropped and navigation outside it.

## 8. Crew

- Ten robot bugs. A new one joins at the end of Chapters 1, 3, 5, 7, 9, 11, 13, 15, 17 and 19, shown on that finale's Level Complete ("New crew member!").
- Bugs are presentation only: name, look, idle animation, one-line bio. They never change capacity, speed, access or rules; colors and numbers stay readable.
- The equipped bug is shown in the Gallery; showing it as the heist scouts and in the Safehouse hero group follows with the crew art (P16-26).
- Drone and carrier-box looks are bought with gold in the Shop.

## 9. Screens and contents

Codes: S = full screen, P = pop-up window. All pop-ups use one template: ribbon title, central image, at most two buttons, close X top right.

### S1 — Safehouse

- **Top bar:** avatar (opens Crew), Energy (heart, "5/10", refill timer), Gold (coin, balance), settings gear.
- **Simplified Safehouse background (29 September, P16-63):** use the approved `assets/lobby/v2/museum_simple.png`: calm navy museum walls, one central pixel painting, Rocco and Sprocket together and one robot bug. Quiet side areas keep the six illustrated shortcuts legible; the lower area supports progress and Play. The Pixel Heist logo stays in the image. Dynamic numbers remain native Lora Bold. This replaces the busy 27 September background in S1 only; the previous image remains available as a historical reference.
- **Progress and Play (P16-65, 29 September):** a wider live level card with ten stage-progress segments and the stage name, next to the illustrated Case File. Start Heist uses a native satin-turquoise button with a thin warm-brass edge, soft depth, title-case Lora caption and compact play symbol. When no authored next heist exists it reads More Soon and is disabled. The reference's example balance/level/progress are never used as player data.
- **Illustrated rewards (29 September, P16-62):** six large frameless satin-enamel object icons with warm brass accents flank the central artwork (P16-64 replaces the ornate medallions): Daily, No Ads and Milestones on the left; Watch Ad, Offers and Star Chest on the right. Titles sit below each silhouette; native captions show actual readiness, level/star requirements, daily ad allowance or ownership. Chests open the reward overview; Watch Ad explicitly invokes the optional rewarded placement; No Ads opens its exact product for review without purchasing. Owned No Ads and exhausted ads are disabled; unavailable offers are hidden. The redundant bronze chest beside the level card is removed (P16-65); Daily, Milestones and Star Chest retain access to the overview. Use a hero treasure image and a two-column grid of six illustrated cards, never the former vertical text menu. No season pass, premium reward track or new screen is added. Preserve claim IDs, stock, caps and quantities; close the overview before opening P4/P5. Event remains hidden.
- **Case File (28 September, P16-60 amendment):** use an image-led stage directory inside S4. Tapping a stage card opens its opening illustration and two short dialogue lines directly; remove the prose dossier/report page. An ongoing case exposes its opening only; completing all ten artworks exposes its opening and finale, derived from stable completion IDs even for older saves without seen-story flags. Previous/Next navigates available scenes; Back returns to the directory, preserving scroll/focus, then Safehouse. Archive viewing never grants rewards or changes saves. This pass authors only Stage 1; other stage cards honestly say Scenes coming soon and cannot open placeholder stories. Their gameplay and internal chapter data remain intact. No new screen identity is added.
- **Bottom tabs (P16-65):** **Shop / Home / Museum**, with colorful satin-enamel object icons and native labels on a quiet navy shelf. Shop uses a teal/coral storefront, Home a teal/petrol safehouse, Museum ivory columns with warm brass and plum accents. Selection uses one subtle teal tile and underline. Case File uses a petrol-blue dossier, ivory papers, coral seal and brass magnifier from the same atlas; the old baked gold folder is replaced. Museum opens the existing S5 Paintings tab; avatar still opens Crew. Stable internal screen/save IDs remain unchanged. Lower controls stay bottom-anchored on tall portrait screens.

### S2 — Heist

**27 September 2026 — red-bee opening:** Each new heist first presents the
unpixelated version of its artwork. A large crimson bee-shaped carrier, seen
strictly from above with its head pointing up and abdomen down, enters from the
bottom edge with beating wings. It hovers in the lower cube-queue area while ten
small red robot bees leave its visible hatch and fly up to the art. Their beams
scan the painting and reveal its pixel board. All ten scouts then fly back into
the same hatch. The carrier waits for the last scout, then exits through the top
edge. Only after departure do the cube drones appear and input/timers begin.
The sequence is part of S2, not a new screen. Duration: about eight seconds,
including the return/collection phase. Pause and app
suspension freeze it. Reduced motion uses a short still-image crossfade. Resuming
an existing heist goes directly to its saved puzzle state. Both presentations
use the same stable artwork ID; source image rights and checksums are recorded
separately from puzzle data. All 100 production works need paired originals and
pixel boards. The existing 15 demo boards remain authored stylizations; this
opening does not regenerate their cell budgets, queues or saves. The first three
legacy works are fictional game art with newly generated detailed images.

- **Top:** Pause (opens P1), slim navy-and-gold "LEVEL 12" plate (no side arrows) with any HARD / SUPER HARD tag, separate free 1×/2× and timed gold 3× chips. The X has the same font size as the numeral.
- **Centre:** ornate gold frame, pixel painting, title on its upper border and thin progress bar above the frame; large ant travel gap; five active platforms and paged three-column waiting queue (section 3).
- **Bottom:** compact three-button icon-only toolbar: Extra Dock, Row Beam, Recall. No labels below the buttons.
- Chapters 1–4 show one-line hand-pointer tips ("Tap to send the ants."). No separate help screen.

### S3 — Level Complete

**28 September celebration update (P16-57):** Present S3 as a centered navy/brass victory card over the museum, using the shared Lora typography and enamel buttons. Rocco and Sprocket celebrate with confident, joyful expressions beside the recovered painting. Stars arrive in sequence, the painting settles into its frame and one short, finite colored-confetti burst celebrates the win. Confetti never covers or intercepts the action shelf. Continue is available immediately. Reduced motion shows the complete static composition without particles or entrance movement; app suspension and overlays freeze the celebration. Reward refreshes do not replay it or grant rewards. Keep the canonical win bubble, distinct new-crew card, saved gold/best-star contract, optional explicitly labeled Watch Ad action and first-milestone Story routing.

- "Level Complete!" ribbon and 1–3 stars.
- The stolen painting flies into its frame; its name below.
- One win bubble (section 7). On crew milestones, the new bug card. Ordinary wins offer View in Museum; first-time story milestones retain Continue to avoid skipping the story.
- Reward row: gold and stars earned.
- Buttons: large "Continue", small "2× Coins" (rewarded ad).

### S4 — Story

- At each five-level milestone: "Halfway There" or "Stage N Complete", the five newly acquired works and a chest → "Open Chest" (P4). Fifth-level rewards are Milestone Chests; tenth-level rewards are Stage Chests, using the same existing claim IDs and amounts.
- Three comic panels, swipe to advance, "Skip" top right.
- Fragment chapters end on the evidence board.
- Last panel names the next level within the stage, or the next stage at a tenth-level boundary → "Continue".
- Chapter 20 shows the three ending cards, then that ending's panels.

### S5 — Gallery

**Shared visual style amendment (27 September, P16-53):** S1 retains its original-art footer component. S5 now uses an upper-left back button instead of a footer (P16-55, approved 27 September). Museum uses dimensional illustrated brass/turquoise controls, stronger warm-gold titles and a lit museum backdrop. All future screen styling follows [ScreenStyleGuide.md](ScreenStyleGuide.md), the shared visual implementation reference; historical flat treatments are superseded.


- Three views inside S5: **Floors / Collection / Crew**. A floor picker lists all ten named stages. Each floor has ten permanent positions in a vertically scrolling, two-column exhibition, read in level order. Frames fit each original artwork's natural aspect ratio without cropping or stretching; a row takes the height of its taller work, with the shorter work centered in that row. The painting itself opens its large detail, so floor cards have no separate View button. Locked artworks with a sourced original stay fully visible with a small lock badge; acquired artworks have no check badge. A slot without an image remains a locked "Coming soon" placeholder. Locked originals can be inspected but cannot be added to the private collection before acquisition. Pixel mode applies where an authored board exists; future works without boards keep their original preview.
- **Museum navigation amendment (27 September):** The upper Floors / Collection / Crew tabs follow the Safehouse materials: continuous navy enamel, fine brass borders and separators, gold icons and lettering, and a turquoise glow/underline for the selected destination. The lower Shop / Home / Museum menu is removed from all three Museum tabs, reclaiming 146 design units for content. A themed upper-left back arrow returns to Safehouse. In Collection Edit it first exits editing and commits the current room name; Photo back first returns to the collection view. Escape follows the same hierarchy, closing an open detail or floor list first. Large touch targets retain hover labels. A single elevator button at the right opens an in-screen, navy-and-brass floor directory below it, replacing the previous/next arrows and native system list. All ten named floors show their number and collected count; the current floor is highlighted and scrolled into view. Selecting a row closes the list and opens that floor at the top; outside tap, close or Escape dismisses it. Browsing never unlocks content. Original/pixel and collection/photo actions remain icon-only. The floor exhibition header is one compact row: a small floor-number badge, stage name and the two view/floor controls. Overall and per-floor collected counts appear only in the floor directory, not as repeated text above the artworks. Photo format remains visible.
- Original artwork is the default. **Show Pixels / Show Originals** switches the floor/collection presentation without changing ownership or progression. In Artwork Detail, the switch replaces only the artwork image inside the existing modal; the frame, information, controls and modal instance stay in place. Preserve each image's aspect ratio. Fictional game artwork remains identified as fiction by its catalog record; do not relabel generated reconstructions as historical originals.
- Collection opens with the first earned work: up to ten distinct, owned works, free addition/removal/reordering. Choose **Spotlight + pairs** (one large first painting above two-column rows), **Two per row**, or **Three per row**. The live room scrolls to preserve artwork size; Photo Mode fits the same saved arrangement to its output. Edit uses the actual room preview: tap one painting then another to swap, or use earlier/later/first-position controls. The first position is the spotlight; there is no hidden reorder overriding the visible sequence. Owned works can be added below the room preview. Choosing a work never removes its permanent museum copy. Save stable art IDs, order, layout ID, a 1–32 character room title and one of the midnight/emerald/burgundy themes. Legacy rooms retain their featured painting first when adopting the default spotlight layout. Failed saves must not show unsaved state as committed. Edit, Photo and view controls occupy a separate shelf at the bottom with a 28-unit inset; top-tab underlines clear their captions. Painting Detail uses the shared navy/turquoise enamel button component, including Play again and Close.
- **Photo Mode** is a clean room view within S5. Offer original/pixel and 4:5 (1080×1350) / 9:16 (1080×1920) compositions. Render an offscreen PNG containing only room, artwork, title and a small Pixel Heist signature; no controls, wallet or private identifiers. Adapt the layout to fewer than ten works instead of exporting empty locks. Player chooses the save destination. Native mobile sharing requires an actual platform adapter/device test; desktop PNG export is not claimed as native sharing. No auto-posting or progression reward for sharing.
- Crew retains its ten unlocks and equipped IDs, with unlocks labeled by level rather than internal chapter. It uses a vertically scrolling list of spacious navy/brass cards, individual canonical robot-bug portraits, names and short bios. Locked cards show the required level; unlocked cards offer Equip and the selected member is marked Equipped. Selection persists only after a successful save.

### S6 — Shop

- Gold balance at the top. Sections: featured offer, "No Ads", "Coins" (four packs), "Boosters" (gold), "Looks" (drone and box looks, gold). Small "Restore Purchases" at the bottom.

### P1 — Settings

**28 September style/UX update (P16-56):** Use the shared navy/enamel modal, Lora typography and four large, labeled switches with short descriptions. Each switch updates in place after a successful save; failed writes restore the previous state. Done and Close dismiss Settings. Pause keeps Resume as its primary action, a separate Safehouse action displaying the −1 energy cost, and the two legacy boosters. Do not show inactive Privacy/Support text as working links.

- Sound, Music, Vibration, Reduced Motion toggles and version. Add Privacy and Support links once their real pages exist.
- Opened from a heist it is titled "Paused" and shows "Resume" (large) and "Safehouse" with "−1 energy".

### P2 — Out of Space

- Small picture of the jammed docks, "Out of space!".
- "Continue +1 Dock" (900 gold), "Watch Ad" (once per heist), small "Retry" and "Home" (each −1 energy).

### P3 — Out of Energy

- Empty heart, "Next energy in 12:40". "Refill" (900 gold), "Watch Ad" (+1 energy), X.

### P4 — Reward

**28 September reward celebration (P16-58):** After a successful grant, P4 plays one short colored-confetti burst and a small chest pop, reusing the Level Complete palette. The effect stays below the title/daily strip and above Collect; all controls are immediately available. Reduced motion is static, app suspension freezes the effect, and the finite animation stops after 3.2 seconds. Dismissal cleans it up and never grants an additional reward.

**28 September style/UX update (P16-56):** The existing Safehouse Rewards tray becomes a dismissible navy/brass overlay with illustrated cards in two columns (P16-62 supersedes the former rows): Daily, Star chest, Milestone chest, explicit Watch Ad for free coins, Offers and No Ads. Show ready, claimed, locked/progress, fully collected and daily-cap states; unavailable claims are disabled. Outside tap, Close and Escape return focus to the exact opening shortcut; background controls cannot receive keyboard focus while the overview is open. P4 shows the seven-day daily strip when relevant and a receipt of actual gold, grouped booster quantities and purchased entitlements/energy. Collect acknowledges an already committed grant; it never grants twice. No automatic ad or real purchase is introduced.

- A chest opens and rewards fly out. The daily version shows a seven-day strip. "Collect".

### P5 — Offer

- One template for Starter Pack, timed Special Offer and No Ads: pack art, content icons, remaining time if any, price button, X.

### P6 — Get Booster

- Booster art, name, one line on its effect, buy for 300 gold, X.

### P7 — Painting Detail

- Large original painting, title, artist/year and one factual line; original/pixel switch, Add/Remove from Collection and Open Collection. An owned artwork with an authored heist board has a **Play Again** button: it starts a fresh heist for that same stable artwork ID, with the existing energy gate and replay rewards. Locked previews and originals without playable boards have no replay button. Photo Mode exports the room as an image; copying a text line is not image sharing.

## 10. Navigation

The main loop: Safehouse → Play → Heist → Level Complete → Safehouse; after each chapter finale, Level Complete → Story → Safehouse.

| From | Action | To |
| --- | --- | --- |
| S1 Safehouse | Play (energy > 0) | S2 Heist |
| S1 Safehouse | Play (energy 0) or energy bar | P3 Out of Energy |
| S1 Safehouse | Avatar | S5 Gallery, Crew tab |
| S1 Safehouse | Gear | P1 Settings |
| S1 Safehouse | Any ready chest | P4 Reward |
| S1 Safehouse | Offers / No Ads icon or reward card | P5 Offer (selected product, no automatic purchase) |
| S1 Safehouse | Watch Ad icon or reward card | Rewarded ad → P4 Reward |
| S1 Safehouse | Gold bar or Shop tab | S6 Shop |
| S1 Safehouse | Museum tab | S5 Gallery, Paintings tab |
| S1 Safehouse | Case File | S4 stage cards → available opening/finale pictures → stage cards → Home (Stage 1 authored) |
| S2 Heist | Pause | P1 Settings (Resume / Home −1 energy) |
| S2 Heist | Booster with zero stock | P6 Get Booster |
| S2 Heist | Last pixel delivered | S3 Level Complete |
| S2 Heist | Docks jammed | P2 Out of Space |
| P2 Out of Space | Continue (gold or ad) | S2 Heist with +1 dock |
| P2 Out of Space | Retry / Home | S2 Heist restarted / S1 (−1 energy each) |
| S3 Level Complete | Continue | S1; after a chapter finale, S4 Story |
| S4 Story | Open Chest → Continue or Skip | P4 → S1 |
| S5 Gallery | Tap painting | P7 Painting Detail |
| P7 Painting Detail | Play Again (owned playable artwork, energy available) | S2 Heist for the same artwork |
| P7 Painting Detail | Play Again (no energy) | P3 Out of Energy |
| S6 Shop | Price button | Platform purchase sheet → confirmation toast |
| P3 Out of Energy | Refill / Watch Ad | S2 Heist |

Back returns to the Safehouse from normal screen views. Within Museum, close an open detail/floor list or exit Photo/Edit first; another back then returns to Safehouse. No screen stacks more than one pop-up. Nothing opens over an active heist except P1, P2 and P6.

## 11. First session

1. First launch skips the Safehouse: a one-panel Story (Rocco: "Five paintings. One night." / Sprocket: "Let's go.") → Heist 1.
2. Heist 1: hand pointer, "Tap to send the ants."
3. Level Complete → the Safehouse opens for the first time with Play glowing.
4. Heist 2: "?" packet tip. Heist 3: "Colors can wait." (sealed colors).
5. Heist 4: two free Extra Docks with a toolbar pointer.
6. Heist 5: first chapter finale → Story, chest, first crew member.
7. Chests and Shop badges appear after Heist 5. No ad or offer before Heist 8.

## 12. Economy

One currency (gold), energy and five compatible booster stocks (three on the gameplay toolbar; two legacy powers in Pause). Starting values; tune after playtests.

| Item | Starting value |
| --- | --- |
| Energy | Max 10; +1 every 20 minutes; −1 only on failure, Retry, or Home from a heist |
| Win reward | 40 gold normal, 80 HARD, 120 SUPER HARD; replays pay 10 |
| Stars | 1–3 per win (section 3); only the best result per heist counts |
| Booster | 300 gold each |
| Continue in P2 | 900 gold or one rewarded ad per heist |
| Energy refill | 900 gold for a full bar; rewarded ad for +1 |
| Star Chest | Opens every 10 new stars: gold + 1 booster |
| Milestone / Stage Chest | Every fifth / tenth level: existing gold + 2 boosters |
| Daily chest | Seven-day cycle; day 7 is the large chest |

Starting grants: 200 gold at first launch and two Extra Docks at Heist 4 (section 11). Paid gold never buys story access, clues or the ending.

## 13. Ads

Food Hunt's most common complaint is ads after every level, so frequency is capped.

- **Rewarded (always optional):** 2× Coins on Level Complete, Continue in P2, +1 energy in P3, Watch Ads for 50 gold (at most 5 per day).
- **Interstitial:** only after a win, from Heist 8, at most once every two heists and every three minutes. Never after a failure, during a heist, or before Story.
- A reward is granted once, from the provider's verified reward event, never merely from closing the ad. Offline or failed ads never block the main flow.
- Gameplay, audio and timers pause while an ad plays.
- **No Ads** removes interstitials only; rewarded ads stay optional.

## 14. Purchases

Prices are the Turkish App Store tiers used by Food Hunt, kept as a starting reference; the platform shows the localized price.

| Pack | Contents | Price (TRY) |
| --- | --- | --- |
| Starter Pack | 1,000 gold, 2 of each booster, 1 hour unlimited energy; once per player | 49.99 |
| Coins S | 1,200 gold | 99.99 |
| Coins M | 6,000 gold | 399.99 |
| Coins L | 14,000 gold | 799.99 |
| No Ads | Removes interstitials | 399.99 |
| No Ads Pack | No Ads + 3,000 gold + 3 of each booster | 499.99 |
| Special Offer | Timed: gold + boosters + one drone look | 249.99 |

- Contents are fixed and shown before purchase; no random loot.
- Purchase goes through the platform sheet. Pending, success, cancellation, failure and restore are handled separately. Permanent items (No Ads, looks) restore on reinstall.
- Build against a provider interface with a fake provider first. Tests never make real purchases.
- A season pass is out of scope for launch because it needs its own screen.

## 15. Visual, sound, and text rules

1. Titles at most three words; at most one explanatory line per screen, at most ten words; button labels one or two words.
2. Numbers appear with icons ("+50" with a coin), never as sentences.
3. Story text appears only in S4 and the S3 win bubble (section 7).
4. Visual language comes from the Safehouse: copper and brass round buttons, wood and metal panels, the museum hall background, gold lettering. No flat navy form panels.
5. Pop-ups follow the template in section 9.
6. Nothing pops up over an active heist except P1, P2 and P6.
7. Keep quiet rotors, soft wooden pickup notes, the upbeat adventure music (optional), vibration and reduced motion.

Material, lighting and motion details remain in [VisualDirection.md](VisualDirection.md) where they do not conflict with this section.

## 16. Language and identity

**All player-facing text is English only** (Halil, 25 September 2026): menus, HUD, buttons, story, dialogue, notifications, store items and text inside new art. The game does not follow the device language and has no language selector. Conversations with Halil stay in Turkish; this rule covers game content only.

The existing tr/es/de catalogs stay in the repository but are not shipped or maintained. English strings keep stable localization keys so content never depends on display text.

| Stable character ID | Display name | Role |
| --- | --- | --- |
| `rocco` | Rocco “Pixel” | Player thief |
| `sprocket` | Sprocket | Technical partner |
| `quill` | Quill | Journalist |
| `frost` | Mr. Frost | Curator / client |
| `glimmer` | Baron Glimmer | Atlas collector |
| `tuck` | Tuck | Safehouse gallery keeper |
| `barnaby` | Barnaby Bramble | Deceased restorer |

Persist `art_id`, `chapter_id`, `character_id`, `crew_id`, `booster_id` and `product_id`, never display text.

## 17. Saves and migration from r12

- Keep the atomic primary/mirror save and mid-heist resume from P02. Resume never duplicates a reward.
- Completed heists map to the linear order by `art_id`. The first incomplete heist becomes the next Play.
- Every artwork ever acquired appears in the Gallery, whatever its r12 disposition (kept, sold, returned, loaned or stored).
- r12 credits convert 1:1 to gold. The boost budget, path points, contact trust, news, labels and notes are ignored but left in the file.
- New persisted state: gold, energy and its timestamp, booster stock, stars per heist, chest progress, equipped crew and looks, purchase entitlements, daily-chest day, interstitial counters.
- Tests use isolated saves and never touch the player's `user://progress.cfg`.

## 18. Engineering and release boundary

[ToDoList.md](../ToDoList.md) defines phases and tasks; phase **P16** implements this revision and supersedes conflicting pending tasks in earlier phases.

- Platforms: portrait iOS and Android; macOS is the development host. Godot 4, GL Compatibility renderer.
- The core game must work offline; ads and purchases degrade gracefully.
- Purchases and ads use provider interfaces with fake providers until real SDK integration is separately approved.
- Removed r12 systems (target selection, inspection, disposition, paths, news, case file, memory studio, workshop, exhibitions) are deleted from runtime code in P16, with save migration first.
- AI workflow: read `AGENTS.md`, this file and `ToDoList.md`; implement the selected P16 task; validate; update both checklists.

P16 implementation status and evidence: [P16-Implementation.md](P16-Implementation.md). Chapters 4–20 have story, finales and win lines, but their 85 heist puzzles and artworks still need production; until then the Safehouse shows "More heists coming soon!" after Level 15 (midway through Stage 2).

Earlier implementation records remain valid history for what was built: [P01](P01-Implementation.md), [P02](P02-Implementation.md), [P03](P03-Implementation.md), [P04](P04-Implementation.md), [P05](P05-Implementation.md), [P06](P06-Implementation.md), [P07](P07-Implementation.md), [persistence](Persistence.md), [rendering decision](RenderingDecision.md).

For purchase and restore rules consult [Apple In-App Purchase](https://developer.apple.com/in-app-purchase/) and [Google Play Payments](https://support.google.com/googleplay/android-developer/answer/9858738?hl=en). [Google's rewarded-ad guide](https://developers.google.com/admob/android/rewarded) describes test ads and verified reward events. The design reference is [Food Hunt: Pixel Puzzle](https://apps.apple.com/tr/app/food-hunt-pixel-puzzle/id6769314786).
