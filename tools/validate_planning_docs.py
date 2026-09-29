#!/usr/bin/env python3
"""Check the paired planning documents, not gameplay or translation quality."""

from pathlib import Path
import re
import sys


ROOT = Path(__file__).resolve().parents[1]
DESIGNS = (
    ROOT / "docs/GameDesign.md",
    ROOT / "docs/10-pixel-heist-oyun-cercevesi-ve-ekranlar.md",
)
TODOS = (ROOT / "ToDoList.md", ROOT / "ToDoList.tr.md")
VISUALS = (ROOT / "docs/VisualDirection.md", ROOT / "docs/VisualDirection.tr.md")
CAST = {
    "rocco": "Rocco “Pixel”",
    "sprocket": "Sprocket",
    "quill": "Quill",
    "frost": "Mr. Frost",
    "glimmer": "Baron Glimmer",
    "tuck": "Tuck",
    "barnaby": "Barnaby Bramble",
}


def require(condition, message):
    if not condition:
        raise ValueError(message)


def section(text, number):
    match = re.search(
        rf"^## {number}\. .*?\n(.*?)(?=^## \d+\. |\Z)",
        text,
        re.M | re.S,
    )
    require(match is not None, f"Missing design section {number}")
    return match.group(1)


def main():
    paired = {path: path.read_text(encoding="utf-8") for path in (*DESIGNS, *TODOS, *VISUALS)}
    revisions = []
    for path, text in paired.items():
        match = re.search(r"(?:Revision|Revizyon): `([^`]+)`", text)
        require(match is not None, f"No revision: {path.name}")
        revisions.append(match.group(1))
        require(text.count("```") % 2 == 0, f"Unclosed code fence: {path.name}")
        require("\ufffd" not in text, f"Invalid character: {path.name}")
    require(len(set(revisions)) == 1, "Document revisions differ")

    for path in VISUALS:
        headings = [int(n) for n in re.findall(r"^## (\d+)\.", paired[path], re.M)]
        require(headings == list(range(1, 9)), f"Visual direction section IDs: {path.name}")

    for path in DESIGNS:
        text = paired[path]
        headings = [int(n) for n in re.findall(r"^## (\d+)\.", text, re.M)]
        require(headings == list(range(1, 19)), f"Section IDs: {path.name}")
        screens = re.findall(r"^### (S\d+) —", text, re.M)
        require(screens == [f"S{i}" for i in range(1, 7)], f"Screen IDs: {path.name}")
        popups = re.findall(r"^### (P\d+) —", text, re.M)
        require(popups == [f"P{i}" for i in range(1, 8)], f"Pop-up IDs: {path.name}")
        levels = [int(n) for n in re.findall(r"^\| (\d+) \|", section(text, 6), re.M)]
        require(levels == list(range(1, 21)), f"Campaign chapters: {path.name}")
        cast_text = section(text, 16)
        for character_id, name in CAST.items():
            require(f"| `{character_id}` | {name} |" in cast_text,
                    f"Cast mismatch {character_id}: {path.name}")
        # Explicit product totals must appear in the summary, not only historical notes.
        intro = section(text, 1)
        for count in (20, 100, 13):
            require(re.search(rf"\b{count}\b", intro), f"Missing total {count}: {path.name}")

    task_maps = []
    for path in TODOS:
        text = paired[path]
        tasks = re.findall(r"^- \[([ x])\] \*\*(P\d{2}-\d{2})\*\* —", text, re.M)
        require(bool(tasks), f"No tasks: {path.name}")
        mapping = {task_id: state for state, task_id in tasks}
        require(len(mapping) == len(tasks), f"Duplicate task IDs: {path.name}")
        phases = re.findall(r"^## (P\d{2}) —", text, re.M)
        require(phases == [f"P{i:02}" for i in range(17)], f"Phase IDs: {path.name}")
        for phase in phases:
            ids = [task_id for _, task_id in tasks if task_id.startswith(phase + "-")]
            require(ids == [f"{phase}-{i:02}" for i in range(1, len(ids) + 1)],
                    f"Nonsequential task IDs: {path.name}: {phase}")
        blockers = re.findall(r"^\| (B\d{2}) \|", text, re.M)
        require(blockers == [f"B{i:02}" for i in range(1, 9)], f"Input IDs: {path.name}")
        task_maps.append(mapping)
    require(task_maps[0] == task_maps[1], "English/Turkish task IDs or statuses differ")

    # Check ordinary local Markdown links; remote sources are not fetched here.
    extra = (ROOT / "AGENTS.md", ROOT / "docs/README.md", ROOT / "README.md")
    for path in (*paired, *extra):
        text = paired.get(path) or path.read_text(encoding="utf-8")
        for target in re.findall(r"\[[^\]\n]+\]\(([^)\s]+)\)", text):
            if re.match(r"^[a-zA-Z]+://", target) or target.startswith("#"):
                continue
            local = target.split("#", 1)[0].strip("<>")
            require((path.parent / local).exists(), f"Broken local link: {path.name}: {target}")

    count = len(task_maps[0])
    completed = sum(state == "x" for state in task_maps[0].values())
    print(f"Planning docs OK — revision {revisions[0]}")
    print("18 paired design sections; 6 screens + 7 pop-ups; 20 chapters; 7 canonical characters.")
    print(f"17 phases; {count} matching tasks: {completed} complete, {count - completed} pending.")
    print("Local links and task states match.")
    print("Eight paired visual-direction sections and their local links validated.")
    print("Structural validation only: runtime, editorial and device acceptance remain separate.")


if __name__ == "__main__":
    try:
        main()
    except (OSError, ValueError) as error:
        print(f"Planning docs FAILED: {error}", file=sys.stderr)
        sys.exit(1)
