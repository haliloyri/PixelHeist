# Red-bee heist opening — 27 September 2026

P16-35 implements the requested sequence inside S2: detailed artwork, a flapping
crimson robot-bee carrier, exactly ten released scouts, warm conversion beams,
the existing pixel board, carrier/scout departure, then the cube queues.

## Runtime and content

- `scripts/ui/heist_intro.gd` owns a deterministic 8.3-second presentation timeline.
  The top-down carrier enters from the bottom, facing up. It hovers at the
  middle front-row queue anchor (including tall-screen offset) while ten scouts
  fly to the painting, scan it and return into the same abdominal hatch. Only
  after all ten are inside does the carrier leave through the top edge.
  The body is a generated transparent sprite; wings and beams animate in Godot.
  No SDK, external service or network is used while playing.
- Fresh heists run the intro. Resumed checkpoints bypass it. Pause, background
  suspension and save failures freeze progression. Deployment, boosters, speed
  and queue paging cannot affect gameplay during the intro. Puzzle clocks start
  after the overlay completes. Reduced motion uses a 1.4-second crossfade.
- `data/artwork_images.json` maps all 15 existing stable artwork IDs to bundled
  sources and SHA-256 hashes: 12 public-domain reproductions and three generated
  fictional objects. Original images are preserved; no historical painting was
  synthesized. Commons page previews are sufficient for the current viewport.
  The first three game objects remain explicitly fictional in existing metadata.
- The authored demo pixel boards and their queues are unchanged. They are
  stylizations, not newly sampled reproductions of the source images. Exact
  paired production boards for the 100-work campaign remain P16-30 work; this
  change does not claim that all 100 heists are playable.
- Generated image prompts and original generation paths are retained in
  `assets/heist_intro/generation_prompts.json`. Source image provenance is in the
  manifest. Commons PD-Art records are evidence for these reproductions, not a
  blanket worldwide legal clearance; the catalog's territory review remains.

## Validation

The pre-edit archive and SHA-256 manifest are
`.backups/pre-bee-intro-20260927-135519.tgz` and its adjacent JSON (6,091 files,
verified; no player save). Tests use `tests/fixture.gd` and the existing isolated
validation runner. Other regression fixtures explicitly skip cinematic time;
`test_heist_intro.gd` exercises the real intro and every bundled image mapping.

Desktop validation passed: **1,189 checks across six suites**, using the final
passing run of each suite (intro 32, heist feedback 685, v4 61, motion 24,
boosters 34, r13 flow 353). Evidence:

- `artifacts/validation/bee-intro-verified/`: passing feedback, v4, motion and
  booster logs. That run's flow/capture failures were diagnosed and superseded.
- `artifacts/validation/bee-intro-final-tests/`: passing restored-session flow.
- `artifacts/validation/bee-intro-reduced-motion/`: final 32 intro checks,
  including nonzero timer freeze and full queue opacity after reduced motion.
- `artifacts/validation/bee-intro-final-preview/`: clean import/main scene,
  intro suite and **166 GPU frames** passed; `heist-intro.mp4` is the 6.64-second
  25 fps preview. Original, conversion and final playable frames were inspected.
- Manifest audit: all 15 current artwork IDs have matching files and SHA-256
  hashes. Paired planning validation passed.

The first capture stalled when macOS occluded the window. Capture now forces
rendering and explicitly advances isolated test time despite window focus;
normal gameplay still pauses on focus loss. The restored flow test now explicitly
skips cinematic time like the other regression fixtures. No player save was
opened or modified. Reduced-motion opacity was corrected and retested. The
preview shows the normal-motion path; its only subsequent runtime adjustment
was reduced-motion opacity, covered by the final intro suite. Desktop evidence
does not replace real-device acceptance in P16-29.

Next content phase: P16-30, produce and verify the remaining 85 playable heists
with original/pixel artwork pairs, exact queues and save-compatible identities.

## Lower-queue placement correction — 27 September 2026

At Halil's request, the large carrier now enters horizontally at the middle
front-row cube position (`QueueLayout.front(1, 3)` plus `heist_offset()`), hovers
there and exits at the same height. Only the scouts travel up to the painting.
The conversion frame was visually checked: the large bee is clear of the art.
The isolated run `artifacts/validation/bee-intro-lower-queue/` passed clean import,
main scene, all 32 intro checks and 166 GPU frames. Its `heist-intro.mp4` supersedes
the earlier placement preview. Paired design/checklist validation passed.
Completed task: P16-35 correction. Device acceptance and next content phase
remain P16-29 and P16-30 respectively.

## Top-down carrier and scout collection — 27 September 2026

Latest requested choreography supersedes the horizontal entry/exit above:

- 0.0–0.8 s: detailed artwork.
- 0.8–1.8 s: carrier enters from below, head up and abdomen down.
- 1.8–2.85 s: ten scouts emerge from the visible dorsal abdominal hatch.
- 2.85–5.05 s: scouts scan/reveal the pixel board.
- 5.05–6.3 s: scouts turn, return and shrink into that same hatch. The carrier
  remains still at its lower-queue anchor; the last scout is inside by 6.205 s.
- 6.3–7.8 s: carrier flies out through the top of the screen, still facing up.
- 7.8–8.3 s: cube queues appear and the intro finishes. Gameplay time resumes.

The new body is `assets/heist_intro/red_bee_topdown.png`, produced with the built-in
OpenAI imagegen tool using the previous side-view body as reference. Exact prompt,
provider and retained source path: `assets/heist_intro/topdown_generation.json`.
Both old body and generated source are preserved. Four overhead wings animate
in code; returning scouts turn toward the hatch. Reduced motion remains a short
crossfade. No puzzle, save or economy data is changed.

Validation for this correction passed in
`artifacts/validation/bee-intro-topdown-return/`: clean import, main scene,
**39 intro checks and 216 GPU frames**. The scan, returning scouts and completed
upper exit were visually inspected. `heist-intro.mp4` is the updated 8.64-second
preview at 25 fps and supersedes all earlier intro previews. Paired planning
validation passed. Next content/device work remains P16-30 / P16-29; this is a
completed P16-35 correction.
