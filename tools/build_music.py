"""Original heist background loop: upbeat, adventurous, seamless (2026-09-26, Halil).

Replaces the tense "Insistent" loop in the heist. Everything is synthesised here
(no samples, no third-party material): D minor, 128 BPM, 56 bars (~105 s: intro, theme, bridge, theme with a
harmony voice, turnaround) over Dm - Bb - F - C, with a driving octave bass,
staccato string arpeggios, a heroic brass-like lead, soft pads and adventure
drums with tom fills. The tail of the last bar is wrapped onto the start so the
loop joins without a click.

Requires numpy and ffmpeg (libvorbis). Writes assets/audio/heist_adventure.ogg.
"""
from pathlib import Path
import subprocess
import tempfile
import wave

import numpy as np

ROOT = Path(__file__).resolve().parents[1] / 'assets/audio'
RATE = 44100
BPM = 128
BEAT = 60 / BPM
BARS = 56
LENGTH = int(round(BARS * 4 * BEAT * RATE))
rng = np.random.default_rng(2609)


def hz(midi):
    return 440.0 * 2 ** ((midi - 69) / 12)


def env(n, attack, decay, sustain=0.0, release=0.0, hold=None):
    """Simple ADSR on n samples (times in seconds)."""
    t = np.arange(n) / RATE
    a = np.clip(t / max(attack, 1e-4), 0, 1)
    d = sustain + (1 - sustain) * np.exp(-np.maximum(t - attack, 0) / max(decay, 1e-4))
    e = a * d
    if release > 0:
        end = (hold if hold is not None else n / RATE)
        e *= np.clip((end + release - t) / release, 0, 1)
    return e


def lowpass(x, cutoff):
    alpha = 1 - np.exp(-2 * np.pi * cutoff / RATE)
    y = np.empty_like(x)
    acc = 0.0
    for i, v in enumerate(x):
        acc += alpha * (v - acc)
        y[i] = acc
    return y


def saw(freq, n, detune=0.0):
    t = np.arange(n) / RATE
    out = np.zeros(n)
    for d in (-detune, 0.0, detune) if detune else (0.0,):
        phase = (t * freq * (1 + d)) % 1.0
        out += 2 * phase - 1
    return out / (3 if detune else 1)


def tri(freq, n):
    t = np.arange(n) / RATE
    return 2 * np.abs(2 * ((t * freq) % 1.0) - 1) - 1


def place(track, start, sound, gain=1.0):
    s = int(start * RATE)
    track[s:s + len(sound)] += sound[:max(0, len(track) - s)] * gain


# --- harmony ---------------------------------------------------------------
# Chord roots (MIDI) and triads per bar.
D, Bb, F, C, G, A = 50, 46, 53, 48, 43, 45
MINOR, MAJOR = (0, 3, 7), (0, 4, 7)
Eb = 51
LOOP = [(D, MINOR), (Bb, MAJOR), (F, MAJOR), (C, MAJOR)]
THEME = LOOP * 3 + [(D, MINOR), (Bb, MAJOR), (G, MINOR), (A, MAJOR)]
BRIDGE = [(Bb, MAJOR), (F, MAJOR), (G, MINOR), (D, MINOR), (Eb, MAJOR), (Bb, MAJOR), (A, MAJOR), (A, MAJOR)]
# Sections: (name, first bar, chords). The lead plays in "theme" and "theme2".
SECTIONS = [('intro', 0, LOOP * 2), ('theme', 8, THEME), ('bridge', 24, BRIDGE),
            ('theme2', 32, THEME), ('turnaround', 48, LOOP * 2)]
PROGRESSION = [chord for _, _, chords in SECTIONS for chord in chords]
SECTION_OF = [name for name, _, chords in SECTIONS for _ in chords]

# Lead melody: (bar, beat, length in beats, midi); heroic call and answer.
MELODY = [
    # bars 5-8
    (4, 0, 1.5, 74), (4, 1.5, .5, 76), (4, 2, 2, 77),
    (5, 0, 1, 77), (5, 1, 1, 76), (5, 2, 1, 74), (5, 3, 1, 72),
    (6, 0, 1.5, 72), (6, 1.5, .5, 74), (6, 2, 1, 76), (6, 3, 1, 77),
    (7, 0, 3, 79), (7, 3, 1, 76),
    # bars 9-12
    (8, 0, 1.5, 81), (8, 1.5, .5, 79), (8, 2, 2, 77),
    (9, 0, 1, 77), (9, 1, 1, 79), (9, 2, 2, 82),
    (10, 0, 1.5, 81), (10, 1.5, .5, 79), (10, 2, 1, 77), (10, 3, 1, 76),
    (11, 0, 4, 76),
    # bars 13-16: rising finish into the loop
    (12, 0, 1, 74), (12, 1, 1, 77), (12, 2, 2, 81),
    (13, 0, 1, 82), (13, 1, 1, 81), (13, 2, 2, 77),
    (14, 0, 1.5, 79), (14, 1.5, .5, 77), (14, 2, 2, 74),
    (15, 0, 2, 73), (15, 2, 1, 76), (15, 3, 1, 79),
]


def build():
    tail = int(2 * RATE)
    n = LENGTH + tail
    bass = np.zeros(n)
    strings = np.zeros(n)
    pad = np.zeros(n)
    lead = np.zeros(n)
    drums = np.zeros(n)
    bar_len = 4 * BEAT

    for bar, (root, quality) in enumerate(PROGRESSION):
        start = bar * bar_len
        # Driving octave bass in eighths with a push on the "and" of 4.
        for step in range(8):
            note = root - 12 + (12 if step % 2 else 0)
            length = int(BEAT * .45 * RATE)
            tone = saw(hz(note), length, .004) * env(length, .004, .09, .35, .05)
            place(bass, start + step * BEAT / 2, tone, .32)
        section = SECTION_OF[bar]
        # Staccato string arpeggio in sixteenths (from bar 3; halved in the bridge).
        if bar >= 2 and not (section == 'bridge' and bar % 2):
            chord = [root + 12 + i for i in quality] + [root + 24]
            pattern = [0, 1, 2, 3, 2, 1, 2, 3] * 2
            for step, pick in enumerate(pattern):
                length = int(BEAT * .22 * RATE)
                tone = saw(hz(chord[pick]), length, .006) * env(length, .003, .05, 0)
                place(strings, start + step * BEAT / 4, tone, .10 + .03 * (step % 4 == 0))
        # Soft sustained pad.
        length = int(bar_len * RATE)
        for i in quality:
            tone = tri(hz(root + 12 + i), length) * env(length, .25, 3.0, .7, .2, bar_len - .2)
            place(pad, start, tone, .07)
        # Drums: kick 1, 2&, 3; snare 2, 4; 16th shaker; toms on bar 8 and 16.
        for beat in ((0, 2) if section == 'bridge' else (0, 1.5, 2)):
            k = int(.35 * RATE)
            t = np.arange(k) / RATE
            kick = np.sin(2 * np.pi * (48 + 90 * np.exp(-t * 30)) * t) * np.exp(-t * 9)
            place(drums, start + beat * BEAT, kick, .9)
        for beat in (1, 3):
            s = int(.25 * RATE)
            t = np.arange(s) / RATE
            snare = (rng.uniform(-1, 1, s) * .7 + np.sin(2 * np.pi * 190 * t) * .5) * np.exp(-t * 18)
            place(drums, start + beat * BEAT, lowpass(snare, 5200), .45)
        for step in range(16):
            h = int(.05 * RATE)
            hat = np.diff(rng.uniform(-1, 1, h + 1)) * np.exp(-np.arange(h) / RATE * 70)
            place(drums, start + step * BEAT / 4, hat, .07 if step % 2 else .11)
        if bar % 8 == 7:
            for step, pitch in enumerate([150, 150, 120, 120, 95, 95, 80, 80]):
                s = int(.22 * RATE)
                t = np.arange(s) / RATE
                tom = np.sin(2 * np.pi * pitch * (1 + .3 * np.exp(-t * 25)) * t) * np.exp(-t * 11)
                place(drums, start + 2 * BEAT + step * BEAT / 4, tom, .55)
        if bar % 8 == 0 and section != 'bridge':
            c = int(1.6 * RATE)
            crash = lowpass(rng.uniform(-1, 1, c), 7000) * np.exp(-np.arange(c) / RATE * 2.2)
            place(drums, start, crash, .16)

    # Brass-like lead: detuned saws through a swelling lowpass, gentle vibrato. The
    # theme plays at bar 8 and again at bar 32 with a softer harmony voice a third below;
    # the bridge gets a short low horn call.
    def horn(bar, beat, beats, midi, gain, cutoff=2600):
        length = int((beats * BEAT + .08) * RATE)
        t = np.arange(length) / RATE
        vib = 1 + .006 * np.sin(2 * np.pi * 5.2 * t) * np.clip(t / .25, 0, 1)
        phase = np.cumsum(hz(midi) * vib) / RATE
        tone = sum((2 * ((phase * (1 + d)) % 1) - 1) for d in (-.005, 0, .005)) / 3
        tone = lowpass(tone, cutoff) * env(length, .03, .6, .75, .08, beats * BEAT)
        place(lead, (bar * 4 + beat) * BEAT, tone, gain)
    thirds = {74: 70, 76: 72, 77: 74, 79: 76, 81: 77, 82: 79, 72: 69, 73: 69}
    for offset, harmony in ((4, False), (28, True)):
        for bar, beat, beats, midi in MELODY:
            horn(bar + offset, beat, beats, midi, .20)
            if harmony: horn(bar + offset, beat, beats, thirds.get(midi, midi - 3), .09, 1800)
    for bar, beat, beats, midi in [(26, 0, 2, 62), (26, 2, 2, 65), (27, 0, 4, 67),
                                   (30, 0, 2, 69), (30, 2, 1, 67), (30, 3, 1, 65), (31, 0, 4, 64)]:
        horn(bar, beat, beats, midi, .16, 1600)

    strings = lowpass(strings, 3800)
    bass = lowpass(bass, 900)
    left = bass + drums * .95 + strings * 1.1 + pad * .9 + lead * .85
    right = bass + drums + strings * .9 + pad * 1.1 + lead
    mix = np.stack([left, right], axis=1)
    # Seamless loop: fold the tail back onto the start.
    loop = mix[:LENGTH].copy()
    loop[:tail] += mix[LENGTH:LENGTH + tail]
    loop = np.tanh(loop * 1.2) / np.tanh(1.2)
    # Loudness a little above the old tension loop (RMS ~0.093) so the in-game -25 dB
    # level stays comparable; peak kept below 0.9.
    loop *= min(0.13 / np.sqrt(np.mean(loop ** 2)), 0.89 / np.max(np.abs(loop)))
    pcm = (loop * 32767).astype('<i2')
    ROOT.mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory() as tmp:
        wav_path = Path(tmp) / 'loop.wav'
        with wave.open(str(wav_path), 'wb') as out:
            out.setnchannels(2)
            out.setsampwidth(2)
            out.setframerate(RATE)
            out.writeframes(pcm.tobytes())
        subprocess.run(['ffmpeg', '-y', '-loglevel', 'error', '-i', str(wav_path), '-c:a', 'libvorbis',
                        '-q:a', '5', str(ROOT / 'heist_adventure.ogg')], check=True)
    print(f'heist_adventure.ogg: {LENGTH / RATE:.1f} s seamless loop, {BPM} BPM, D minor, {BARS} bars')


if __name__ == '__main__':
    build()
