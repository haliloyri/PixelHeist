#!/usr/bin/env python3
"""Sample Sun Seal into game data. Does not rewrite the source image or legacy levels."""
import argparse, colorsys, hashlib, json
from collections import Counter
from pathlib import Path
from PIL import Image
from build_large_queues import author
ROOT = Path(__file__).resolve().parents[1]
PATH = ROOT / 'data/source_pixel_boards.json'

def build():
    source = ROOT / 'assets/artworks/originals/sun_seal.png'
    levels = json.loads((ROOT / 'data/levels.json').read_text())
    gleaners = next(level for level in levels if level['art_id'] == 'the_gleaners')
    # Both artworks use the same 436 x 290 heist art viewport. Match the
    # Gleaners' cell pitch, then fit Sun Seal's own square aspect ratio.
    pitch = min(436 / gleaners['width'], 290 / gleaners['height'])
    with Image.open(source) as image:
        rgb = image.convert('RGB')
        rows = round(290 / pitch)
        columns = round(rows * rgb.width / rgb.height)
        assert columns * pitch <= 436 and rows * pitch <= 290 + 1e-6
        sampled = list(rgb.resize((columns, rows), Image.Resampling.BOX).getdata())
        turquoise = rgb.copy().convert('L')
        turquoise.putdata([255 if 135 <= colorsys.rgb_to_hsv(r/255,g/255,b/255)[0]*360 <= 200 and g>r*1.2 and g>45 else 0 for r,g,b in rgb.getdata()])
        coverage = list(turquoise.resize((columns, rows), Image.Resampling.BOX).getdata())
    cells = []
    for i, (r, g, b) in enumerate(sampled):
        h, s, v = colorsys.rgb_to_hsv(r/255, g/255, b/255)
        if coverage[i] >= 45: group = 4
        elif b > r * 1.15: group = 0
        elif .2126*r + .7152*g + .0722*b > 140: group = 3
        elif .2126*r + .7152*g + .0722*b > 85: group = 2
        else: group = 1
        cells.append(group)
    # Art-directed readable game colors: every visible transition maps to one
    # of these exact carrier colors; shading is geometry-only.
    palette = ['#183044', '#815019', '#c18832', '#efc467', '#238a91']
    base = next(level for level in levels if level['art_id'] == 'sun_seal')
    board = dict(width=columns, height=rows, heist_cell_pitch=pitch, heist_board_top=158, cells=cells, palette=palette,
                 pixel_style='raised_blocks', board_backing='#7c87b7',
                 source_pixels=dict(path='res://assets/artworks/originals/sun_seal.png',
                                    sha256=hashlib.sha256(source.read_bytes()).hexdigest(),
                                    method=f'{columns}x{rows} area sampling at The Gleaners screen-cell pitch, reduced to five playable palette colors; no independent transition tones',
                                    reference_art_id='the_gleaners',
                                    groups=['navy','bronze','ochre','gold','turquoise']),
                 queue_version=2)
    candidate = dict(base, **board)
    for seed in range(91273, 91473):
        plan = author(candidate, seed)
        if plan: break
    assert plan, 'No solvable bottom-entry plan'
    board.update(plan)
    return {'sun_seal': board}

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--check',action='store_true');args=parser.parse_args()
    data=build()
    existing=json.loads(PATH.read_text()) if PATH.exists() else {}
    if args.check: assert existing.get('sun_seal')==data['sun_seal'], 'Sun Seal source pixel data is stale'
    else:
        existing.update(data)
        PATH.write_text(json.dumps(existing,indent=2)+'\n')
    b=data['sun_seal']; print(f"Sun Seal source pixels OK: {b['width']}x{b['height']},",len(b['palette']),'playable colors,',Counter(b['cells']),';',len(b['solution']),'packets')
if __name__=='__main__':main()
