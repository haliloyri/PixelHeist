# Level Complete celebration — P16-57

28 September 2026. S3 keeps its existing screen identity and saved win flow.
The shared navy/brass card, Lora type and enamel actions replace the old wood
panels. The acquired painting, canonical bubble, truthful reward row and crew
unlock remain. Optional ads say Watch Ad; first-time milestones retain Story.

Rocco and Sprocket celebrate with one finite 84-piece confetti burst, staggered
stars and gentle painting/portrait entrances. Continue is immediately available.
Particles use a private seeded RNG and never reach the action shelf. Animation
stops after 3.2 seconds; suspension/overlays freeze it, reward refresh does not
restart it, and reduced motion is fully static. No reward, save or ad rules change.

P16-57 is complete. Evidence:
`artifacts/validation/level-complete-final-20260928/summary.json`.

- Planning, localization, chapters, Godot import and the main scene passed.
- Four isolated suites passed with zero failures: 32 Level Complete checks,
  24 motion checks, 353 flow checks and 72 store checks (481 total).
- Tests cover early Continue availability, canonical speaker and saved reward,
  one-star and best-rating replay states, suspension/overlay freeze/resume,
  finite particle cleanup, static reduced motion, new crew/Story routing,
  optional ad cancellation/success/duplicate callbacks, responsive bounds and
  the Museum destination. Existing end-to-end real-flight wins still pass.
- Ten GPU captures at 720×1280 and 390×844 cover burst/settled, crew unlock,
  reduced motion and replay. Representative frames were visually inspected;
  character/title separation and the empty secondary shelf were refined.
- 84 deterministic animation frames at 24 fps; preview:
  [victory-preview.mp4](../artifacts/validation/level-complete-final-20260928/victory-preview.mp4).
  The burst has ended by the final frame. No player saves were reset.

Actual phone safe areas, performance and touch acceptance stay in P16-29.
Next phase remains P16; no release or external service work is included.

## Artwork production

Built-in ImageGen; true transparent output, copied into the project:
[victory_duo.png](../assets/ui/complete/victory_duo.png).
Reference: approved `assets/story/ch01_opening.jpg`.
Original generated file: `exec-f7d8b127-b8b7-4b56-91df-8b68b0978148.png`.

### Exact prompt

Use case: stylized-concept. Asset type: transparent production game celebration overlay, wide landscape 2:1 composition. Input image 1 is a CHARACTER IDENTITY AND RENDERING STYLE REFERENCE only, not an edit target. Draw these same two characters celebrating a successful art heist, as two separate waist-up figures on the far outer sides, Rocco on far left and Sprocket on far right. The central 42% of the canvas must remain completely transparent and empty for a separately rendered painting. No hands, props or bodies extend into that empty middle. Both characters face slightly inward and look proudly toward the viewer, bright victorious smiles, one raised fist each near their own shoulder, expressive happy eyes, a clear WE DID IT feeling. Rocco: male anthropomorphic ferret standing upright, slim and agile, cream and chestnut-brown fur, dark bandit-mask marking around bright amber eyes, a slightly darker chocolate-brown tuft of fur on his head (natural fur colours only, never unnatural hair colours), fitted charcoal stealth suit, copper utility belt, brass goggles pushed up on his forehead, sly confident grin. Sprocket: male anthropomorphic grey mouse, smaller than Rocco, big round ears, oversized round brass-rimmed glasses, pink nose, olive tool vest full of tiny screwdrivers, often holding the brass-and-copper pixel-transfer gadget that glows cyan; excited or nervous expression. Here he is excited and delighted, holding the gadget low beside his vest and raising his other fist. Match the supplied character identities exactly. Stylized animated-film look, painterly digital art with clean ink outlines, rich colours. Night museum palette: deep cobalt-blue shadows, warm golden spotlights, copper and brass details. Dimensional, lovingly painted game art. Complete silhouettes with generous 5% outer padding, all ears, raised paws and gadget visible, clean waist-up cutoffs. No background, no floor, genuine alpha transparency. No frame, painting, confetti, insects, humans, text, speech bubbles, letters, logos or watermark. Do not render a checkerboard.
