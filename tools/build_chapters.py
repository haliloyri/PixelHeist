#!/usr/bin/env python3
"""Author data/chapters.json: the r13 linear campaign (20 chapters x 5 heists).

Story text is English only (design r13, section 16). Each bubble is at most eight words.
Chapters 1-3 use the 15 existing puzzles; later chapters list their finale artwork and
story, but their heist puzzles are not authored yet (content production).
"""
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

HEISTS = {
    1: ["sun_seal", "sapphire_cup", "girl_with_a_pearl_earring", "starry_night", "moon_gate_mask"],
    2: ["mona_lisa", "the_kiss", "the_scream", "birth_of_venus", "water_lilies"],
    3: ["the_gleaners", "the_magpie", "the_star", "dance_at_le_moulin_de_la_galette", "apples_and_oranges"],
}
FRAGMENTS = {2: 1, 6: 2, 10: 3, 15: 4, 20: 5}
CREW_CHAPTERS = [1, 3, 5, 7, 9, 11, 13, 15, 17, 19]

def p(bg, *bubbles):
    return {"background": bg, "bubbles": [{"speaker": s, "text": t} for s, t in bubbles]}

CHAPTERS = [
    # id, title, case, finale, act, background, tag plan, win bubbles (5), outro panels (3)
    ("first_commission", "First Commission", "Glimmer's sample collection", "Moon Gate Mask", 1, "museum_hall", [],
     [("sprocket", "The client asked for something small."), ("rocco", "They meant the budget."), ("sprocket", "You left the frame?"),
      ("rocco", "I respect their decorating choices."), ("sprocket", "Rocco. Our device is on this list.")],
     [p("museum_hall", ("sprocket", "Our device is on the delivery list."), ("rocco", "Then nobody gets delivered anything.")),
      p("florence", ("rocco", "We keep the works. All of them."), ("sprocket", "The Curator will not like that.")),
      p("museum_hall", ("tuck", "Welcome to your new gallery."), ("rocco", "Hang them straight. We stay.")) ]),
    ("false_owners", "False Owners", "Private European exhibitions", "Water Lilies", 1, "giverny", ["", "", "HARD", "", ""],
     [("tuck", "That wall was missing something."), ("rocco", "A museum somewhere agrees."), ("sprocket", "The label is newer than the paint."),
      ("rocco", "Someone rewrote whose painting this was."), ("sprocket", "There's a second layer. A hidden archive.")],
     [p("giverny", ("sprocket", "Barnaby Bramble hid records inside it."), ("rocco", "A restorer with secrets. I like him.")),
      p("museum_hall", ("rocco", "One fragment. How many left?"), ("sprocket", "Four more, hidden in four works.")),
      p("paris", ("rocco", "Next stop, Paris."), ("sprocket", "Pack the small screwdrivers.")) ]),
    ("lower_threshold", "Lower Threshold", "A Paris restoration chain", "Apples and Oranges", 1, "paris", ["", "", "", "HARD", ""],
     [("sprocket", "Bottom entry only. Mind the gaps."), ("rocco", "Colors can wait. We cannot."), ("tuck", "Five docks now? Getting fancy."),
      ("sprocket", "Right color. Early choice. Careful."), ("rocco", "That's not the artist's mark.")],
     [p("paris", ("rocco", "Someone copied the maker's mark."), ("sprocket", "Atlas workshops. Same tool marks.")),
      p("museum_hall", ("quill", "I'm Quill. I check claims."), ("rocco", "Then check this one.")),
      p("iznik", ("quill", "Atlas ships through Istanbul depots."), ("rocco", "Then so do we.")) ]),
    ("harbor_collection", "Harbor Collection", "Fictional Istanbul depots", "Shore Ledger", 1, "iznik", ["", "", "HARD", "", ""],
     [("sprocket", "There's a fortune in the van."), ("rocco", "Then watch the potholes."), ("quill", "This stamp proves nothing alone."),
      ("rocco", "Good. I hate easy answers."), ("quill", "The ledger links Atlas to shipping.")],
     [p("iznik", ("quill", "Atlas moves art under false names."), ("rocco", "We follow the ships, not the Curator.")),
      p("museum_hall", ("sprocket", "No more deliveries. Our own job now."), ("rocco", "Our rules. Our museum.")),
      p("vienna", ("quill", "Next shipment left on a wrong address."), ("rocco", "Let's go find it.")) ]),
    ("wrong_address", "Wrong Address", "A transport collection", "Return Ticket", 2, "vienna", ["", "HARD", "", "", "SUPER HARD"],
     [("sprocket", "This crate was sent twice."), ("rocco", "Nobody ships a painting twice by accident."), ("tuck", "The frames are lovely. The paperwork isn't."),
      ("quill", "The label points north. The route doesn't."), ("rocco", "A return ticket nobody meant to use.")],
     [p("vienna", ("quill", "The false label hid the real route."), ("sprocket", "Toward a harbor archive.")),
      p("museum_hall", ("tuck", "Your gallery is filling up fast."), ("rocco", "It's a collection, not a hoard.")),
      p("oslo", ("quill", "A sealed shipment waits in the archive."), ("rocco", "Sealed is just a suggestion.")) ]),
    ("sealed_shipment", "Sealed Shipment", "A harbor archive", "Blue Shipping Plate", 2, "oslo", ["", "", "HARD", "", ""],
     [("sprocket", "Inner colors first. Trust me."), ("rocco", "I always trust you. Mostly."), ("quill", "Every crate lists the same foundation."),
      ("rocco", "Atlas Foundation. Preserving their own story."), ("sprocket", "Second fragment. Barnaby was thorough.")],
     [p("oslo", ("sprocket", "Fragment two maps the transfer network."), ("quill", "Glimmer funds every link of it.")),
      p("museum_hall", ("rocco", "Two of five. Halfway to proof."), ("quill", "Proof needs people, not just files.")),
      p("vienna", ("quill", "Glimmer is hosting a silent auction."), ("rocco", "Then I'll bid very quietly.")) ]),
    ("silent_auction", "Silent Auction", "A private Vienna invitation", "Gold-Faced Clock", 2, "vienna", ["", "", "", "HARD", ""],
     [("tuck", "Black tie. Try not to steal the chairs."), ("rocco", "Only the art. Probably."), ("sprocket", "These hues are almost identical."),
      ("quill", "Every buyer here owes Glimmer favors."), ("rocco", "This signature. I've seen it before.")],
     [p("vienna", ("rocco", "The Curator signed this years ago."), ("sprocket", "So the Curator worked for Atlas.")),
      p("museum_hall", ("quill", "An unsigned letter could prove it."), ("rocco", "Where would a designer hide it?")),
      p("florence", ("tuck", "In storage. Designers never throw things away."), ("rocco", "Neither do thieves.")) ]),
    ("unsigned_letter", "Unsigned Letter", "An exhibition designer's storage", "Half an Invitation", 2, "florence", ["", "HARD", "", "", ""],
     [("tuck", "I know this designer's style."), ("rocco", "Then you know where he hides things."), ("sprocket", "Half an invitation. Where's the rest?"),
      ("quill", "The ink matches the Curator's letters."), ("quill", "Verified. Same hand, same signature.")],
     [p("florence", ("quill", "The Curator is inside Atlas's history."), ("rocco", "Then we stop taking his calls.")),
      p("museum_hall", ("sprocket", "He just called. Twice."), ("rocco", "Let it ring.")),
      p("hague", ("quill", "Two collections claim the same painting."), ("rocco", "One of them is lying.")) ]),
    ("two_collections", "Two Collections", "Amsterdam salons", "Double-Labeled Landscape", 3, "hague", ["", "", "HARD", "", "SUPER HARD"],
     [("sprocket", "Islands of color. Keep a spare dock."), ("rocco", "I always keep a spare something."), ("tuck", "Two salons, two proud owners."),
      ("quill", "One record, assigned to two objects."), ("rocco", "Someone erased a family from this.")],
     [p("hague", ("quill", "One ownership record, two paintings."), ("rocco", "A history copied onto a stranger.")),
      p("museum_hall", ("sprocket", "The restoration archive holds the originals."), ("rocco", "Then we visit the archive.")),
      p("paris", ("rocco", "Let's see who wrote twice."), ("sprocket", "Double entry. Old accounting trick.")) ]),
    ("double_entry", "Double Entry", "A restoration archive", "Twice-Written Portrait", 3, "paris", ["", "", "", "HARD", ""],
     [("sprocket", "Early inner colors cost us later."), ("rocco", "Everything costs us later."), ("quill", "This portrait was painted over a name."),
      ("rocco", "Someone wanted a face forgotten."), ("frost", "Hello, Rocco. I'm the Curator.")],
     [p("paris", ("frost", "I am Mr. Frost. We should talk."), ("rocco", "You put my device on a list.")),
      p("museum_hall", ("frost", "Under one roof, they would be safe."), ("rocco", "And only you get the key.")),
      p("anatolia", ("sprocket", "Fragment three names living families."), ("quill", "Then we find them.")) ]),
    ("missing_voices", "Missing Voices", "A family and community archive", "Entrusted Chest", 3, "anatolia", ["", "HARD", "", "", ""],
     [("quill", "These records have living grandchildren."), ("rocco", "Then this isn't just a heist."), ("tuck", "Calmer colors today. Good for nerves."),
      ("sprocket", "The chest was entrusted, not sold."), ("quill", "A family name, finally back.")],
     [p("anatolia", ("quill", "The chest came home. So did a name."), ("rocco", "That felt better than a payday.")),
      p("museum_hall", ("tuck", "People want to see your gallery."), ("rocco", "Then let's open the door.")),
      p("museum_hall", ("rocco", "One night. One public showing."), ("sprocket", "What could possibly go wrong?")) ]),
    ("open_door", "Open Door", "A closed exhibition depot", "Exhibition No. 12", 3, "museum_hall", ["", "", "HARD", "", "SUPER HARD"],
     [("tuck", "Twelve works, one wall, no pressure."), ("rocco", "I work well under pressure."), ("sprocket", "Smooth queue. Enjoy it while it lasts."),
      ("quill", "The press is already outside."), ("rocco", "Let them see what Atlas hid.")],
     [p("museum_hall", ("quill", "Your first showing made headlines."), ("rocco", "Good ones, I hope.")),
      p("vienna", ("glimmer", "Young Rocco. You borrowed my things."), ("rocco", "Baron Glimmer. Finally.")),
      p("vienna", ("glimmer", "Let's discuss this politely. At Atlas."), ("rocco", "Polite is how you threaten people.")) ]),
    ("polite_threat", "Polite Threat", "An Atlas invitation", "Silver Card Case", 4, "vienna", ["", "HARD", "", "", ""],
     [("glimmer", "Every newspaper owes me dinner."), ("rocco", "Then they can pay for it."), ("sprocket", "Mystery packets everywhere. Classic Glimmer."),
      ("quill", "He's calling you a common thief."), ("rocco", "Uncommon, surely. Look at this work.")],
     [p("vienna", ("quill", "Glimmer is attacking you through the press."), ("rocco", "Then we document the source.")),
      p("museum_hall", ("quill", "A publisher changed witness testimony."), ("sprocket", "Whose story, then?")),
      p("florence", ("rocco", "Let's ask the publisher's collection."), ("quill", "Carefully. They sue people.")) ]),
    ("whose_story", "Whose Story?", "A publisher's collection", "Before the Press", 4, "florence", ["", "", "", "HARD", ""],
     [("quill", "The first draft tells the truth."), ("rocco", "Always keep the first draft."), ("tuck", "A short job. Breathe a little."),
      ("sprocket", "Someone edited a witness out."), ("quill", "Here's what they said before the press.")],
     [p("florence", ("quill", "The testimony was rewritten for Glimmer."), ("rocco", "Then we print the original.")),
      p("museum_hall", ("sprocket", "The next fragment sits in a closed exhibition."), ("rocco", "Closed is my favorite kind.")),
      p("oslo", ("quill", "Pressure's rising. Be careful tonight."), ("rocco", "Careful is my middle name.")) ]),
    ("pressure_after_dark", "Pressure After Dark", "A closed exhibition", "Closed Window", 4, "oslo", ["", "HARD", "", "", "SUPER HARD"],
     [("sprocket", "Edge rules and mysteries. Fun night."), ("rocco", "Define fun, Sprocket."), ("quill", "Guards changed shifts early tonight."),
      ("tuck", "Your museum is all over the news."), ("sprocket", "Fragment four. Names of beneficiaries.")],
     [p("oslo", ("sprocket", "Fragment four lists who profited."), ("quill", "Glimmer, Atlas, and three quiet partners.")),
      p("museum_hall", ("frost", "Give me the archive. I'll protect it."), ("rocco", "Protect it, or own it?")),
      p("anatolia", ("quill", "There's another way. Shared custody."), ("rocco", "Trust spread across many hands.")) ]),
    ("cost_of_trust", "The Cost of Trust", "A preservation network", "Three-Key Box", 4, "anatolia", ["", "", "HARD", "", ""],
     [("quill", "Three keys, three keepers."), ("rocco", "Nobody holds everything. I like that."), ("tuck", "Even your gallery needs friends."),
      ("sprocket", "The box opens only together."), ("frost", "You're building a network against me.")],
     [p("anatolia", ("quill", "Researchers and communities, sharing custody."), ("rocco", "An answer to Mr. Frost's single roof.")),
      p("museum_hall", ("sprocket", "Atlas is moving its archive tonight."), ("rocco", "Moving targets. My specialty.")),
      p("paris", ("quill", "They're destroying pages as they go."), ("rocco", "Then we move faster.")) ]),
    ("missing_page", "Missing Page", "A moving Atlas archive", "Cut Album", 5, "paris", ["", "HARD", "", "", ""],
     [("sprocket", "Inner passages. Plan every route."), ("rocco", "I plan. I just don't announce it."), ("quill", "Half these pages are ash."),
      ("tuck", "Save what you can, Rocco."), ("quill", "A destruction order. Signed by Glimmer.")],
     [p("paris", ("quill", "Glimmer ordered the records destroyed."), ("rocco", "He was always afraid of history.")),
      p("vienna", ("glimmer", "Name your price for silence."), ("rocco", "You can't afford it.")),
      p("vienna", ("sprocket", "He wants to negotiate in person."), ("rocco", "Then I'll bring the art.")) ]),
    ("last_offer", "Last Offer", "Glimmer's negotiating room", "Untitled Bust", 5, "vienna", ["", "", "HARD", "", ""],
     [("glimmer", "Everyone has a price, Young Rocco."), ("rocco", "Mine is the truth. Pay up."), ("sprocket", "Short job. Definite pressure."),
      ("quill", "Every contact is watching you now."), ("rocco", "Let them watch. I'm working.")],
     [p("vienna", ("glimmer", "Walk away rich. Or walk away."), ("rocco", "I'll walk away with the bust.")),
      p("museum_hall", ("sprocket", "The device's origin is in Barnaby's work."), ("rocco", "Then his showcase holds the answer.")),
      p("florence", ("quill", "Glimmer keeps one last private showcase."), ("rocco", "Last is the right word.")) ]),
    ("final_inventory", "Final Inventory", "A private showcase", "Study No. 0", 5, "florence", ["", "HARD", "", "", "SUPER HARD"],
     [("sprocket", "Every rule we know, all at once."), ("rocco", "Good. I've practiced."), ("tuck", "Almost the whole collection now."),
      ("sprocket", "Barnaby built the first version of our device."), ("quill", "One archive left. In Glimmer's own collection.")],
     [p("florence", ("sprocket", "Barnaby designed my device's heart."), ("rocco", "He planned for someone like us.")),
      p("museum_hall", ("frost", "Last chance. Bring me the archive."), ("rocco", "Not tonight, Mr. Frost.")),
      p("vienna", ("quill", "Glimmer's principal collection. The last fragment."), ("rocco", "Whose museum is it, really?")) ]),
    ("whose_museum", "Whose Museum?", "Glimmer's principal collection", "Night Atlas", 5, "vienna", ["", "", "HARD", "", "SUPER HARD"],
     [("sprocket", "The final queue. No surprises left."), ("rocco", "There are always surprises."), ("tuck", "I saved a wall for this."),
      ("quill", "Everyone is watching tonight."), ("sprocket", "Fragment five. The archive is complete.")],
     []),
]

OPENING = [p("museum_hall", ("rocco", "Five paintings. One night."), ("sprocket", "Let's go."))]

ENDINGS = {
    "open_inventory": {"title": "Open Inventory", "line": "Publish everything, even what exposes you.", "panels": [
        p("museum_hall", ("rocco", "Publish all of it. Even me."), ("quill", "Every record, every name.")),
        p("paris", ("quill", "Families are finding their histories."), ("rocco", "And people are judging mine.")),
        p("museum_hall", ("sprocket", "The truth is out. Now what?"), ("rocco", "Now the gallery stays open."))]},
    "custodian_network": {"title": "Custodian Network", "line": "Entrust the record to many careful hands.", "panels": [
        p("anatolia", ("quill", "Three keys. Many keepers."), ("rocco", "Nobody owns it alone.")),
        p("museum_hall", ("frost", "You gave away the power."), ("rocco", "I gave it to everyone.")),
        p("museum_hall", ("tuck", "Your gallery looks different now."), ("rocco", "It looks shared. I like it."))]},
    "final_bargain": {"title": "Final Bargain", "line": "Break Glimmer and Mr. Frost with a private deal.", "panels": [
        p("vienna", ("glimmer", "You'd trade the archive for my exit?"), ("rocco", "For your silence. Permanently.")),
        p("vienna", ("frost", "Clever. Quiet. Not exactly honest."), ("rocco", "Neither were you.")),
        p("museum_hall", ("sprocket", "Atlas is gone. Nobody knows why."), ("rocco", "Some stories stay in the vault."))]},
}

CREW = [
    ("bit", "Bit", "A ladybug who never drops a pixel."),
    ("dash", "Dash", "A dragonfly with very fast wings."),
    ("gizmo", "Gizmo", "A beetle who fixes every drone."),
    ("hum", "Hum", "A bee who hums while he lifts."),
    ("flicker", "Flicker", "A firefly who lights dark depots."),
    ("pinch", "Pinch", "A stag beetle with gentle claws."),
    ("skitter", "Skitter", "A cricket who jumps queues."),
    ("velvet", "Velvet", "A moth who moves in silence."),
    ("tock", "Tock", "A weevil who keeps perfect time."),
    ("nova", "Nova", "A jewel beetle who shines last."),
]

# Painted comic panels (assets/story/<name>.jpg). Panels without art fall back to the
# location background. See docs/Characters.md for the approved style reference.
STORY_ART = {"opening": ["ch01_opening"], 1: ["ch01_1", "ch01_2", "ch01_3"]}

def with_art(panels, names):
    out = [dict(panel) for panel in panels]
    for panel, name in zip(out, names):
        assert (ROOT / "assets/story" / (name + ".jpg")).exists(), name
        panel["art"] = name
    return out

def main():
    chapters = []
    for i, (cid, title, case, finale, act, bg, tags, wins, outro) in enumerate(CHAPTERS, start=1):
        for speaker, text in wins:
            assert len(text.split()) <= 8, (cid, text)
        for panel in outro:
            assert 1 <= len(panel["bubbles"]) <= 2
            for b in panel["bubbles"]:
                assert len(b["text"].split()) <= 8, (cid, b)
        tags = tags or ["", "", "", "", ""]
        chapters.append({
            "id": cid, "number": i, "title": title, "case": case, "finale": finale, "act": act,
            "background": bg, "heists": HEISTS.get(i, []), "difficulty": tags,
            "fragment": FRAGMENTS.get(i, 0),
            "crew": CREW[CREW_CHAPTERS.index(i)][0] if i in CREW_CHAPTERS else "",
            "win_bubbles": [{"speaker": s, "text": t} for s, t in wins],
            "outro": with_art(outro, STORY_ART.get(i, [])),
        })
    data = {"version": 1, "opening": with_art(OPENING, STORY_ART["opening"]), "chapters": chapters, "endings": ENDINGS,
            "crew": [{"id": c, "name": n, "bio": b} for c, n, b in CREW]}
    text = json.dumps(data, indent=1, ensure_ascii=False) + "\n"
    target = ROOT / "data/chapters.json"
    if "--check" in sys.argv:
        if target.read_text(encoding="utf-8") != text:
            print("Chapters FAILED: data/chapters.json is out of date; run tools/build_chapters.py")
            sys.exit(1)
        print("Chapters OK:", len(chapters), "chapters,", sum(len(c["heists"]) for c in chapters), "playable heists")
        return
    target.write_text(text, encoding="utf-8")
    print("chapters.json:", len(chapters), "chapters,", sum(len(c["heists"]) for c in chapters), "playable heists")

if __name__ == "__main__":
    main()
