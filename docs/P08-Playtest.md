# P08-04 — observed playtest protocol

Purpose: collect players' **reasons** for choices in the first case, not only
click counts, and judge the tempo findings in [P08-Implementation.md](P08-Implementation.md).
Automated checks cannot complete this task.

## Setup

* 5–8 players who have not seen the game; at least two Turkish and two English
  speakers; one German or Spanish speaker if available.
* A fresh install or a new save per player, entering through **Start your first job** on the entrance screen; never reuse the developer save.
* Record screen and voice with consent. Default settings; do not explain the
  boost, the museum or target values unless asked.
* Ask the player to think aloud. The observer only notes and asks the
  questions below at the marked moments.

## During play (≈35–45 minutes: one full case)

| Moment | Ask | Record |
| --- | --- | --- |
| First recommendations (S04) | "Which one would you take, and why?" | Card chosen, stated reason (money / fame / research / collection / looks / other), whether they opened Other targets |
| Each later target | "What are you giving up with this choice?" | Named sacrifice, or none |
| During heists | — (observe) | Moments of confusion, waiting without acting, surprise at blocked state, 3× noticed? |
| Each disposition (S11) | "Why keep / sell / return / store?" | Choice and reason; any regret |
| Museum after job 2+ | "Is there a work you would not sell? Why?" | Attachment signals |
| After job 5 / finale | "What would you do next?" | Could they find the next action unaided? |

## After play

1. Were any choices obviously best? Which, and why?
2. Did the drive home / inspection feel long by the fifth time? (1–5)
3. Did waiting while drones worked feel relaxing or dead? (1–5, with comment)
4. Did 3× feel necessary? Would you miss it if it ran out?
5. What did you understand about the story so far?

## Summary sheet (per player)

`player_id, locale, total_minutes, chosen_order, reasons[4], sacrifices_named,
dispositions, kept_favorite, boost_left_seconds, waiting_score, repetition_score,
next_action_found (y/n), notes`

Store completed sheets under `artifacts/playtests/` (no personal data beyond a
pseudonymous ID). P08-06 may be approved when most players can explain a
sacrifice, no single card dominates for the same money reason, and players find
the next action; carry anything else into named tasks.
