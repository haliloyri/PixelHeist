# Pixel Heist documentation

Canonical revision: `2026-09-20-r9`.

| Document | English source | Turkish companion |
| --- | --- | --- |
| Game design (r13), story, 13 screens and economy | [GameDesign.md](GameDesign.md) | [Türkçe tasarım](10-pixel-heist-oyun-cercevesi-ve-ekranlar.md) |
| Phased implementation and acceptance | [ToDoList.md](../ToDoList.md) | [ToDoList.tr.md](../ToDoList.tr.md) |
| Visual direction and reference study | [VisualDirection.md](VisualDirection.md) | [Görsel yön](VisualDirection.tr.md) |

AI implementers read English first; see [AGENTS.md](../AGENTS.md). The paired
documents express the same design and use matching section/screen/task IDs;
they need not have identical sentence lengths. Changes must update both.

The other numbered documents are historical demo references. The root
[README](../README.md) explains how to run the current demo. Current canonical
requirements take precedence over superseded names, traits, content counts or
mechanics in older notes.

Validate structural synchronization with:

```sh
python3 tools/validate_planning_docs.py
```

This is documentation validation, not proof that planned gameplay or four
complete runtime translations have been implemented.

Implementation references: [Development](Development.md), [Architecture](Architecture.md), [P01 handoff](P01-Implementation.md), [P02 handoff](P02-Implementation.md), [P03 handoff](P03-Implementation.md), [P04 handoff](P04-Implementation.md), [P05 handoff](P05-Implementation.md), [P06 handoff](P06-Implementation.md), [P07 handoff](P07-Implementation.md), [P08 report](P08-Implementation.md), [P08 playtest protocol](P08-Playtest.md), [persistence contract](Persistence.md), [campaign contract](Campaign.md), [economy contract](Economy.md). P01–P07 are complete; P08 is in progress.
