"""Prepare credited CC0 assets with subdued high frequencies and a seamless loop join.
Requires ffmpeg only when rebuilding, never at game runtime.
"""
from pathlib import Path
from array import array
import subprocess,tempfile,wave,sys
ROOT=Path(__file__).resolve().parents[1]/'assets/audio'

def prepare(source,name,cutoff,overlap):
    rate=44100
    raw=subprocess.check_output(['ffmpeg','-v','error','-i',str(ROOT/'sources'/source),
        '-af',f'highpass=f=45,lowpass=f={cutoff}','-ar',str(rate),'-ac','2','-f','s16le','-'])
    samples=array('h');samples.frombytes(raw)
    if sys.byteorder!='little':samples.byteswap()
    count=int(rate*overlap)*2
    loop=array('h',samples[count:])
    for i in range(count):
        mix=(i//2)/(count//2-1)
        loop[len(loop)-count+i]=round(loop[len(loop)-count+i]*(1-mix)+samples[i]*mix)
    gain=.7*32767/max(1,max(abs(v) for v in loop))
    loop=array('h',(round(v*gain) for v in loop))
    if sys.byteorder!='little':loop.byteswap()
    with tempfile.TemporaryDirectory() as temp:
        path=Path(temp)/'loop.wav'
        with wave.open(str(path),'wb') as w:
            w.setparams((2,2,rate,0,'NONE','not compressed'));w.writeframes(loop.tobytes())
        subprocess.run(['ffmpeg','-v','error','-y','-i',str(path),'-c:a','vorbis','-strict','experimental','-q:a','4',str(ROOT/name)],check=True)
    print(name,'seconds',round(len(loop)/2/rate,2))

if __name__=='__main__':
    prepare('engineCircular_000.ogg','drone_motor.ogg',1100,.35)
    prepare('Insistent.ogg','heist_tension.ogg',4200,.8)
