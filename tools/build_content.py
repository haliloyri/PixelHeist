"""Author tile maps with Python stdlib and queues with the Godot simulation.
Run from the repository root. Outputs are checked in; the game needs no Python.
"""
from pathlib import Path
from collections import Counter, deque
import json, math, random, wave, struct

# 2026-09-26 (Halil): every board is filled from below only, and the unwanted
# "not in this painting" packets come in several colours, not just pink. The live
# data/levels.json picks the two extra colours per painting for contrast.
DECOY_COLOURS=['#dd5daa','#e23c3c','#8a5cd6']

ROOT = Path(__file__).resolve().parents[1]

def canvas(w, h, bg=-1): return [[bg] * w for _ in range(h)]
def rim(grid, color):
    w=len(grid[0])
    return [[color]*(w+2)]+[[color]+row+[color] for row in grid]+[[color]*(w+2)]
def rect(a,x,y,w,h,c):
    for yy in range(max(0,y),min(len(a),y+h)):
        for xx in range(max(0,x),min(len(a[0]),x+w)): a[yy][xx]=c

def ellipse(a,cx,cy,rx,ry,c):
    for y in range(len(a)):
        for x in range(len(a[0])):
            if ((x-cx)/rx)**2+((y-cy)/ry)**2<=1: a[y][x]=c

def poly(a,pts,c):
    for y in range(len(a)):
        for x in range(len(a[0])):
            inside=False
            j=len(pts)-1
            for i,(xi,yi) in enumerate(pts):
                xj,yj=pts[j]
                if ((yi>y)!=(yj>y)) and x<(xj-xi)*(y-yi)/(yj-yi)+xi: inside=not inside
                j=i
            if inside:a[y][x]=c

def seal():
    a=canvas(13,13)
    ellipse(a,6,6,5.8,5.8,0)
    ellipse(a,6,6,4.2,4.2,1)
    poly(a,[(6,2),(10,6),(6,11),(2,6)],0)
    rect(a,5,4,3,5,2);rect(a,4,5,5,2,2)
    return a

def cup():
    a=canvas(17,16)
    ellipse(a,12,7,3.5,4.5,0);ellipse(a,12,7,1.5,2.5,-1)
    rect(a,3,3,9,9,0);rect(a,4,12,7,2,0)
    rect(a,4,4,6,7,1);rect(a,4,4,2,7,2)
    rect(a,3,3,9,2,2);rect(a,4,2,7,1,3)
    rect(a,6,7,3,3,3);rect(a,7,6,1,5,3)
    return a

def pearl():
    a=canvas(24,28,0)
    poly(a,[(2,28),(4,23),(10,19),(17,20),(22,28)],4)
    poly(a,[(7,28),(8,23),(13,21),(20,25),(21,28)],3)
    poly(a,[(12,17),(17,16),(17,22),(12,23),(9,21)],2)
    ellipse(a,12,13,6.1,8.4,3)
    poly(a,[(9,8),(16,8),(18,12),(17,15),(19,16),(17,18),(13,21),(10,19),(9,15)],2)
    poly(a,[(5,11),(4,7),(7,3),(12,2),(17,5),(19,8),(17,10),(11,8)],1)
    poly(a,[(8,3),(13,2),(18,5),(20,13),(20,20),(18,23),(17,14),(16,7)],3)
    poly(a,[(5,9),(8,6),(13,6),(17,9),(16,11),(10,9)],4)
    rect(a,13,12,3,1,0);rect(a,14,12,1,1,4)
    rect(a,16,15,1,1,3);rect(a,14,18,2,1,3)
    rect(a,9,17,1,3,0);rect(a,9,20,2,2,4);rect(a,10,20,1,1,2)
    return a

def stars():
    a=canvas(32,24,0)
    for x in range(32):
        for k in (0,1):
            yy=round(7+3*math.sin(x*.23+k*.6))
            rect(a,x,yy+k,1,2,1)
        yy=round(13+1.5*math.sin(x*.31))
        rect(a,x,yy,1,1,2)
    for x,y,r in [(4,3,1.6),(12,4,1.4),(19,3,1.2),(24,7,1.3),(16,11,1.3),(29,12,1.0)]:
        ellipse(a,x,y,r+1,r+1,1);ellipse(a,x,y,r,r,3);rect(a,x,y,1,1,4)
    ellipse(a,27,3,3.0,3,3);ellipse(a,28,2,2,2,4)
    poly(a,[(0,20),(4,17),(8,19),(13,16),(19,17),(23,15),(32,17),(32,24),(0,24)],1)
    poly(a,[(0,22),(6,20),(11,21),(18,18),(24,19),(32,17),(32,24),(0,24)],5)
    for x,y in [(11,20),(15,19),(20,20),(25,19),(29,20)]:
        rect(a,x,y,3,3,2);poly(a,[(x-1,y),(x+1,y-2),(x+4,y)],0);rect(a,x+1,y+1,1,1,3)
    rect(a,17,17,2,7,0);poly(a,[(16,17),(18,12),(20,17)],0)
    poly(a,[(2,24),(3,17),(2,14),(4,11),(4,5),(6,9),(7,15),(9,18),(9,24)],5)
    poly(a,[(4,23),(5,15),(5,9),(6,17),(8,23)],0)
    return a

def mask():
    a=canvas(24,28)
    poly(a,[(4,3),(9,1),(15,1),(20,3),(22,8),(21,19),(17,25),(12,27),(7,25),(3,19),(2,8)],0)
    poly(a,[(5,5),(10,3),(14,3),(19,5),(20,17),(17,22),(12,25),(7,22),(4,17)],1)
    for x in [5,8,11,14,17]:rect(a,x,3,2,4,2)
    poly(a,[(5,9),(10,8),(11,12),(9,15),(5,14)],3)
    poly(a,[(14,8),(19,9),(19,14),(15,15),(13,12)],3)
    rect(a,6,10,4,2,4);rect(a,15,10,4,2,4)
    rect(a,7,10,2,1,5);rect(a,16,10,2,1,5)
    poly(a,[(12,8),(14,16),(12,18),(10,16)],2)
    rect(a,9,20,7,2,3);rect(a,10,20,5,1,5)
    for y in [9,13,17]:
        rect(a,3,y,2,2,4);rect(a,20,y,2,2,4)
    rect(a,10,24,5,1,2)
    return a

def accessible(board,w,h):
    q=deque([(-1,-1)]);seen={(-1,-1)};out=set()
    while q:
        x,y=q.popleft()
        for nx,ny in ((x-1,y),(x+1,y),(x,y-1),(x,y+1)):
            if not(-1<=nx<=w and -1<=ny<=h) or (nx,ny) in seen:continue
            seen.add((nx,ny))
            if 0<=nx<w and 0<=ny<h and board[ny*w+nx]>=0:out.add(ny*w+nx)
            else:q.append((nx,ny))
    return sorted(out)

def packets_for(cells,w,h,level):
    b=cells.copy();packets=[];r=random.Random(931+level)
    while any(c>=0 for c in b):
        edge=accessible(b,w,h)
        color=Counter(b[i] for i in edge).most_common(1)[0][0]
        limit=r.randint(3,7) if level>=5 else r.randint(5,9);amount=0
        while amount<limit:
            match=[i for i in accessible(b,w,h) if b[i]==color]
            if not match:break
            b[match[0]]=-1;amount+=1
        packets.append({'color':color,'amount':amount})
    return packets

META=[
('Sessiz Giriş','Güneş Mührü','HAZIRLIK ODASI', ['#b27b43','#ebc985','#73cdbd'],seal,
 'Sprocket','Bir kapsül seç. Dronlar aynı renkteki parçaları sığınağa taşıyacak.',
 'Rocco','Küçük bir başlangıç. Büyük bir gece.', 'İlk eser güvende. Artık gerçek işe geçebiliriz.'),
('Camın Ardında','Safir Kupa','RESTORASYON ODASI',['#307f9b','#66b5ca','#d8ebdd','#e6b962'],cup,
 'Sprocket','İçeride kalan renkler bekler. Önce dıştaki parçalarla yolu aç.',
 'Küratör','Güzel. Kayıtlarımda yerini aldı bile.', 'Daha teslim etmeden eseri tanıdı. Bizi ne kadar yakından izliyor?'),
('İnci','İnci Küpeli Kız','BATI GALERİSİ',['#223c49','#4e99bb','#f5d6a1','#b78752','#e7e9d5'],pearl,
 'Rocco','Üç yuvam var. Her kapsülü hemen açmak iyi bir fikir olmayabilir.',
 'Küratör','Çerçevenin arkasıyla ilgilenme. Siparişi tamamla.', 'Çerçevede ikinci bir envanter damgası: V–017. Müzenin kaydı değil.'),
('Yıldızlar','Yıldızlı Gece','KUZEY GALERİSİ',['#254d79','#477da3','#83b7bf','#d7b861','#f5dfa0','#243b3d'],stars,
 'Sprocket','Sıranın arkasına da bak. Bir yuvayı boş tutmak bütün planı kurtarabilir.',
 'Sprocket','Aynı damga. Rocco, bizim cihazda da bu numaralama var.', 'V–018. Eserler ve cihaz aynı koleksiyonun parçaları olarak işaretlenmiş.'),
('Son Parça','Ay Kapısı Maskesi','ÖZEL KOLEKSİYON',['#ac7944','#e4b86b','#f6d997','#34494d','#74bfb0','#edf0d5'],mask,
 'Küratör','Son parçayı da gönder, Piksel. Anlaşmamız bitsin.',
 'Sprocket','Son teslim: aktarım çekirdeği. Operatör gerekli değil… Bu bizim cihaz!', 'Rocco: “Teslimat adresi değişti.” Eserler bizde kalıyor. Bu kez onların planını biz bozacağız.')]

def build():
    from chapter_two import META2
    from chapter_three import META3
    levels=[]
    for idx,(mission,title,room,palette,draw,speaker,intro,end_speaker,outro,clue) in enumerate(META+META2+META3):
        grid=draw()
        if idx in [3,4]: grid=rim(grid, 5 if idx==3 else 3)
        h=len(grid);w=len(grid[0]);cells=sum(grid,[])
        packets=packets_for(cells,w,h,idx)
        lane_count=5 if idx>=10 else 3
        lanes=[[] for _ in range(lane_count)];solution=[];rng=random.Random(871+idx)
        for n,p in enumerate(packets):
            if idx in [3,4]:
                # One route starts with the exterior seal. The other two expose
                # tempting later colours: filling three of these causes a real jam.
                exterior=5 if idx==3 else 3
                lane=0 if p['color']==exterior else 1+rng.randrange(2)
            else:
                lane=(n%3) if idx<2 else rng.randrange(lane_count)
            if idx>=5 and n%5==1:
                lanes[lane].append({'color':len(palette)+(n//5)%len(DECOY_COLOURS),'amount':rng.randint(3,5),'decoy':True})
                solution.append(-lane-1)
            lanes[lane].append(p);solution.append(lane)
        # Mystery hides preview data only; front-row packets are always revealed.
        for column,lane_packets in enumerate(lanes):
            for depth,packet in enumerate(lane_packets):
                if depth>0 and (depth+column)%4==1:packet['mystery']=True
        # Balanced distribution retains the authored global solution.
        level={'slot_count':lane_count,'id':idx,'chapter':1+idx//5,'stage':1+idx%5,'entry_mode':'bottom','queue_seconds':7.0 if idx>=10 else ((9.0-(idx-5)*.5) if idx>=5 else 0.0),'mission':mission,'title':title,'room':room,'palette':palette,
               'width':w,'height':h,'cells':cells,'lanes':lanes,'solution':solution,
               'speaker':speaker,'intro':intro,'end_speaker':end_speaker,'outro':outro,'clue':clue}
        if idx>=5:level['palette']=palette+DECOY_COLOURS
        levels.append(level)
        print(f'{idx+1}: {title}: {sum(c>=0 for c in cells)} cells, {len(packets)} capsules, lanes {[len(l) for l in lanes]}')
    identities=json.loads((ROOT/'data/content_ids.json').read_text())
    for level in levels:
        legacy=int(level['id'])
        level['art_id']=identities['legacy_art_ids'][str(legacy)]
        level['level_id']=identities['level_ids'][legacy//5]
        for field in ['title','mission','room','intro','outro','clue']:
            level[field]='art.'+level['art_id']+'.'+field
        for field in ['speaker','end_speaker']:
            old=level.pop(field)
            identity={'Rocco':'rocco','Sprocket':'sprocket','Küratör':'frost'}[old]
            level[field+'_id']=identity
            level[field+'_key']='speaker.curator' if identity=='frost' else 'speaker.'+identity
    (ROOT/'data/levels.json').write_text(json.dumps(levels,ensure_ascii=False,indent=2)+'\n')
    make_audio()
    # Queue authoring uses the exact game flight rules, including shared docks.
    import os, shutil, subprocess
    godot=os.environ.get('GODOT_BIN') or shutil.which('godot') or shutil.which('godot4')
    mac_binary=Path.home()/'Downloads/Godot.app/Contents/MacOS/Godot'
    if not godot and mac_binary.exists():godot=str(mac_binary)
    if not godot:raise RuntimeError('Set GODOT_BIN to finish authoring shared-dock queues.')
    subprocess.run([godot,'--headless','--path',str(ROOT),'--script','tools/rebuild_queues.gd','--','--test-mode'],check=True)

def make_audio():
    from build_asmr_audio import build as build_asmr
    build_asmr()

if __name__=='__main__':build()
