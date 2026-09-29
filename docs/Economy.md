# Economy, professional history and personal memories

P06 implements one authored story case and 17 work profiles. This is an
implementation contract, not evidence of a balanced 100-job release.
`data/economy.json` owns professional grants, ranks, work eligibility and earned
looks. `data/post_heist.json` owns exact eligible buyer offers and inspection
outcomes. `economy_service.gd` reconciles durable facts inside the atomic save
commit. UI and rendering cannot grant rewards.

## Wallet and four independent paths

| Source | Wallet | Professional consequence |
| --- | --- | --- |
| First story completion | +120 | Wealth +120; Renown = recognition × 10 |
| Confirmed authored first sale | Exact buyer offer | Wealth = actual sale credits |
| Public buyer | Its own offer | Renown +8; Riverlight trust +2 |
| Private buyer | Its own offer | Private collector trust +2 |
| Verified cooperative return | No sale credit | Renown +6; cooperative trust +4; first-return memory |
| Verified Riverlight loan | No sale credit | Renown +5; Riverlight trust +3 |
| First authored related / inconsistent / fragment inspection | 0 | Research +12 / +8 / +25; no evidence = 0 |
| Three same-theme physical originals on one floor | 0 | Collecting +20, once per theme across the save |
| Three physical originals spanning four tags | 0 | Collecting +15, once across the save |
| Generic test credit / optional ad credit | Supplied credit amount | No professional growth |
| Paid entitlement | 0 | No professional growth |
| Earned decoration | Minus catalog price | Lifetime Wealth unchanged |

No extra currency, global artwork score, duplicate fame bar or Influence path
exists. Contact trust is a map keyed by stable fictional contact IDs. Spending
does not reduce lifetime income. Demo completions preserve the old free demo;
they create acquisition memories but receive no story fee or heist Renown.
Authored demo inspection, sale and physical exhibition facts can contribute
their distinct paths. No progress path modifies docks, speed, queue access,
color visibility or the shared 600-real-second boost.

Theme milestones require originals currently owned and displayed together.
Stored works, memories, originals elsewhere and departed originals cannot supply
current completeness. The first award stores its three work IDs; selling after
that keeps its history but removes current completeness. Rebuilding or moving
the same theme to another floor earns no second award. Diversity can span floors.
P07 will expose full exhibition/placement management over this existing ledger.

## Ranks and starting economy

All four paths have five localized titles and independently displayed progress.
No title gates story access, endings or puzzle capability.

| Path | Rank thresholds |
| --- | --- |
| wealth | 0, 600, 6,000, 30,000, 90,000 |
| renown | 0, 30, 150, 500, 1,200 |
| insight | 0, 8, 40, 120, 250 |
| curation | 0, 15, 40, 90, 150 |

The first case exposes early progress and distinct selection costs. These are
starting values for the available content. P08 observed playtests and actual
P11/P12 reward authoring must revisit late ranks and the speed of decoration
acquisition. In particular, one high-value clock sale can already fund the entire
small starting catalog; that acceleration is explicit, not disguised as a
balanced 100-job economy.

| Stable earned item ID | Credits | Visible effect |
| --- | ---: | --- |
| van_cobalt | 120 | Cobalt return vehicle |
| van_coral | 240 | Coral return vehicle |
| van_night | 600 | Night vehicle |
| stage_cobalt | 1,200 | Cobalt presentation platform |
| stage_violet | 3,600 | Violet presentation platform |
| stage_emerald | 7,200 | Emerald presentation platform |

S19 lets the player preview without mutation, buy once, and equip owned finishes.
A first kept/returned story job pays for the cobalt van. Prices cannot be supplied
by callers; the registered catalog is authoritative. There are no SDKs or real
purchases here. Van tint applies to city return; platform tint applies to shared
entrance/memory/reconstruction/success dioramas. Canonical artwork colors are
unchanged. Full museum walls/lighting and permanent paid packs remain P07/P09.

## Memory rules and profile

S12 separates fictional job location/UTC completion date, current ownership,
personal labels and known verified evidence from sourced art facts. Historic
jobs remain selectable after sale/return/loan. Unknown legacy dates are explicitly
unknown. S15 shows a 24-character optional call sign, separate wallet, four ranks,
choice history, individual contact trust, at most three pins and recorded-choice
portraits. Several portraits may apply; there is no combined score.

- `first_job`: first known acquired work; immutable.
- `first_big_job`: first known acquired work with recognition at least 4/5; immutable.
- `first_return`: first recorded return; immutable after departure.
- `masterpiece`: player's selection among completed authored difficult jobs.
- `hardest_job`: player's subjective selection among acquired works.
- `overlooked_favorite`: player's selection among acquired works rated at most 2/5.

Only one work holds each newly assigned subjective label. A work may qualify for
several labels but has exactly one selected primary label when labeled. Primary
labels appear on museum cards, storage entries and personal memories. Pins and
labels grant no credits, multipliers or puzzle advantage. The five existing
bottom-entry jobs are `masterwork_eligible`; future jobs require authored flags.
Neither undo count nor completion speed determines eligibility.

## Provenance, migration and failure

`reward:job:<art_id>` remains the original 120-credit payment record. P06 adds
zero-credit `reward:path:<source>` entries mirrored by `economy.grants` and
`path_grants`. Source IDs include `job:<id>`, `heist:<id>`, `inspection:<id>`,
`decision:<id>:<choice>`, `exhibition:<tag>` and `diversity:first`. Empty decisions
such as keep have no fictitious path grant. Contact trust is summed separately.
Generic reward/ad operations cannot supply path gains or reserved gameplay IDs.

New optional schema-1 fields `economy` and `profile` upgrade atomically. Existing
wallet, ownership, evidence, sessions, settings, save identity and boost remain.
Old unproven path numbers stay in `legacy_paths`/`legacy_path_grants`; new
professional totals derive only from recorded eligible facts. Existing P05 fees,
confirmed authored sales and verified inspections grant their professional
history once without paying credits again. Unknown legacy first dates are not
invented. Existing personal labels are retained. Reopening an upgraded save
performs no duplicate grant.

`decoration:<item_id>` atomically deducts the wallet, records ownership and equips
the item. Duplicate callbacks cannot charge twice; unknown products and overdrafts
are rejected. Every resulting snapshot validates path sums, provenance, trust,
exhibition work IDs, equipment ownership and profile selections. Actual process
kills at flush/replacement/backup test coherent recovery and safe retry. This is
a local persistence boundary, not an untrusted production provider endpoint.

## Simulated evidence

`test_economy_simulation.gd` exercises all **360 four-of-six orders × four
policies = 1,440 runs** using the production transaction application, authored
inspection/disposition, reconciliation and save validator in memory. Every run
buys the first van from its first 120-credit fee, reaches zero spendable credits,
then completes the case without ads, paid entitlements or stat gates. It does
not claim to solve 1,440 puzzle flight sequences; existing gameplay suites supply
actual-flight checks.

Representative target selections, after the first van purchase:

| Policy | Wallet | Wealth | Renown | Research | Collecting | Originals kept |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Keep: seal/clock/swatches/pearl | 480 | 600 | 110 | 20 | 55 | 5 |
| Sell: clock/seal/cup/pearl, private buyers | 33,680 | 33,800 | 120 | 8 | 0 | 0 |
| Research: swatches/seal/clock/cup, verified return | 480 | 600 | 86 | 20 | 35 | 4 |
| Fame: pearl/starry/seal/cup, public buyers | 18,880 | 19,000 | 200 | 8 | 0 | 0 |

Every row includes Moon Gate Mask as the fifth job. Research is independent of
sale: keeping a verified work also retains its evidence and Research points.
The research policy's verified return additionally costs the original and sale
income while gaining a distinct contact relationship.

A separately labeled **synthetic projection** is 100 × 120 = 12,000 credits in
job fees. It funds the most expensive individual platform plus the first van,
but not all six looks (12,960 total). After the first van, eleven job fees buy the
1,200-credit platform. This projection is arithmetic, not authored future jobs,
100-job rank balance, player completion times or observed engagement.
The runner retains `p06-economy-simulations.json` with all bounds and examples.

## 3× refill (2026-09-23)

`economy.json.boost_refill` = 120 seconds for 240 earned credits. The offer
appears only when the 600-second budget is empty (tap the empty 3× button). It is
an idempotent `boost_refill:<n>` ledger event: credits leave the wallet, Wealth
and other paths are untouched, and no real money, ad or provider is involved.
The price is provisional; revisit it with observed full-campaign play.
