#!/usr/bin/env python3
"""Verify the original-only campaign mapping without opening any save file."""
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
def read(name):
    return json.loads((ROOT / name).read_text())

def main():
    slots = read('data/artwork_placement.json')
    images = read('data/artwork_images.json')
    playable = [art for chapter in read('data/chapters.json')['chapters'] for art in chapter['heists']]
    levels = read('data/levels.json')
    assert [slot['level'] for slot in slots] == list(range(1, 101))
    assert len({slot['art_id'] for slot in slots}) == 100
    assert [slot['art_id'] for slot in slots[:15]] == playable
    assert len(levels) == len(playable) == 15
    assert {level['art_id'] for level in levels} == set(playable)
    checksums = set()
    for slot in slots:
        record = images[slot['art_id']]
        path = ROOT / record['path'].removeprefix('res://')
        digest = hashlib.sha256(path.read_bytes()).hexdigest()
        assert digest == record['sha256'], path
        assert digest not in checksums, f'Duplicate image at level {slot["level"]}'
        checksums.add(digest)
        if slot['level'] > 15:
            for field in ('title', 'artist', 'source_url', 'rights_url', 'rights', 'download_url', 'institution'):
                assert record.get(field), (slot, field)
            assert slot['art_id'] not in playable
            assert record['bytes'] == path.stat().st_size
    print('Original artwork audit OK: 100 unique files, 10 floors, 85 sourced additions, 15 unchanged playable IDs.')

if __name__ == '__main__':
    main()
