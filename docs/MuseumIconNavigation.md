# P16-40 — Museum icon navigation

Completed: 27 September 2026.

The Museum's upper Floors / Collection / Crew tabs and lower Shop / Home / Museum navigation now use scalable line-art icons. The selected destination has an emerald background and icon tint. The floor selector has a distinct elevator icon; its popup keeps the full ten stage names. The current floor number, stage name, collection count and photo aspect ratio remain visible as plain information.

The original/pixel action is a grid when it will show pixels and a framed picture when it will return to originals. Collection editing, room theme, photo mode and painting-detail actions also use icons. Every icon button carries a hover label and a descriptive metadata label. Photo exports remain HUD-free. The saved collection format and gameplay state are unchanged.

Validation: `artifacts/validation/museum-icons-final-20260927/summary.json` passed planning, localization, chapter generation, clean Godot import, startup, `test_stage_museum` (90 checks), `test_r13_flow` (353 checks), and 16 Metal/OpenGL museum captures. Reviewed the floor, pixel, collection, editor, detail and photo screenshots. Tests used isolated fixture saves and a separate application identity.

Remaining: visual recognition of icons and touch comfort need observation on real iOS/Android devices under P16-29. Desktop hover labels are available; touch-specific help may be added if device testing shows confusion. The 85 future works still need playable boards and queues under P16-30. Next phase is the remaining P16 content and device work.
