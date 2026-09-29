"""Original procedural interface sounds.

2026-09-26 (Halil): the pickup "tick" was too shrill. Pickups are now soft, low
wooden "tok" notes (felt mallet on a marimba bar: warm fundamental, one quiet
bar partial, a muffled contact and no bright metal), tuned to a calm pentatonic
set so a stream of pickups sounds like a relaxed pattern rather than clicks."""
from pathlib import Path
import math,random,struct,wave
ROOT=Path(__file__).resolve().parents[1]/'assets/audio'

def make(name,seed,kind='pickup'):
    rate=44100; rng=random.Random(seed); length=.22 if kind=='pickup' else .23
    low=0.;slow=0.;filtered=0.;samples=[]
    freq=145+rng.randrange(60)
    metal_shift=rng.uniform(.94,1.06)
    for i in range(int(length*rate)):
        t=i/rate
        noise=rng.uniform(-1,1)
        low+=.09*(noise-low);slow+=.025*(noise-slow)
        # A small magnetic tick, airy fingertip texture and a quiet settling touch.
        if kind=='pickup':
            contact=math.sin(2*math.pi*(650+freq)*t)*.070*math.exp(-t*65)
            metal=sum(amp*math.sin(2*math.pi*hz*metal_shift*t)*math.exp(-t/decay)
                      for hz,amp,decay in [(1620,.090,.027),(2470,.045,.020),(3520,.013,.012)])
            grain=(low-slow)*.30*math.exp(-t*100)
            settle=max(0.,t-.018)
            latch=(math.sin(2*math.pi*1930*metal_shift*settle)*.024+(low-slow)*.10)*math.exp(-settle*155) if t>=.018 else 0.
            value=contact+metal+grain+latch
            filtered+=.52*(value-filtered)
            value=filtered
        else:
            contact=(math.sin(2*math.pi*freq*t)*.11+low*.35)*math.exp(-t*62)
            grain=slow*.18*math.exp(-t*23)
            value=contact+grain
        attack=min(1.,t/(.0025 if kind=='pickup' else .003))
        release=min(1.,(length-t)/.018)
        value=value*attack*release
        if kind=='select':value*=.72
        if kind=='complete':value*=.86
        samples.append(max(-32767,min(32767,round(value*32767))))
    with wave.open(str(ROOT/name),'wb') as f:
        f.setnchannels(1);f.setsampwidth(2);f.setframerate(rate)
        f.writeframes(struct.pack('<'+'h'*len(samples),*samples))

## G3 A3 C4 D4 E4 G4: major pentatonic, low enough to feel "tok", high enough
## to carry on a phone speaker.
TOK_NOTES=[196.00,220.00,261.63,293.66,329.63,392.00]

def make_tok(name,index):
    rate=44100; rng=random.Random(900+index); length=.30
    f0=TOK_NOTES[index]; samples=[]; low=0.; lp=0.
    for i in range(int(length*rate)):
        t=i/rate
        # Slight downward pitch settle, like a struck wooden bar.
        f=f0*(1+.035*math.exp(-t*60))
        body=math.sin(2*math.pi*f*t)*math.exp(-t/.085)
        bar=.16*math.sin(2*math.pi*f*3.93*t)*math.exp(-t/.018)
        sub=.22*math.sin(2*math.pi*f*.5*t)*math.exp(-t/.05)
        low+=.06*(rng.uniform(-1,1)-low)
        felt=low*1.4*math.exp(-t*260)
        value=.62*(body+bar+sub)+felt
        lp+=.35*(value-lp)
        attack=min(1.,t/.004)
        release=min(1.,(length-t)/.03)
        samples.append(max(-32767,min(32767,round(lp*attack*release*.8*32767))))
    with wave.open(str(ROOT/name),'wb') as out:
        out.setnchannels(1);out.setsampwidth(2);out.setframerate(rate)
        out.writeframes(struct.pack('<'+'h'*len(samples),*samples))

def build():
    ROOT.mkdir(exist_ok=True)
    for i in range(6):make_tok(f'pickup_{i}.wav',i)
    make('pick.wav',110,'select');make('complete.wav',330,'complete')
    print('6 soft wooden pickup notes and 2 soft UI effects generated; music is tools/build_music.py.')
if __name__=='__main__':build()
