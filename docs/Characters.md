# Pixel Heist — Characters (canonical cast)

Decided by Halil, 25 September 2026. This file is the single source of truth for who the characters are, what they look like and what they are called. Read it before writing story text, win bubbles, dialogue, art prompts or character code.

## Rules

1. **No humans.** Every story character is an anthropomorphic animal. The heist crew are small steampunk robot bugs.
2. **All characters are male** (Halil, 25 Sep 2026). Use he/him in all story text, bubbles and art prompts.
3. **English cartoon names.** Short, easy to read in any country, animated-film tone. Never Turkish or real-person names.
4. **Roles and the story do not change.** Only who the characters are changed; the plot in `GameDesign.md` sections 5–6 stays.
5. **Scale:** the animals are the size of a small animal in a human-sized museum; the robot bugs are palm-sized to them. Sprocket builds and repairs the bugs.
6. **Keep every look consistent** across panels, portraits, icons and marketing. Use the visual specs below word for word in art prompts.
7. Before store launch, run a trademark and app-store search on every name.

## Main cast

| ID | Name | Species | Role | Personality and voice |
| --- | --- | --- | --- | --- |
| `rocco` | **Rocco** ("Pixel") | Ferret | The player's thief | Nimble, curious, cocky, dry humour. Wants freedom and recognition; can confuse possession with protection. Short confident lines. |
| `sprocket` | **Sprocket** | Mouse | Technical partner; built the pixel-transfer device and the robot bugs | Brilliant, nervous, talks fast, worries about the device. Protects and wants to understand it. |
| `quill` | **Quill** | Barn owl | Journalist (story panels from Act II) | Calm, precise, sees in the dark, always taking notes. Finds and verifies an erased history. |
| `frost` | **Mr. Frost** | Arctic fox | The anonymous client "The Curator" | Polite, elegant, cold, never raises his voice. The hidden antagonist. |
| `glimmer` | **Baron Glimmer** | Magpie | Private collector (Atlas collection) | Vain, pompous, hoards shiny things. Protects his status; final confrontation. |
| `tuck` | **Tuck** | Tortoise | Keeps the Safehouse gallery running | Slow, calm, teasing about Rocco's taste. Occasional win bubbles. |
| `barnaby` | **Barnaby Bramble** | Badger | Deceased restorer, remembered only | Wise old master; the evidence fragments carry his marks. Never appears alive on screen. |

"Pixel" is Rocco's nickname and ties him to the game title. The Curator is Mr. Frost's alias until the story reveals him.

## Visual specs (use in every art prompt)

- **Rocco:** male anthropomorphic ferret standing upright, slim and agile, cream and chestnut-brown fur, dark bandit-mask marking around bright amber eyes, a slightly darker chocolate-brown tuft of fur on his head (natural fur colours only, never unnatural hair colours), fitted charcoal stealth suit, copper utility belt, brass goggles pushed up on his forehead, sly confident grin.
- **Sprocket:** male anthropomorphic grey mouse, smaller than Rocco, big round ears, oversized round brass-rimmed glasses, pink nose, olive tool vest full of tiny screwdrivers, often holding the brass-and-copper pixel-transfer gadget that glows cyan; excited or nervous expression.
- **Quill:** male barn owl with a heart-shaped white face and golden-brown wings, small round spectacles, a satchel and a notebook, a pencil tucked behind a feather tuft.
- **Mr. Frost:** male slender white arctic fox, pale blue eyes, long elegant silver-grey coat with a high collar, gloves, thin cane, calm half-smile; often in shadow.
- **Baron Glimmer:** male black-and-white magpie with iridescent blue-green wing sheen, monocle, velvet waistcoat, gold chains and rings, puffed-up chest.
- **Tuck:** male old green tortoise, round spectacles on the tip of the beak, knitted mustard cardigan, brass picture-hanging spirit level, patient smile.
- **Barnaby Bramble:** male grey-and-white striped badger, work apron with paint and varnish stains, magnifying loupe; shown only in old photos, sketches or memories (sepia tones).

**Art style:** stylized animated-film look, painterly digital art with clean ink outlines, rich colours. Night museum palette: deep cobalt-blue shadows, warm golden spotlights, copper and brass details (matches the Safehouse and `VisualDirection.md`). Story panels contain no text or speech bubbles; the game draws the bubbles. Leave empty space in the top third of each panel for them.

## Robot bug crew (unchanged)

Palm-sized steampunk robots with copper bodies and green glass eyes, unlocked one every second chapter. Names and bios live in `data/chapters.json` (`crew`): Bit (ladybug), Dash (dragonfly), Gizmo (beetle), Hum (bee), Flicker (firefly), Pinch (stag beetle), Skitter (cricket) and the rest. The carrier ants in heists are the same robot family.

## Old to new mapping

| Old ID | Old name | New ID | New name |
| --- | --- | --- | --- |
| `ada` | Ada "Pixel" Vale | `rocco` | Rocco ("Pixel") |
| `milo` | Milo Reed | `sprocket` | Sprocket |
| `nora` | Nora Quinn | `quill` | Quill |
| `evelyn` | Evelyn Vey | `frost` | Mr. Frost |
| `victor` | Victor Voss | `glimmer` | Baron Glimmer |
| `robin` | Robin Shaw | `tuck` | Tuck |
| `mara` | Mara Bell | `barnaby` | Barnaby Bramble |

**Status (25 Sep 2026):** renamed everywhere in the active project — IDs, names and pronouns in `GameDesign.md` (+ Turkish companion), `tools/build_chapters.py` → `data/chapters.json`, `data/levels.json`, `data/content_ids.json`, localization and UI scripts. Historical notes (`docs/0x-*`, `docs/P0x-*`, `docs/archive/`) keep the old human names as a record.

## Approved art (Higgsfield, GPT Image 2.5, medium, 2K, 4:5)

Chapter 1 panels approved as the style reference (25 Sep 2026) and shipped in the game as `assets/story/ch01_opening.jpg` and `ch01_1–3.jpg` (1024×1280, originals in `art_review/story/`). Generate new panels with the opening panel as an image reference so the characters stay consistent.

| Panel | Higgsfield job ID |
| --- | --- |
| Opening (Rocco + Sprocket, museum hall) — style reference | `316c5ce8-34b0-46da-99e4-98598e4ef086` |
| Ch.1 outro 1 — delivery manifest | `3b8ac47a-9fe6-4162-9102-ed92ff2d9b88` |
| Ch.1 outro 2 — Florence rooftop, Curator silhouette | `e9c2defa-a377-4752-b399-0c3b5625a0f0` |
| Ch.1 outro 3 — Safehouse gallery with Tuck | `a53459ee-37b4-4f26-b6a5-56dd918c0d88` |
