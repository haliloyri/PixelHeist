# P16-38 — Museum floor exhibition

Completed: 27 September 2026.

The Museum floor now presents ten works in level order as five rows of two within a vertical scroll. Each gold frame follows the source image's aspect ratio; the taller work sets the row height and the shorter work is centered. The painting itself opens its large detail. Owned floor works have no status mark. Locked works retain a visible original with a single corner lock icon, and their large preview has no collection action. Missing image slots use a locked placeholder.

The floor, collection and crew tabs share a compact Shop / Home / Museum footer. The detail panel uses the museum's navy and antique-gold colors. The floor's original/pixel switch preserves the current scroll offset. Future originals without an authored pixel board remain originals in that mode and have no pixel toggle in detail. Their catalog title, artist, date and institution are shown without making the artwork playable or owned.

Validation: `artifacts/validation/museum-grid-complete-20260927/summary.json` passed planning, localization, chapter generation, clean Godot import, startup, `test_stage_museum` (72 checks), `test_r13_flow` (353 checks), and 16 real-GPU museum captures. The validation runner used a separate application identity and isolated fixture saves. Reviewed `museum-locked-originals.png`, `museum-floor-3-originals.png`, `museum-future-original-detail.png` and `museum-tall.png`.

Remaining: the future sourced originals still need authored pixel boards, queues and story content under P16-30. Real phone layout and touch feel remain under P16-29; native mobile sharing remains separate. Next phase is the remaining P16 work, especially P16-30 content production and P16-29 device validation.
