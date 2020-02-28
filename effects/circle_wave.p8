pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
c={}
c.dim=5
c.limit=30

c2={}
c2.tbl={}
c2.cycle=0
c2.cycled=5
c2.count=0
c2.syzel=20

d={}
d.a=0
d.b=0

function _init()
end

function _update60()
cls()
if(btn(4)) then bcircle()	end --big circle + text
if(btn(5)) then scircle() end remove() draw_state() --small circles

rect(10,10,110,110,7)

--Circle count
local count=0
for i in all(c2.tbl) do count+=1 end d.a=count

--Debug
print("",nil,nil,8)
print("debug a:"..d.a)
print("debug b:"..d.b)
end

function remove()
	local count=0

	for i in all(c2.tbl) do count+=1 end
	for e=3,count,3 do
		if(c2.tbl[e]>=c2.syzel and c2.tbl[e]<200) then
			for v=0,2,1 do
				c2.tbl[e-v]=200
			end
		else c2.tbl[e]+=0.5 end
	end
	count=0
	for b in all(c2.tbl) do if(b==200) then count+=1 end end
	for k=1,count,1 do del(c2.tbl,200) end
end

function draw_state()
	local count=0

	for i in all(c2.tbl) do count+=1 end
	for v=3,count,3 do
		circ(c2.tbl[v-2],c2.tbl[v-1],c2.tbl[v],8)
	end
end

function scircle()
	if(c2.cycle<=0) then --add object
		c2.cycle=c2.cycled
		add(c2.tbl,flr(rnd(100)+10)) --1 x
		add(c2.tbl,flr(rnd(100)+10)) --2 y
		add(c2.tbl,2) --3 rad
	else c2.cycle-=1 end
end

function bcircle()
line(0,60,128,60,7)
line(60,0,60,128,7)
	print("text",53,58,8)
	circ(60,60,c.dim,7)
	if(c.dim>c.limit) then c.dim=5
	else c.dim+=0.5 end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
