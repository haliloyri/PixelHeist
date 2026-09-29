#!/usr/bin/env python3
"""Build detailed Stage 1 pixel-art textures without changing puzzle rules.

Run: python3 tools/build_stage_one_pixel_art.py
Verify: python3 tools/build_stage_one_pixel_art.py --check
Requires Pillow. Original image SHA-256 values are checked against the catalog.
The result is a presentation layer, separate from source_pixel_boards.json.
"""

import argparse
import hashlib
import io
import json
from pathlib import Path

from PIL import Image, ImageDraw, ImageEnhance, ImageFilter


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "assets/artworks/pixels"
REVIEW = ROOT / "art_review/stage1_pixels/refined"
CATALOG = ROOT / "data/pixel_visuals.json"
ART_IDS = (
    "girl_with_a_pearl_earring", "starry_night", "moon_gate_mask", "mona_lisa",
    "the_kiss", "the_scream", "birth_of_venus", "water_lilies",
)
ROWS = 32
COLOR_CHOICES = (16, 20, 24)
TARGET_RGB_ERROR = 600


def build(record):
    source = ROOT / record["path"].removeprefix("res://")
    if hashlib.sha256(source.read_bytes()).hexdigest() != record["sha256"]:
        raise ValueError(f"Source checksum changed: {source}")
    with Image.open(source) as original:
        rgb = original.convert("RGB")
        width = round(ROWS * rgb.width / rgb.height)
        # Preserve artwork-defining blue, red and gold when using larger pixels.
        boosted = ImageEnhance.Color(rgb).enhance(1.6)
        boosted = ImageEnhance.Contrast(boosted).enhance(1.1)
        sampled = boosted.resize((width, ROWS), Image.Resampling.LANCZOS)
    sampled = sampled.filter(ImageFilter.UnsharpMask(radius=.7, percent=95, threshold=1))
    for requested in COLOR_CHOICES:
        # MAXCOVERAGE keeps small but defining color regions (such as Vermeer's
        # blue headscarf); median cut spent most slots on near-black shades.
        result = sampled.quantize(colors=requested, method=Image.Quantize.MAXCOVERAGE,
                                  dither=Image.Dither.NONE).convert("RGB")
        error = sum(sum((a - b) ** 2 for a, b in zip(source_pixel, result_pixel))
                    for source_pixel, result_pixel in zip(sampled.getdata(), result.getdata())) / (width * ROWS)
        if error <= TARGET_RGB_ERROR:
            break
    palette_count = len(set(result.getdata()))
    return result, palette_count, round(error, 1)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    records = json.loads((ROOT / "data/artwork_images.json").read_text())
    if not args.check:
        OUTPUT.mkdir(parents=True, exist_ok=True)
        REVIEW.mkdir(parents=True, exist_ok=True)
    sheet = Image.new("RGB", (1200, 4 * 360), "#17253a")
    draw = ImageDraw.Draw(sheet)
    catalog = {}
    for index, art_id in enumerate(ART_IDS):
        original_path = ROOT / records[art_id]["path"].removeprefix("res://")
        pixel, colors, error = build(records[art_id])
        output = OUTPUT / f"{art_id}.png"
        buffer = io.BytesIO()
        pixel.save(buffer, format="PNG")
        encoded = buffer.getvalue()
        catalog[art_id] = {
            "path": f"res://assets/artworks/pixels/{art_id}.png",
            "sha256": hashlib.sha256(encoded).hexdigest(),
            "original_sha256": records[art_id]["sha256"],
            "width": pixel.width, "height": pixel.height, "colors": colors,
        }
        if args.check:
            if output.read_bytes() != encoded:
                raise ValueError(f"Stale pixel image: {output}")
        else:
            output.write_bytes(encoded)
        x, y = (index % 2) * 600, (index // 2) * 360
        draw.text((x + 12, y + 8), f"{art_id} | {pixel.width}x{pixel.height} | {colors} colors", fill="white")
        with Image.open(original_path) as original:
            thumb = original.convert("RGB")
            thumb.thumbnail((270, 310))
        sheet.paste(thumb, (x + 10 + (270 - thumb.width) // 2, y + 34))
        scale = min(270 / pixel.width, 310 / pixel.height)
        enlarged = pixel.resize((round(pixel.width * scale), round(pixel.height * scale)),
                                 Image.Resampling.NEAREST)
        sheet.paste(enlarged, (x + 300 + (270 - enlarged.width) // 2, y + 34))
        print(f"{art_id}: {pixel.width}x{pixel.height}, {colors} colors, RGB MSE {error}")
    if args.check:
        if json.loads(CATALOG.read_text()) != catalog:
            raise ValueError("Stale pixel visual catalog")
    else:
        CATALOG.write_text(json.dumps(catalog, indent=2) + "\n")
        sheet.save(REVIEW / "contact_sheet.png")
    print(f"Review: {REVIEW / 'contact_sheet.png'}")


if __name__ == "__main__":
    main()
