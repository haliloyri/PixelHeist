#!/usr/bin/env python3
"""Author >=20-capacity packets against bottom-entry flood rules, retaining exact budgets.
Legacy levels remain immutable for save identity; the campaign overlays this queue version.
"""
import json,random,collections
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
SIZES=[20,24,30,32,37,40,45]
def frontier(board,w,h):
 seen=set();todo=[];edge=set()
 for x in range(w):
  i=(h-1)*w+x
  if board[i]<0: todo.append(i);seen.add(i)
  else: edge.add(i)
 while todo:
  i=todo.pop();x,y=i%w,i//w
  for xx,yy in [(x-1,y),(x+1,y),(x,y-1),(x,y+1)]:
   if not (0<=xx<w and 0<=yy<h):continue
   j=yy*w+xx
   if board[j]>=0:edge.add(j)
   elif j not in seen:seen.add(j);todo.append(j)
 return sorted(edge)
def closure(board,w,h,active):
 while True:
  changed=False
  for a in active:
   while a['left']:
    cells=[i for i in frontier(board,w,h) if board[i]==a['color']]
    if not cells:break
    for i in cells[:a['left']]:board[i]=-1;a['left']-=1;changed=True
  active[:]=[a for a in active if a['left']]
  if not changed:return

def author(level,seed):
 rng=random.Random(seed);board=[int(c) for c in level['cells']];w,h=int(level['width']),int(level['height'])
 budget=collections.Counter(c for c in board if c>=0);active=[];sequence=[]
 while any(c>=0 for c in board):
  closure(board,w,h,active)
  if all(c<0 for c in board):break
  if len(active)>=5:return None
  reachable=collections.Counter(board[i] for i in frontier(board,w,h))
  options=[c for c in reachable if budget[c]>0]
  if not options:return None
  # Prefer exposed colours not already represented by a working/waiting carrier.
  occupied={a['color'] for a in active}
  c=max(options,key=lambda c:(c not in occupied,reachable[c]+rng.random()*3,budget[c]))
  left=budget[c]
  choices=[v for v in SIZES if v<=left and (left-v==0 or left-v>=20)]
  amount=rng.choice(choices) if choices else left
  if left<=45:amount=left
  budget[c]-=amount
  sequence.append({'color':c,'amount':amount})
  active.append({'color':c,'left':amount})
 assert not any(budget.values())
 n=int(level.get('slot_count',len(level['lanes'])))
 lanes=[[] for _ in range(n)];solution=[]
 absent=[c for c in range(len(level['palette'])) if c not in set(level['cells'])]
 for i,packet in enumerate(sequence):
  col=i%n
  if i and i%6==1 and absent:
   lanes[col].append({'color':absent[(i//6)%len(absent)],'amount':min(SIZES[(i//6)%len(SIZES)],sum(p['amount'] for p in sequence[i:])),'decoy':True})
   solution.append(-col-1)
  if len(lanes[col])>0 and (i+col)%4==1:packet['mystery']=True
  lanes[col].append(packet);solution.append(col)
 return {'lanes':lanes,'solution':solution}
def build():
 out={}
 for index,level in enumerate(json.loads((ROOT/'data/levels.json').read_text())):
  for attempt in range(200):
   plan=author(level,91273+index*77+attempt)
   if plan:break
  assert plan,level['art_id']
  out[level['art_id']]=plan
  amounts=[p['amount'] for lane in plan['lanes'] for p in lane if not p.get('decoy')]
  print(level['art_id'],len(amounts),'packets',min(amounts),max(amounts),'attempt',attempt)
 return out
if __name__=='__main__':
 (ROOT/'data/large_packet_queues.json').write_text(json.dumps(build(),indent=2)+'\n')
