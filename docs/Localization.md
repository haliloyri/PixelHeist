# Localization authoring contract

English is the source language. `localization/source.json` owns stable keys,
English singular/plural text, gettext context and translator notes. `tr.json`,
`es.json` and `de.json` own the corresponding translations. Generate the four
PO resources with `python3 tools/build_localization.py`; validate with `--check`.
Never edit generated PO files directly. `build_content.py` emits stable key
references; its historical authoring strings are not the translation source.

The current 622-key catalog covers the existing 15-work demo, P03 presentation
sandbox, P04's first-case selection and two additional fictional artworks, and P05's
return/inspection/disposition, archive/storage and screen-state presentation, plus
P06 paths/ranks, memories/labels, contact trust, profile and earned-credit looks.
It does not invent the remaining campaign or storefront copy. New
content must add complete translations before its phase can claim completion.
These translations have automated and in-engine review; independent native
speaker/editorial review remains part of the P11/P13 content gate.

## Identity, context and spoilers

Keys, `art_id`, `location_id`, `speaker_id`, transaction and product IDs never
change with locale. Preserve real artist and institutional identities. Use
accepted translated artwork/place names where appropriate. Existing acquisition,
exhibition and legacy index mappings are untouched by presentation text.

| Context / subject | Authoring rule |
| --- | --- |
| Empty gettext context | Interface, concise actions and status; no story revelations |
| `story` | Dialogue, mission and clue; preserve speaker voice and reveal timing |
| `speaker` | Canonical proper names; keep the `Pixel` call sign in every language |
| `artwork` | Artwork title, artist, facts, date and museum; distinguish invented artifacts from real works |
| `place` | City/country/context; preserve actual institution and geography |
| `campaign` | Fictional sale estimates, independent strengths/costs, current display fit and correctly timed finale reveals |
| Future commerce | Add a separate `storefront` context; localized provider price is authoritative |

Canonical IDs: `rocco` → Rocco “Pixel”; `sprocket` → Sprocket; `quill` → Quill;
`frost` → Mr. Frost; `glimmer` → Baron Glimmer; `tuck` → Tuck;
`barnaby` → Barnaby Bramble. The early anonymous client uses public display key
`speaker.curator`, even though private content metadata uses `frost`.
Never derive display text from that hidden identity or expose it in accessibility,
sharing, notifications or early dialogue. Later phases must select the public
speaker key explicitly for each revelation state.

## Shared terminology

| English / concept | Türkçe | Español | Deutsch | Meaning and constraint |
| --- | --- | --- | --- | --- |
| Heist | Soygun | Robo | Raubzug | The job, not a purchase or acquisition callback |
| Night Museum | Gece Müzesi | Museo Nocturno | Nachtmuseum | Player's museum, a fictional proper location |
| Artwork | Eser | Obra | Kunstwerk | A whole piece; not an individual matching pixel |
| Scout | Keşif dronu | Dron explorador | Spähdrohne | Small flying collector |
| Carrier | Taşıyıcı dron | Dron de carga | Transportdrohne | Shared dock occupant with remaining capacity |
| Dock | Yuva | Plataforma | Andockplatz | Shared receiving position, not a fixed color lane |
| Inspection | İnceleme | Inspección | Untersuchung | Research action, distinct from mere display |
| Offer | Teklif | Oferta | Angebot | Independent money offered for a piece |
| Recognition | Tanınırlık | Reconocimiento | Bekanntheit | An artwork property, distinct from personal Renown |
| Wealth (`wealth`) | Servet | Riqueza | Wohlstand | Lifetime eligible earnings, separate from spendable credits |
| Renown (`renown`) | Ün | Renombre | Ruhm | Player's accumulated recognition history |
| Research (`insight`) | Araştırma | Investigación | Forschung | Profile path; ID remains `insight` |
| Collecting (`curation`) | Koleksiyonculuk | Coleccionismo | Sammeln | Profile path; no universal best artwork |
| Restore purchases | Satın alımları geri yükle | Restaurar compras | Käufe wiederherstellen | Entitlement recovery, not a new charge |
| Rewarded ad | Ödüllü reklam | Anuncio con recompensa | Belohnte Anzeige | Optional, callback-verified reward; never implies guaranteed eligibility |

Future story, trade-off and storefront copy must use these distinctions and
state opportunity costs explicitly. Do not compress independent values into
one artwork score. Do not revive Mastery/Observation/Curation/Influence bars.

## Formatting and runtime behavior

Use named fields (`{count}`, `{artist}`, `{level}`), not positional fragments.
Keep placeholder sets identical across locale/plural variants. `L.plural` uses
gettext singular/plural resolution and a localized count; numeric display uses
locale separators, including Spanish four-digit grouping behavior. Technical
IDs, URLs, versions and save data are never passed through numeric formatting.
The Turkish uppercase helper distinguishes `i/İ` and `ı/I`.

A supported manual preference takes precedence over the OS language. An empty
preference means system language; only en/tr/es/de are supported, with English
fallback for other devices and missing translations. Save only the language
preference in `settings.locale`; never infer store country, currency, tax,
eligibility or price from it. Locale switching rebuilds presentation while
preserving reservations, routes, undo, budget, modal and museum position.

The Godot bundled font covers launch-language accented letters and punctuation.
Runtime fitting measures the intended rectangle, not an auto-expanded Label.
Long inspection facts scroll. Pseudo localization expands literal vowels while
protecting named fields and uses ASCII brackets supported by the font.
`capture_localization.gd` checks intended text bounds and raw keys, and captures
nine states in each language plus five expanded German states. Human inspection
of the generated images is still required.

`capture_campaign.gd` adds nine campaign states per language and three expanded
German states. Empty/finalized cases and the single remaining finale have their
own text; they must not claim a diverse trio where none remains. Dossier facts
separate real-art context from the fictional operation's holder and prices.

API references: [gettext context/plurals](https://docs.godotengine.org/en/stable/tutorials/i18n/localization_using_gettext.html),
[TranslationServer](https://docs.godotengine.org/en/stable/classes/class_translationserver.html).
