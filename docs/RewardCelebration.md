# Reward celebration — P16-58

28 September 2026. Reward receipts reuse the Level Complete confetti palette
and renderer with 56 pieces and a single chest pop. All receipt types use the
same effect. It is clipped below title/daily information and above Collect,
ignores pointer input, stops after 3.2 seconds and is removed with the window.
Reduced motion is static; app suspension freezes/resumes at the same point.
Rewards remain committed once before presentation. No save or provider changes.

P16-58 is complete. Evidence:
`artifacts/validation/reward-celebration-20260928/summary.json`.
Planning, localization, chapters, Godot import and main scene passed. Three
isolated suites passed: screen refresh 42, Level Complete 32 and store 72
(146 checks, zero failures). Checks cover immediate Collect, pointer pass-through,
control clearance, chest motion/settling, suspension/resume, finite cleanup,
no extra grant on dismissal, and static reduced motion.

Six GPU captures at 720×1280 and 390×844 cover daily, pack and reduced-motion
receipts. Burst, falling and settled frames were inspected; headers and controls
remain clear. An 84-frame / 24-fps preview is saved as
[reward-celebration-preview.mp4](../artifacts/validation/reward-celebration-20260928/reward-celebration-preview.mp4).
Player saves were not reset. Device touch/safe-area and performance acceptance
remain P16-29. Next phase remains P16.
