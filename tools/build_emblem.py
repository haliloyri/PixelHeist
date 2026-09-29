"""Crew emblem engraved into a departing cube's top face (2026-09-26, Halil).

Writes assets/emblem/crew_emblem_mask.png: a white-on-transparent line drawing
(a robot ant seen from above carrying one pixel, inside a ring: the crew's mark). depth_heist.gd turns it into an
engraving in the cube's own colour: dark grooves with a thin light lower lip, so it
reads as carved into the enamel rather than a coloured sticker.
"""
from pathlib import Path
from PIL import Image, ImageDraw

OUT = Path(__file__).resolve().parents[1] / 'assets/emblem/crew_emblem_mask.png'
S = 1024          # drawn at 4x, downsampled for smooth lines
W = 34            # groove width at 4x


def build():
    im = Image.new('L', (S, S), 0)
    d = ImageDraw.Draw(im)
    c = S / 2
    # Outer ring (a coin/seal outline).
    d.ellipse([60, 60, S - 60, S - 60], outline=255, width=W)
    # A robot ant seen from above, carrying one pixel: the crew's mark.
    # Body: head, thorax, abdomen along the vertical axis.
    d.ellipse([c - 95, c - 175, c + 95, c - 10], outline=255, width=W)      # head
    d.ellipse([c - 62, c - 2, c + 62, c + 120], outline=255, width=W)       # thorax
    d.ellipse([c - 120, c + 125, c + 120, c + 410], outline=255, width=W)   # abdomen
    d.line([c - 95, c + 265, c + 95, c + 265], fill=255, width=W // 2)      # abdomen plate seam
    d.line([c - 110, c + 205, c + 110, c + 205], fill=255, width=W // 2)
    # Eyes.
    for sx in (-1, 1):
        d.ellipse([c + sx * 48 - 26, c - 130, c + sx * 48 + 26, c - 78], fill=255)
    # Six legs from the thorax, each bent once.
    for sx in (-1, 1):
        for y0, knee, foot in [(c + 20, (c + sx * 190, c - 40), (c + sx * 250, c - 120)),
                               (c + 60, (c + sx * 215, c + 60), (c + sx * 300, c + 90)),
                               (c + 100, (c + sx * 190, c + 175), (c + sx * 250, c + 290))]:
            d.line([(c + sx * 55, y0), knee, foot], fill=255, width=W, joint='curve')
    # Antennae reaching up to the carried pixel.
    for sx in (-1, 1):
        d.line([(c + sx * 40, c - 165), (c + sx * 105, c - 260), (c + sx * 70, c - 310)], fill=255, width=W, joint='curve')
    # The pixel it carries: a small square above its head.
    d.rectangle([c - 62, c - 395, c + 62, c - 272], outline=255, width=W)
    d.line([c - 30, c - 365, c + 20, c - 365], fill=255, width=W // 2)  # glint
    small = im.resize((256, 256), Image.LANCZOS)
    out = Image.new('RGBA', small.size, (255, 255, 255, 0))
    out.putalpha(small)
    OUT.parent.mkdir(parents=True, exist_ok=True)
    out.save(OUT)
    print('crew_emblem_mask.png written')


if __name__ == '__main__':
    build()
