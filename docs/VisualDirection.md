# Pixel Heist — visual direction and reference study

Document: `PH-VISUAL` · Revision: `2026-09-25-r13` · Language: `en`  
Companion: [Türkçe](VisualDirection.tr.md) · Canon: [GameDesign.md](GameDesign.md) · Tasks: [ToDoList.md](../ToDoList.md)

## 1. Required direction

The user requests three-dimensional-looking artwork pixels, scouts, carrier boxes, and collection rooms; the feeling of walking inside a three-dimensional Night Museum; an engaging main entrance; a strong completion celebration; lively, playful pop-culture character; and proper game modals. These are base-game requirements, not optional post-launch polish. P03 now supplies isolated dimensional prototypes and screen/motion studies. P05 integrates production heist/crew, entrance, return, reconstruction, success and modal presentation. The existing playable demo is preserved; P07 integrates the perspective museum with physical room depth, thick frames, spotlights, recessed elevators and full/light rendering tiers.

Working art direction: **a colorful designer-toy heist adventure at night**. Rounded enamel drone bodies, chunky collectible pixels, cobalt and purple night architecture, warm museum spotlights, punchy sticker-like headlines and witty crew details. Keep the art recognizable and the heist mysterious. Contemporary collectible toys, comic covers, street-art typography and retro gadgets provide visual vocabulary; use original motifs and characters rather than licensed franchise imagery or short-lived memes.

## 2. References actually examined

Reviewed 20 September 2026. This is a qualitative visual study, not a claim about retention, revenue, or the full installed gameplay of these products.

| Reference / evidence | Observation or publisher description | Pixel Heist application |
| --- | --- | --- |
| Local `sc/unnamed.webp`, visually inspected | Raised colored tile tops and sides, soft contact shadows, rounded tray, large capacity numbers, distinct active/rear positions | Preserve the decision hierarchy while giving pixels and carriers visible volume |
| [Toon Blast official App Store listing](https://apps.apple.com/us/app/toon-blast/id1176027022), screenshots visually inspected | Beveled colored cubes, separated playfield/HUD, expressive character art and bold short promotional typography | Rounded readable pieces and lively illustrated framing; keep the puzzle's own rules |
| [Match Factory on Peak's official games page](https://www.peak.com/games), linked official icon visually inspected | Toy-like specular surfaces, rounded yellow duck, pink/cyan separation and visible material depth; the publisher describes a 3D matching game | Drone and pixel material study; the icon is not evidence of its in-game modal behavior |
| [Royal Match official world-design page](https://www.dreamgames.com/games/royal-match) | Publisher describes curved, polished forms and a colorful world combining retro styling with contemporary details | Cohesive prop, room and character language across screens |
| [Royal Kingdom official world-design page](https://www.dreamgames.com/games/royal-kingdom) | Publisher describes lively colors and playful environmental details | Distinct rooms that feel like places, while keeping art and paths readable |

Dream Games pages were read as official descriptions; their linked CDN images were unavailable for visual inspection. No claim is made that their actual victory or modal flow was played. The modal and success specifications below are original Pixel Heist proposals. Local `artifacts/gallery-detail.png` was inspected as an older demo example: dark overlay and plain stacked text explain why adding only a border would not meet the new request.

## 3. Materials, lighting and color

Provisional interface tokens: midnight ink `#17213F`, cobalt `#4775FF`, electric cyan `#3EDDE6`, coral `#FF6B83`, warm gold `#FFC857`, warm paper `#FFF4DF`. Night rooms use bright accents and warm pools of light, not near-black flat panels. Large neutral surfaces protect artwork colors. These tokens style the interface, not the puzzle palette; each artwork retains its authored matching colors.

Use a consistent key light, darker side faces, restrained highlights and soft grounding shadows. Avoid a white hotspot that makes two task colors look identical. Gloss is broad and soft; numbers have a stable high-contrast face. Rounded depth must remain visible on the smallest supported phone. Decorative glows, city patterns and particles sit below interaction priority.

## 4. Rendering decision and puzzle objects

Keep the existing deterministic 2D puzzle state, routes, reservations and save semantics. Separate presentation from logic. P03 compared real-time 3D geometry with procedural 2.5D board/crew drawing and measured a true perspective room. It selects real-time 3D board/crew and museum, with native localized UI. The 2.5D candidate was vector drawing, not an optimized sprite atlas. See [RenderingDecision.md](RenderingDecision.md) for costs, original art tokens and the separate mobile/device budget gate. A plain flat rectangle with a gradient does not meet the visual requirement.

- **Pixels:** shallow beveled blocks with top/side faces and contact shadows. Removing one reveals the tray below. Lift has vertical separation, a changing shadow and a magnetic attachment point; it does not reopen or duplicate the logical cell.
- **Scouts:** readable top silhouettes with body height, rotor pods, material highlights and an attached lifted pixel. Visual flight height never grants permission to cross an occupied cell or forbidden edge. Preserve current slow motion and ASMR.
- **Carrier boxes:** the whole selectable object is a volumetric carrier drone, with a large numeric face. Queued and waiting bodies have folded rotors. Rotors open only on the first scout launch. Zero payload triggers the existing camera-ward rise and side exit; the dock becomes reusable at final delivery.
- **Projection:** use near-top-down framing for the board; perspective must not hide cells, timers or numbers. Decorative extrusion must not imply a new lane or alter hit targets. Check all five docks, mystery packets, sealed colors and bottom-only entry.

## 5. Night Museum navigation

Preferred prototype: a stylized 3D room with first-person camera travel on a controlled horizontal route. Five framed positions and elevators at both ends remain. The player moves along the corridor, approaches a selected artwork, and enters an elevator; no visible thief avatar and no compulsory free-camera/joystick game.

Depth cues must work together: floor/wall junctions, frame thickness, changing perspective, near/far parallax, spotlights, doorway depth and camera approach. A single background sliding behind flat cards is insufficient. Close the art view by returning the camera to its previous corridor position. Preserve floor, focus, ownership and the selected empty frame across navigation.

Use short eased travel, limited rotation and no default head bob/shake. Reduced motion replaces travel with a short fade or immediate viewpoint change while retaining depth in the still scene. Low-quality presentation may reduce shadow/reflection cost but must keep a readable room and camera-based spatial experience. Prototype performance before multiplying rooms across ten floors.

## 6. Entrance and completion choreography

**S01 entrance:** an original dimensional logo, a small museum/rooftop diorama, one slowly hovering signature drone carrying a pixel, city lights and the player's latest exhibit. One strong Play/Continue button plus Museum and settings. Idle animation must not delay input or become another forced intro. Demo level selection remains accessible.

**S08 completed heist:** after persistent completion, the last delivery settles, the artwork receives a short hero reveal, a dimensional “Heist complete!” badge arrives, two drones cross the edges carrying pixel confetti, then the base payment and Continue action settle. Aim for an initial two- to three-second flourish with early skip; reduced motion shows the completed composition directly. Use a soft musical resolution and restrained chimes, not a shrill fanfare that overwhelms the ASMR identity. Effects must never cover the primary action or require waiting for a particle queue.

**S18 campaign ending:** use the player's actual room and exhibition as the celebration, with the chosen outcome and a shareable personal portrait. It should feel larger than an ordinary job without recycling an unrelated generic trophy scene. Use only earned labels and rewards.

## 7. A game-specific modal family

Build a reusable shell with themed variants, not a generic full-screen dark text layer. Include a dimensional frame/surface, illustrated header, object preview or character medallion, concise hierarchy, tactile primary button, quieter secondary action, and a clear close control. Dim or lightly defocus the room behind it; keep expensive blur optional.

Variants: **briefing** as a gadget dossier; **art inspection** as a lit framed exhibit with readable scrollable facts; **news** as a playful clipping; **success** as a drone delivery badge; **settings** as a compact equipment panel; **disposition/purchase** as an explicit consequence card. Their buttons, shadows, typography and spacing belong to one family.

Prototype modest 180–240 ms entry/exit with a soft settle. Disable motion when requested. Pause the puzzle/timers as appropriate, prevent click-through, retain keyboard focus, support Back/Escape and return focus to the triggering control. Scroll long content inside the modal while preserving actions. Validate all four languages and safe areas. A playful frame must not obscure sale consequences, real prices, errors or eligibility reasons.

## 8. Acceptance and sequencing

P03 establishes art tokens, high-fidelity home/heist/museum/modal/success mockups and rendering prototypes. P05 implements tactile pieces, crew, entrance, success and modal components. P07 implements the museum camera/room experience. P08 is the visual acceptance gate before bulk artwork production. P10/11 extend the language to sharing and asset production; P13 checks performance, motion and localization on devices.

Acceptance requires stills **and motion captures**: stills demonstrate material depth; motion demonstrates pickup, perspective travel, modal feedback and celebrations. Compare a board, a five-carrier layout, a room approach, an elevator, a long translated modal, the main entrance and success. Validate both normal and reduced-motion/low-quality presentation. Existing logical test results must remain unchanged for identical inputs. Visual reference approval from P01 preserves interaction hierarchy, not the old flat art style.

**Heist v2 — "Bit's night heist" (S06), same revision:** the play screen alone restyles to a
Royal Match/Toon Blast-toy language: thick white-plus-dark contours, rounded corners, no gameplay
change. Backdrop is a lavender-to-pink vertical gradient (`#C9C3F0` to `#F3D6E8`) with the level's
own pattern at ~8% tone-on-tone opacity, slow corner stars (static under reduced motion) and 1-2
data-driven museum silhouettes per side (never hardcoded per city). HUD: a round purple (`#8E7CE0`)
pause button, a puffy gold ribbon reading `ui.level_badge` ("LEVEL {n}") with the artifact title
small underneath, a chunky rounded progress pill with three gold (`#FFBD0D`) milestone stars at
33/66/100% (the underlying `ProgressFill`/`ProgressLabel` values are untouched), and a sky-blue
(`#3BA7F0`) speed pill. The artifact frame widens to ~92% of the screen (662px) as a glossy rounded
gold frame with a soft top glow. Scouts become "Bit" ladybugs (`bug_design.gd`, and a matching
low-poly mesh in `volume_factory.gd`/`depth_heist.gd` for the 3D path): red pixel-tiled dome shell,
black robber mask, big LED eyes, two-frame walking legs instead of flight height/shadow growth, and
no magnetic grabber line. Carrier drones (`drone_design.gd`) become rounded enamel capsules with an
oval capacity screen, a glass dome that gains tiny stashed-Bit silhouettes as a run fills, three
landing legs, and two side-folding arms (one rotor each) that stay folded in the queue/waiting dock
and open toward departure. The toolbar becomes a puffy lavender bar (`#9D95CF`/`#7D76AA`); its three
round buttons keep their icons and can show a small gold booster-count badge, drawn only when a
button actually represents one. All new colors live once in `data/design_tokens.json`'s `heist_v2`
block, read through `game_theme.gd`; every other screen keeps the original night palette. Reference:
`artifacts/artifacts/heist-v2-level1.png` (approved Higgsfield Level 1 mock). Touch targets
(`queue_layout.gd` dock/front geometry) and all puzzle logic are unchanged.
