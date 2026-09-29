# P16-46 — In-place artwork detail view

Implemented: 27 September 2026.

The Artwork Detail original/pixel control now keeps the same modal card and artwork control. It replaces only the child image inside the framed artwork area, preserving the frame, metadata, collection actions and modal position. The action icon, accessible label and selected color follow the current view. Collection edits reopen the detail in its current view.

Validation: `artifacts/validation/museum-detail-toggle-20260927/summary.json` passed planning, localization, chapter generation, a clean Godot import, startup, `test_stage_museum` (97 checks), `test_r13_flow` (353 checks), and 17 desktop GPU captures. The original and pixel detail captures were inspected side by side; the artwork changes within an otherwise stationary detail card. `artifacts/validation/museum-detail-final-20260927/summary.json` passed the final planning/import/startup/Museum run after adding the collection-view assertion (98 Museum checks; zero failures). All gameplay tests use temporary saves and a separate application identity. `python3 tools/validate_planning_docs.py` checks the synchronized English and Turkish design/checklist entries.

Remaining: image recognition and touch behavior still require the real-device P16-29 acceptance pass. Future original works without authored boards have no pixel toggle under P16-30. Next phase is the remaining P16 content and device work.
