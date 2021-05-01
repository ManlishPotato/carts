pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
l={} --Leader
l.x=64
l.y=64
l.dir=0
l.speed=10
l.lx=0
l.ly=0
l.spr=49
l.un=false

db={} --Debug
db.a=0
db.b=0
db.string=nil

st={} --Snake Timing
st.cycled=l.speed
st.cycle=st.cycled

ta={} --Tail
ta.lx=0
ta.ly=0
ta.length=0
ta.tbl={}
ta.spr=33
ta.sprturn=37

upd={}
upd.normal=true

gm={}
gm.state=false
gm.doonce=true

function _init()

end

function _update60()
 cls()

 input()
 if(upd.normal) then
  addTail()
  if(moveTiming()) then
   moveLeader()
   moveTail()
  end

  if(colTail() or colMap()) then gameOver("gam") end

  map(0,0,0,0,16,16)
  drawLeader()
  drawTail()
 end

 gameOver()
 debug(false);
end

function _draw()
 pal(11,138,1)
end

function gameOver(mode)
 if(mode=="gam") then gm.state=true return end
 if(mode=="nor") then
  gm.doonce=true
  upd.normal=true
  gm.state=false
  l.x=64
  l.y=64
  ta.lx=64
  ta.ly=64
  l.dir=0
  ta.length=1
  local co=0
  for i in all(ta.tbl) do co+=1 end
  for n=1,co,1 do ta.tbl[n]=nil end
  return
 end

 if(gm.state) then
  if(gm.doonce) then upd.normal=false gm.doonce=false end
  map(0,0,0,0,16,16)
  print("game over",45,55,7)
  print("pRESS z TO cONTINUE",26,64,7)
 end
end

function colMap()
 local flag=false
 if(fget(mget(l.x/8,l.y/8),0)) then return true else return false end
end

function colTail()
 local co=0
 local col=false
 for i in all(ta.tbl) do co+=1 end
 for n=3,co,3 do
  for v=0,7,7 do
   for h=0,7,7 do
    pset(ta.tbl[n-1]+h,ta.tbl[n]+v,7)
   end
  end
  if(l.x==ta.tbl[n-1] and l.y==ta.tbl[n]) then col=true end
 end
 if(col) then return true else return false end
end

function drawTail()
 local co=0

 for i in all(ta.tbl) do co+=1 end
 for n=3,co,3 do
  local sp=0
  local x=ta.tbl[n-1]
  local y=ta.tbl[n]
  --Leader
  if(l.x==x-8 or l.x==x+8) then sp=ta.spr+2 end
  if(l.y==y-8 or l.y==y+8) then sp=ta.spr end
  --Tail
  if(ta.tbl[n-4]==x-8 or ta.tbl[n-4]==x+8) then sp=ta.spr+2 end
  if(ta.tbl[n-3]==y-8 or ta.tbl[n-3]==y+8) then sp=ta.spr end
  --Tail turn
  local tab={x+8,y-8, x+8,y+8, x-8,y+8, x-8,y-8}
  local sel=0
  for v=1,7,2 do
   if(ta.tbl[n+2]==tab[v] and ta.tbl[n-3]==tab[v+1]) then sp=ta.sprturn+sel
   elseif(ta.tbl[n-4]==tab[v] and ta.tbl[n+3]==tab[v+1]) then sp=ta.sprturn+sel end
   sel+=1
  end
  --Save spr
  ta.tbl[n-2]=sp

  spr(ta.tbl[n-2],ta.tbl[n-1],ta.tbl[n])
 end
end

function moveTail()
 local co=0
 local tx=0
 local ty=0

 for i in all(ta.tbl) do co+=1 end
 for n=3,co,3 do
  tx=ta.tbl[n-1]
  ty=ta.tbl[n]
  ta.tbl[n-1]=ta.lx
  ta.tbl[n]=ta.ly
  ta.lx=tx
  ta.ly=ty
 end
end

function addTail()
 if(btnp(4)) then
  add(ta.tbl,ta.spr) --Spr num
  add(ta.tbl,ta.lx) --X
  add(ta.tbl,ta.ly) --Y
  ta.length+=1
 end
end

function input()
 if(btn(0) and ta.tbl[2]!=l.x-8) then l.dir=0 l.un=true end
 if(btn(1) and ta.tbl[2]!=l.x+8) then l.dir=1 l.un=true end
 if(btn(2) and ta.tbl[3]!=l.y-8) then l.dir=2 l.un=true end
 if(btn(3) and ta.tbl[3]!=l.y+8) then l.dir=3 l.un=true end

 if(btnp(5) and upd.normal==false) then gameOver("nor") end
end

function moveTiming()
 if(st.cycle==0) then
  st.cycle=st.cycled
  return true
 end

 st.cycle-=1
end

function moveLeader()
 ta.lx=l.x
 ta.ly=l.y
 if(l.dir==0 and ta.tbl[2]!=l.x-8) then l.x-=8 l.un=false end
 if(l.dir==1 and ta.tbl[2]!=l.x+8) then l.x+=8 l.un=false end
 if(l.dir==2 and ta.tbl[3]!=l.y-8) then l.y-=8 l.un=false end
 if(l.dir==3 and ta.tbl[3]!=l.y+8) then l.y+=8 l.un=false end
end

function drawLeader()
 local sp=l.dir+l.spr

 if(l.un) then
  sp+=4
 end

 spr(sp,l.x,l.y)
end

function debug(useDebug)
	if(useDebug!=true) then return end
	rectfill(2,2,37,17,8)
	print("db.a= "..db.a,3,3,7)
	print("db.b= "..db.b,3,12,7)
 --pset(64,64,7)

	if(db.string!=nil) then
		rectfill(2,18,48,27,5)
		print(db.string,3,20,7)
	end
end
__gfx__
00000000bbbbbbbbbbbbbbb0000000000bbbbbbbbbbbbbbbbbbbbbb00bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000
00000000bbbbbbbbbbbbbbb0bbbbbbbb0bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000
00700700bbbbbbbbbbbbbbb0bbbbbbbb0bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000
00077000bbbbbbbbbbbbbbb0bbbbbbbb0bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000
00077000bbbbbbbbbbbbbbb0bbbbbbbb0bbbbbbbbbbbbbb0bbbbbbbbbbbbbbbb0bbbbbbb00000000bbbbbbbbbbbbbbbb00000000000000000000000000000000
00700700bbbbbbbbbbbbbbb0bbbbbbbb0bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000
00000000bbbbbbbbbbbbbbb0bbbbbbbb0bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00bbbbbbb00000000000000000000000000000000
0000000000000000bbbbbbb0bbbbbbbb0bbbbbbbbbbbbbb0bbbbbbbbbbbbbbbb0bbbbbbb00000000bbbbbbbbbbbbbbbb00000000000000000000000000000000
00000000bbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000b3333b3bb3b3333bbbbbbbbbbbbbbbbbb33b333bbbbbbbbbbbbbbbbbb333b33b99999999000000000000000000000000000000000000000000000000
00000000b333b33bb33b333b3333333333333333b333b333bbb3333333333bbb333b333b9dddddd9000000000000000000000000000000000000000000000000
00000000b3333b3bb3b3333bb3b3333333333b3bb33b3333bb333333333333bb3333b33b9dddddd9000000000000000000000000000000000000000000000000
00000000b333b33bb33b333b3b3b33333333b3b3b333b3b3b3333b3bb3b3333b3b3b333b9dddddd9000000000000000000000000000000000000000000000000
00000000b33b333bb333b33b3333b3b33b3b3333b3333b3bb333b3b33b3b333bb3b3333b9dddddd9000000000000000000000000000000000000000000000000
00000000b3b3333bb3333b3b33333b3bb3b33333bb333333b33b33333333b33b333333bb9dddddd9000000000000000000000000000000000000000000000000
00000000b33b333bb333b33b3333333333333333bbb33333b333b333333b333b33333bbb9dddddd9000000000000000000000000000000000000000000000000
00000000b3b3333bb3333b3bbbbbbbbbbbbbbbbbbbbbbbbbb33b333bb333b33bbbbbbbbb99999999000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbb333bbbbb333333bbbbbb33bbbbbbbbbb333bbbbb3333333bbbbbbbb333333333333bbbb3333333b000000000000000000000000
00000000bbbbb33333333333b333bbbbb333333bbbbbb33b33333333b333bbbbb3333333bbbbb333333333333333bbbb3333333b000000000000000000000000
00000000bbbbb33333333333b333bbbbb333333bbbbbb33b33333333b333bbbbb3333333bbbbb333333333333333bbbb3333333b000000000000000000000000
00000000bbbbb33333333333b333bbbbb333bbbbbbbbb33b33333333b333bbbbb333bbbbbbbbb333333333333333bbbb3333bbbb000000000000000000000000
0000000033333333333bbbbbb333bbbbb333bbbb3333333b333bbbbbb333bbbbb333bbbb33333333333bbbbb3333bbbb3333bbbb000000000000000000000000
0000000033333333333bbbbbb333333bb333bbbb3333333b333bbbbbb3333333b333bbbb33333333333bbbbb3333333b3333bbbb000000000000000000000000
0000000033333333333bbbbbb333333bb333bbbb3333333b333bbbbbb3333333b333bbbb33333333333bbbbb3333333b3333bbbb000000000000000000000000
00000000bbbbbbbbbbbbbbbbb333333bb333bbbbbbbbbbbb333bbbbbb3333333b333bbbb33333333bbbbbbbb3333333b3333bbbb000000000000000000000000
__gff__
0001010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
1111111111111111111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0509090909090909090909090909090800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0211111111111111111111111111110400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0211111111111111111111111111110400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0211111111111111111111111111110400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0211111111111111111111111111110400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0211111111111111111111111111110400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0211111111111111111111111111110400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0211111111111111111111111111110400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0211111111111111111111111111110400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0211111111111111111111111111110400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0211111111111111111111111111110400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0211111111111111111111111111110400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0211111111111111111111111111110400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0211111111111111111111111111110400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0603030303030303030303030303030700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000