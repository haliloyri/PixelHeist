#!/usr/bin/env python3
"""Validate a clean temporary copy; never launch tests against the player save."""

import argparse
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import platform
import re
import shutil
import signal
import subprocess
import sys
import tempfile
import time

ROOT = Path(__file__).resolve().parents[1]
ERRORS = re.compile(r"(?m)^(?:SCRIPT ERROR:|ERROR:|FAIL:)|FAILURES:\s*[1-9]")
ANSI = re.compile(r"\x1b\[[0-9;]*m")
EXCLUDED = {".godot", ".git", ".backups", ".DS_Store", "__pycache__", "artifacts"}


def find_godot(explicit):
    candidates = [explicit, os.environ.get("GODOT_BIN"), shutil.which("godot"),
                  shutil.which("godot4"),
                  str(Path.home() / "Downloads/Godot.app/Contents/MacOS/Godot"),
                  "/Applications/Godot.app/Contents/MacOS/Godot"]
    for candidate in candidates:
        if candidate and Path(candidate).is_file() and os.access(candidate, os.X_OK):
            return str(Path(candidate).resolve())
    raise ValueError("Godot editor binary not found. Set GODOT_BIN or pass --godot.")


def application_data_path(name):
    if platform.system() == "Darwin":
        base = Path.home() / "Library/Application Support/Godot/app_userdata"
    elif platform.system() == "Windows":
        base = Path(os.environ["APPDATA"]) / "Godot/app_userdata"
    else:
        base = Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local/share")) / "godot/app_userdata"
    return base / name


def run_step(name, command, cwd, output, env, timeout, summary, marker=None):
    started = time.monotonic()
    timed_out = False
    try:
        with subprocess.Popen(command, cwd=cwd, env=env, stdout=subprocess.PIPE,
                              stderr=subprocess.STDOUT, text=True,
                              start_new_session=os.name != "nt") as process:
            try:
                log, _ = process.communicate(timeout=timeout)
                code = process.returncode
            except subprocess.TimeoutExpired:
                # Fault-injection suites spawn workers. Stop the whole isolated
                # process group so a child cannot hold the output pipe open.
                if os.name == "nt":
                    subprocess.run(["taskkill", "/PID", str(process.pid), "/T", "/F"],
                                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
                else:
                    os.killpg(process.pid, signal.SIGKILL)
                log, _ = process.communicate()
                code, timed_out = -1, True
                log += "\nVALIDATOR TIMEOUT\n"
    except subprocess.TimeoutExpired as error:
        code, timed_out = -1, True
        captured = error.stdout or b""
        log = captured.decode(errors="replace") if isinstance(captured, bytes) else captured
        log += "\nVALIDATOR TIMEOUT\n"
    (output / (name + ".log")).write_text(log, encoding="utf-8")
    clean_log = ANSI.sub("", log)
    passed = code == 0 and not ERRORS.search(clean_log) and (not marker or marker in clean_log)
    item = {"name": name, "passed": bool(passed), "exit_code": code,
            "timeout": timed_out, "seconds": round(time.monotonic() - started, 2),
            "command": command, "log": name + ".log"}
    summary["steps"].append(item)
    print(f"{'PASS' if passed else 'FAIL'} {name} ({item['seconds']}s)", flush=True)
    if not passed:
        print("\n".join(line for line in clean_log.splitlines() if ERRORS.search(line)), flush=True)
        print(clean_log[-1200:], flush=True)
    return passed


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--godot", help="Godot editor executable (or set GODOT_BIN)")
    parser.add_argument("--output", type=Path, help="New directory for preserved evidence")
    parser.add_argument("--heist-intro", action="store_true", help="Capture the red bee opening in the isolated GPU project")
    parser.add_argument("--motion-preview", action="store_true", help="Capture distance-synced walking and beam transfer animation frames")
    parser.add_argument("--heist-feedback", action="store_true", help="Capture walking ants, bold type, large packets and actual take-off")
    parser.add_argument("--heist-layout", action="store_true", help="Capture the v4 gameplay layout in the isolated GPU project")
    parser.add_argument("--visual", action="store_true", help="Capture using a real display/GPU")
    parser.add_argument("--source-pixels", action="store_true", help="Capture source-derived Sun Seal board and original comparison")
    parser.add_argument("--sapphire-cup", action="store_true", help="Capture source-derived Sapphire Cup board and original comparison")
    parser.add_argument("--stage-one-pixel-visuals", action="store_true", help="Capture detailed Stage 1 pixel art in heist and Museum")
    parser.add_argument("--stage-museum", action="store_true", help="Capture museum floors, collection and real PNG exports")
    parser.add_argument("--screen-refresh", action="store_true", help="Capture Settings, Crew and Rewards at two portrait sizes")
    parser.add_argument("--level-complete", action="store_true", help="Capture victory states and the finite celebration animation")
    parser.add_argument("--reward-celebration", action="store_true", help="Capture reward confetti and reduced motion at two portrait sizes")
    parser.add_argument("--case-file", action="store_true", help="Capture stage dossiers and read-only story replay at two portrait sizes")
    parser.add_argument("--lobby-reference", action="store_true", help="Capture the approved home at standard and tall sizes")
    parser.add_argument("--audio-driver", default="CoreAudio" if platform.system() == "Darwin" else "Dummy",
                        help="Defaults to CoreAudio on macOS, Dummy elsewhere")
    parser.add_argument("--timeout", type=int, default=300, help="Maximum seconds per process")
    parser.add_argument("--suite", action="append", help="Run only this test stem (repeatable); default all suites")
    args = parser.parse_args()
    godot = find_godot(args.godot)
    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    output = (args.output or ROOT / "artifacts/validation" / stamp).resolve()
    output.mkdir(parents=True, exist_ok=False)
    version = subprocess.check_output([godot, "--version"], text=True).strip()
    summary = {"started_utc": stamp, "godot": version, "host": platform.platform(),
               "audio_driver": args.audio_driver, "visual_requested": args.visual,
               "steps": []}
    isolated_userdata = None
    try:
        with tempfile.TemporaryDirectory(prefix="pixel-heist-validation-") as temporary:
            temp = Path(temporary)
            project = temp / "project"
            # No imported cache, external links, or previous test artifacts are copied.
            for path in ROOT.rglob("*"):
                if not any(part in EXCLUDED for part in path.relative_to(ROOT).parts) and path.is_symlink():
                    raise ValueError(f"Refusing symlink in clean test copy: {path}")
            shutil.copytree(ROOT, project, ignore=shutil.ignore_patterns(*EXCLUDED))
            (project / "artifacts").mkdir()
            manifest = {str(p.relative_to(project)): hashlib.sha256(p.read_bytes()).hexdigest()
                        for p in sorted(project.rglob("*")) if p.is_file()}
            (output / "source_manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
            # A distinct application identity is a second barrier if a test forgets test_mode.
            config = project / "project.godot"
            config_text = config.read_text()
            if 'config/name="Pixel Heist"' not in config_text or "config/use_custom_user_dir" in config_text:
                raise ValueError("Project user-data configuration changed; review test isolation before running.")
            app_name = f"Pixel Heist Validation {temp.name}"
            userdata = application_data_path(app_name)
            if userdata.exists():
                raise ValueError("Refusing to reuse an existing test application data directory.")
            isolated_userdata = userdata
            summary["isolated_application_data"] = str(userdata)
            config.write_text(config_text.replace('config/name="Pixel Heist"', f'config/name="{app_name}"'))
            env = os.environ.copy()
            env["PIXEL_HEIST_TEST_DIR"] = str(temp / "saves")
            (temp / "saves").mkdir()
            # Portable editor settings/cache: do not write to the installed editor's profile.
            portable = temp / "engine"
            portable.mkdir()
            binary = Path(godot)
            if platform.system() == "Darwin" and binary.parent.name == "MacOS":
                bundle = binary.parent.parent.parent
                copied_bundle = portable / bundle.name
                subprocess.run(["ditto", str(bundle), str(copied_bundle)], check=True)
                portable_binary = copied_bundle / "Contents/MacOS" / binary.name
            else:
                portable_binary = portable / binary.name
                shutil.copy2(godot, portable_binary)
            (portable / "_sc_").touch()
            summary["temporary_project"] = str(project)
            summary["save_isolation"] = "Unique application identity, test_mode, and per-process temporary save fixtures"
            common = [str(portable_binary), "--path", str(project)]

            def step(name, command, marker=None):
                return run_step(name, command, project, output, env, args.timeout, summary, marker)

            step("planning", [sys.executable, "tools/validate_planning_docs.py"], "Planning docs OK")
            step("localization", [sys.executable, "tools/build_localization.py", "--check"], "Localization OK")
            step("chapters", [sys.executable, "tools/build_chapters.py", "--check"], "Chapters OK")
            imported = step("import", common + ["--headless", "--editor", "--import",
                                               "--log-file", str(temp / "import.log")])
            if imported:
                step("main_scene", common + ["--headless", "--quit-after", "3",
                     "--log-file", str(temp / "main.log"), "--", "--test-mode"])
                for script in sorted((project / "tests").glob("test_*.gd")):
                    if args.suite and script.stem not in args.suite:
                        continue
                    step(script.stem, common + ["--headless", "--audio-driver", args.audio_driver,
                         "--log-file", str(temp / (script.stem + ".log")),
                         "--script", "res://tests/" + script.name], "FAILURES: 0")
                if args.suite:
                    discovered = {s.stem for s in (project / "tests").glob("test_*.gd")}
                    for missing in set(args.suite) - discovered:
                        summary["steps"].append({"name": missing, "passed": False, "reason": "unknown_suite"})
                if args.source_pixels:
                    step("capture_source_pixels", common + ["--rendering-method", "gl_compatibility",
                         "--audio-driver", "Dummy", "--script", "res://tests/capture_source_pixels.gd"], "SOURCE PIXEL CAPTURES: 9")
                    for png in (project / "artifacts").glob("sun-seal-*.png"):
                        shutil.copy2(png, output / png.name)
                if args.sapphire_cup:
                    step("capture_sapphire_cup_pixels", common + ["--rendering-method", "gl_compatibility",
                         "--audio-driver", "Dummy", "--script", "res://tests/capture_sapphire_cup_pixels.gd"], "SAPPHIRE CUP CAPTURES: 5")
                    for png in (project / "artifacts").glob("sapphire-cup-*.png"):
                        shutil.copy2(png, output / png.name)
                if args.stage_one_pixel_visuals:
                    step("capture_stage_one_pixel_visuals", common + ["--rendering-method", "gl_compatibility",
                         "--audio-driver", "Dummy", "--script", "res://tests/capture_stage_one_pixel_visuals.gd"], "STAGE ONE VISUAL CAPTURES: 6")
                    for png in (project / "artifacts").glob("stage1-visual-*.png"):
                        shutil.copy2(png, output / png.name)
                if args.stage_museum:
                    step("capture_stage_museum", common + ["--rendering-method", "gl_compatibility",
                         "--audio-driver", "Dummy", "--script", "res://tests/capture_stage_museum.gd"], "MUSEUM CAPTURES: 28")
                    for png in (project / "artifacts").glob("museum-*.png"):
                        shutil.copy2(png, output / png.name)
                if args.screen_refresh:
                    step("capture_screen_refresh", common + ["--rendering-method", "gl_compatibility",
                         "--audio-driver", "Dummy", "--script", "res://tests/capture_screen_refresh.gd"], "SCREEN REFRESH CAPTURES: 22")
                    for png in (project / "artifacts").glob("refresh-*.png"):
                        shutil.copy2(png, output / png.name)
                if args.level_complete:
                    step("capture_level_complete", common + ["--rendering-method", "gl_compatibility",
                         "--audio-driver", "Dummy", "--script", "res://tests/capture_level_complete.gd"], "LEVEL COMPLETE CAPTURES: 10 | ANIMATION FRAMES: 84")
                    for png in (project / "artifacts").glob("victory-*.png"):
                        shutil.copy2(png, output / png.name)
                    frames = project / "artifacts/victory-frames"
                    if frames.exists(): shutil.copytree(frames, output / "victory-frames")
                if args.reward_celebration:
                    step("capture_reward_celebration", common + ["--rendering-method", "gl_compatibility",
                         "--audio-driver", "Dummy", "--script", "res://tests/capture_reward_celebration.gd"], "REWARD CELEBRATION CAPTURES: 6 | ANIMATION FRAMES: 84")
                    for png in (project / "artifacts").glob("reward-celebration-*.png"):
                        shutil.copy2(png, output / png.name)
                    frames = project / "artifacts/reward-celebration-frames"
                    if frames.exists(): shutil.copytree(frames, output / "reward-celebration-frames")
                if args.case_file:
                    step("capture_case_file", common + ["--rendering-method", "gl_compatibility",
                         "--audio-driver", "Dummy", "--script", "res://tests/capture_case_file.gd"], "CASE FILE CAPTURES: 14")
                    for png in (project / "artifacts").glob("case-file-*.png"):
                        shutil.copy2(png, output / png.name)
                if args.lobby_reference:
                    step("capture_lobby_reference", common + ["--rendering-method", "gl_compatibility",
                         "--audio-driver", "Dummy", "--script", "res://tests/capture_lobby_reference.gd"], "LOBBY CAPTURES: 8")
                    for png in (project / "artifacts").glob("lobby-v2-*.png"):
                        shutil.copy2(png, output / png.name)
                if args.heist_intro:
                    step("capture_heist_intro", common + ["--rendering-method", "gl_compatibility",
                         "--audio-driver", "Dummy", "--script", "res://tests/capture_heist_intro.gd"], "INTRO CAPTURE: 216 frames")
                    frames = project / "artifacts/intro-frames"
                    if frames.exists(): shutil.copytree(frames, output / "intro-frames")
                if args.motion_preview:
                    step("capture_motion_feedback", common + ["--rendering-method", "gl_compatibility",
                         "--audio-driver", "Dummy", "--script", "res://tests/capture_motion_feedback.gd"], "MOTION CAPTURE: 156 frames")
                    frames = project / "artifacts/motion-frames"
                    if frames.exists(): shutil.copytree(frames, output / "motion-frames")
                if args.heist_feedback:
                    step("capture_heist_feedback", common + ["--rendering-method", "gl_compatibility",
                         "--audio-driver", "Dummy", "--script", "res://tests/capture_heist_feedback.gd"], "HEIST FEEDBACK CAPTURES: 4")
                    for png in (project / "artifacts").glob("feedback-*.png"):
                        shutil.copy2(png, output / png.name)
                if args.heist_layout:
                    step("capture_heist_v4", common + ["--rendering-method", "gl_compatibility",
                         "--audio-driver", "Dummy", "--script", "res://tests/capture_heist_v4.gd"], "HEIST V4 CAPTURES: 6")
                    for png in (project / "artifacts").glob("v4-*.png"):
                        shutil.copy2(png, output / png.name)
                if args.visual:
                    # r13: one walkthrough captures all 13 screens and pop-ups.
                    capture = project / "tests/capture_r13.gd"
                    marker = "R13 CAPTURES:"
                    step("capture", common + ["--rendering-method", "gl_compatibility",
                         "--audio-driver", "Dummy", "--log-file", str(temp / "capture.log"),
                         "--script", "res://tests/" + capture.name], marker)
                    if (project / "tests/capture_localization.gd").exists():
                        step("capture_localization", common + ["--rendering-method", "gl_compatibility",
                             "--audio-driver", "Dummy", "--log-file", str(temp / "l10n-capture.log"),
                             "--script", "res://tests/capture_localization.gd"], "LOCALIZATION CAPTURES: 41 | FAILURES: 0")
                    if (project / "tests/capture_campaign.gd").exists():
                        step("capture_campaign", common + ["--rendering-method", "gl_compatibility",
                             "--audio-driver", "Dummy", "--log-file", str(temp / "campaign-capture.log"),
                             "--script", "res://tests/capture_campaign.gd"], "CAMPAIGN CAPTURES: 39 | FAILURES: 0")
                    for png in list((project / "artifacts").glob("*.png")) + list((project / "artifacts/r13").glob("*.png")):
                        shutil.copy2(png, output / png.name)
                    if not list(output.glob("*.png")):
                        summary["steps"].append({"name": "capture_images", "passed": False})
                for artifact in (project / "artifacts").glob("*.json"):
                    shutil.copy2(artifact, output / artifact.name)
            summary["passed"] = all(item["passed"] for item in summary["steps"])
    finally:
        # Only this invocation's previously nonexistent app directory is eligible.
        if isolated_userdata is not None and isolated_userdata.exists():
            try:
                shutil.rmtree(isolated_userdata)
                summary["application_data_cleaned"] = True
            except OSError as error:
                summary["passed"] = False
                summary["cleanup_error"] = str(error)
        (output / "summary.json").write_text(json.dumps(summary, indent=2) + "\n")
    print(f"Evidence: {output}")
    return 0 if summary.get("passed") else 1


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print(f"Validation failed: {error}", file=sys.stderr)
        sys.exit(1)
