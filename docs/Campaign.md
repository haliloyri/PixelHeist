# Campaign selection and target authoring

P04 implements the first story case, `first_commission`, separately from the
15-work all-unlocked demo. Read [GameDesign.md](GameDesign.md) for the complete
20-case product scope. Case headers and stable IDs for the other 19 cases exist,
but their six-target sets and playable story content are not authored yet.

## Content and identity

`data/campaign_targets.json` owns case membership, the fixed finale, independent
offer/recognition/research fields, theme tags and localized reasons. Its target
dictionary is keyed by `art_id`; display names and array indices are never save
identities. `data/content_ids.json` keeps the original 15 legacy mappings and
appends `ivory_travel_clock` and `workshop_swatches` to the art registry.

| First-case target | Fictional sale range | Recognition | Research | Role |
| --- | ---: | ---: | --- | --- |
| Sun Seal | 6,000–7,200 | 2/5 | Possible | Gold/travel display; unverified mounting label |
| Sapphire Cup | 4,000–4,600 | 2/5 | None | Water/ceramics display |
| Girl with a Pearl Earring | 2,200–3,000 | 5/5 | None | Recognizable portrait; modest operation-specific offer |
| The Starry Night | 2,400–2,800 | 5/5 | None | Recognizable night/water display |
| Ivory Travel Clock | 12,000–14,000 | 1/5 | None | Specialist demand for an unfamiliar fictional mechanism |
| Workshop Swatches | 1,200–1,600 | 1/5 | Strong | Authored `workshop_batch_side_record`, never a main fragment |
| Moon Gate Mask — fixed finale | 3,800–4,400 | 2/5 | Possible | Delivery-paperwork reveal closes the first commission |

The two new puzzles, facts and locations live in `story_puzzles.json`,
`story_artwork_details.json` and `story_locations.json`. They use the existing
shared three-dock, all-edge rules and have authored solutions. `build_content.py`
and the legacy queue generator still own only the original 15 works; they do
not overwrite these separate story files. The new clock and swatch binder are
original fictional objects, not claims about an actual artist or collection.
The mission's fictional Glimmer holder is shown separately from historical art
facts accessed through the dossier's information button.

## Progression and save contract

`CampaignService` has no puzzle, purchase, reward or IO dependency. The save
service invokes `record_completion` within the existing atomic completion
transaction. Four distinct selectable targets append stable IDs in order to
`campaign.selected[level_id]`, set shared `level_id:choice_N` beat flags, and
record the exact two remaining IDs in `campaign.deferred[level_id]`. Only then
does `available` return the fixed finale. Completing it sets the finale flag and
opens the next case regardless of credits, recognition, research or ownership.
The final target is hidden in the selection UI before four choices.

The new dictionaries are optional additions to save schema v1. Existing demo
saves retain their meaning; migration never infers campaign beats from owned
works. Completed jobs and in-flight sessions are mode-specific. Acquisition,
physical ownership, settings, wallet and the durable 600-second boost budget
remain shared. Replay can revisit a selected job or finished finale, but cannot
count as another choice, restore a sold original, or grant an estimated offer.
The two deferred works remain outside the main case; post-story closure is P12.

The controller retains all 17 puzzles for save validation, then projects 15 for
demo selection or 17 for story. A cold story launch opens the operations desk.
Mode switching checkpoints the active flight and restores that mode's session.
The demo projection preserves story originals it cannot draw. Story museum
storage currently projects four five-frame floors to accommodate all 17 works;
the production ten-floor museum and its spatial presentation remain P07.

## Independent comparisons

Offer ranges, fixed recognition (1–5), research (none/possible/strong with an
authored reason) and exhibition fit remain separate. Only owned originals
physically displayed on the selected frame's floor count for fit. One matching
work extends a theme; two make the candidate capable of completing a three-work
theme. Empty displays show potential, an already-displayed target adds no new
piece, and memories, departed originals and other floors do not count.

Range A proves greater money value only when A's minimum exceeds B's maximum.
A meaningful money advantage additionally needs a gap of at least 500 credits
or 5% of B's maximum, whichever is greater. Overlapping unequal ranges do not
prove dominance. `warnings` reports dominance or a missing meaningful strength
or sacrifice; it never changes authored values. A departed original has no
repeat-sale opportunity, so its contextual comparison range is zero and the UI
explains its absence rather than promising the catalog's estimate again.

For more than three available targets, `recommend` evaluates three-target sets
by fewer warnings, real collection fit, coverage of available axis maxima and
distinct pairwise strengths. Ties retain authored order. These are selection
criteria for a set, never a universal score assigned to an artwork. The wallet,
paid themes, entitlements, ads and sharing are not inputs. Opportunity-cost text
names a real available alternative with a meaningful advantage. When a varied
set is impossible, or only the finale remains, the UI says so. Completed/locked
cases return no invented targets. “Other targets” is free.

## Views and next integration

`scripts/ui/campaign_view.gd` supplies the operations desk, recommendations/all
targets and target dossier (S03–S05). It preserves case, chosen frame and target
through language changes. All new copy is authored in English and supplied in
en/tr/es/de; long screens scroll. Settings and historic art facts remain modal.
The secured success now enters P05 return, free inspection and disposition.
The first case finale then shows the five selected works, their current ownership
and the two deferred alternatives before opening operations.

P05/P06 record a 120-credit first-story-job fee separately from any
sale estimate, and pays an authored fictional buyer offer only on confirmation.
P06 implements independent path grants, personal memories and first-case economy
simulations; full-campaign tuning remains open. See [Economy.md](Economy.md). Workshop Swatches
archives its fixed side record only during free inspection, before any sale;
preview/completion cannot silently grant it. See [P05 evidence](P05-Implementation.md).

## Verification

Run `python3 tools/validate_campaign_data.py` for ID joins, six-plus-finale
membership, independent counterexamples and source-key checks. The normal
project validator runs it together with catalog and planning checks.

`test_campaign.gd` enumerates all 360 ordered four-of-six choices for the
currently authored first case, simulates wealth/renown/insight/curation strategies,
checks contextual comparisons, and solves both new puzzles. `test_campaign_flow.gd`
uses the actual controller and durable saves for new-art flights, mode switching,
replay, cold startup and finale completion. `capture_campaign.gd` captures nine
states in each launch language plus three expanded German layouts (39 total),
auditing raw keys, placeholders and intended text bounds. These supplement all
existing mechanics, migration, kill-recovery, locale and visual-foundation tests.

## Story boards (2026-09-23)

`data/story_overrides.json` replaces the demo tutorial boards of Sun Seal
(24×24, 432 pixels) and Sapphire Cup (28×28, 418 pixels) in story mode only,
merged by `art_id` (`scripts/services/story_boards.gd`). The demo keeps its
original 13×13 and 17×16 boards. Queues are authored with
`godot --headless -s tools/rebuild_queues.gd -- --story-overrides`, which writes
only that file. The queue author now rejects any route that blocks when a player
acts before earlier flights land (think 0/1/2/4 s, with and without 3×) and
retries with another seed; `--only=<indices>` re-authors selected demo boards.
