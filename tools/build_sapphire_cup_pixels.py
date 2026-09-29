#!/usr/bin/env python3
"""Build Sapphire Cup's playable source-derived pixel board and packet route."""
import argparse
import colorsys
import hashlib
import json
from collections import Counter
from pathlib import Path

from PIL import Image
from build_large_queues import author

ROOT = Path(__file__).resolve().parents[1]
PATH = ROOT / 'data/source_pixel_boards.json'
SOURCE = ROOT / 'assets/artworks/originals/sapphire_cup.png'


def build():
    levels = json.loads((ROOT / 'data/levels.json').read_text())
    gleaners = next(level for level in levels if level['art_id'] == 'the_gleaners')
    base = next(level for level in levels if level['art_id'] == 'sapphire_cup')
    pitch = min(436 / gleaners['width'], 290 / gleaners['height'])
    with Image.open(SOURCE) as image:
        rgb = image.convert('RGB')
        rows = round(290 / pitch)
        columns = round(rows * rgb.width / rgb.height)
        assert columns * pitch <= 436 and rows * pitch <= 290 + 1e-6
        sampled = list(rgb.resize((columns, rows), Image.Resampling.BOX).getdata())
        gold_mask = Image.new('L', rgb.size)
        gold_mask.putdata([
            255 if 24 <= colorsys.rgb_to_hsv(r / 255, g / 255, b / 255)[0] * 360 <= 55
            and colorsys.rgb_to_hsv(r / 255, g / 255, b / 255)[1] >= .25
            and r > b * 1.3 and r > 70 else 0
            for r, g, b in rgb.getdata()
        ])
        gold_coverage = list(gold_mask.resize((columns, rows), Image.Resampling.BOX).getdata())

    cells = []
    for (r, g, b), gold in zip(sampled, gold_coverage):
        luminance = .2126 * r + .7152 * g + .0722 * b
        if gold >= 18:
            group = 4  # The fine gold rims survive area sampling.
        elif luminance < 35:
            group = 0  # Keep the dark background out of the blue decoration.
        elif luminance >= 85 and b - r < 38:
            group = 3  # Porcelain body and the pale inside of the cup.
        elif b - r >= 36 and luminance >= 58:
            group = 2  # Lighter sapphire brushwork.
        else:
            group = 1  # Deep blue floral shapes and shaded porcelain.
        cells.append(group)

    palette = ['#14233b', '#254578', '#587bb1', '#e1dccb', '#c49b5b']
    board = dict(
        width=columns, height=rows, heist_cell_pitch=pitch, heist_board_top=158,
        cells=cells, palette=palette, pixel_style='raised_blocks',
        board_backing='#7c87b7',
        source_pixels=dict(
            path='res://assets/artworks/originals/sapphire_cup.png',
            sha256=hashlib.sha256(SOURCE.read_bytes()).hexdigest(),
            method=f'{columns}x{rows} area sampling at The Gleaners screen-cell pitch, reduced to five playable palette colors with gold-rim coverage',
            reference_art_id='the_gleaners',
            groups=['navy', 'cobalt', 'sapphire', 'porcelain', 'gold'],
        ),
        queue_version=2,
    )
    candidate = dict(base, **board)
    for seed in range(91273, 91673):
        plan = author(candidate, seed)
        if plan:
            board.update(plan)
            return board
    raise AssertionError('No solvable bottom-entry Sapphire Cup plan')


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    board = build()
    existing = json.loads(PATH.read_text()) if PATH.exists() else {}
    if args.check:
        assert existing.get('sapphire_cup') == board, 'Sapphire Cup source pixel data is stale'
    else:
        existing['sapphire_cup'] = board
        PATH.write_text(json.dumps(existing, indent=2) + '\n')
    print('Sapphire Cup source pixels OK:', f"{board['width']}x{board['height']}",
          'five colors', Counter(board['cells']), len(board['solution']), 'packets')


if __name__ == '__main__':
    main()
