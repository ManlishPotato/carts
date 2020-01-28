pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
p1={}
p1.x=0
p1.y=0
p1.lastx=0
p1.lasty=0

p1.spr=2
p1.r=0
p1.lastr=0
p1.sel=2

tet_i={16,8, -8,0,4} --1
tet_t={16,8, -8,0,3, 0,8,1} --2

function _init()
	table=tet_t --set start tetramino
	p1.x,p1.y=table[1],table[2] --Set start pos
end

function _update()
	cls()
	mapset()
	map(0,0,0,0,16,16)

	if(p1.sel==1) then table=tet_i end
	if(p1.sel==2) then table=tet_t end

	move() --move player i.e p1
	collision("m") --movement collision
	rotate() --rotate player i.e p1
	collision("r") --rotate collision
	drawspr() --if everythink checks out, draw tetramino sprite

	--pset(p1.x,p1.y,0)

	print(p1.x,10,10,12) --x and y pos
	print(p1.y,20,10,12)

	print(p1.r,nil,nil,8) --rotate value
end

function mapset()
	if(btnp(5)) then --If x button pressed place player sprite on pos in map
		local pos_x=0
		local pos_y=0
		local rot_x=0
	 local rot_y=0

	 for i=1,table[5],1 do
	 	rot_x,rot_y=rot(table[3]+pos_x,table[4]+pos_y)
			mset((p1.x+rot_x)/8,(p1.y+rot_y)/8,p1.spr)
	 	pos_x+=8
	 end

	 if(table[6]!=nil) then
	 	pos_x=0
	 	pos_y=0

			for n=1,table[8],1 do
				rot_x,rot_y=rot(table[6]+pos_x,table[7]+pos_y)
				mset((p1.x+rot_x)/8,(p1.y+rot_y)/8,p1.spr)
				pos_x+=8
			end
		end

		p1.x,p1.y=table[1],table[2]
		p1.r=0
		p1.spr=flr(rnd(6))+18
	end
end

function move()
	--save last pos
	p1.lastx=p1.x
	p1.lasty=p1.y
	--movement buttonmap
	if(btnp(0)) then p1.x-=8 end
	if(btnp(1)) then p1.x+=8 end
	if(btnp(2)) then p1.y-=8 end
	if(btnp(3)) then p1.y+=8 end
end

function rotate()
	--save last rotation
	p1.lastr=p1.r

	--rotation buttonmap
	if(btnp(4)) then p1.r+=90 end
	if(p1.r>270) then p1.r=0 end
end

function collision(val)
	local pos_x=0
	local pos_y=0
	local rot_x=0
 local rot_y=0

 for i=1,table[5],1 do

 	rot_x,rot_y=rot(table[3]+pos_x,table[4]+pos_y)

 	for k=0,7,7 do
 		for l=0,7,7 do
				if(val=="m") then
	 			flag=fget(mget((p1.x+rot_x+l)/8,(p1.y+rot_y+k)/8),0)
	 			if(flag) then
	 				p1.x=p1.lastx
	 				p1.y=p1.lasty
	 			end
				end
				if(val=="r") then
					flag=fget(mget((p1.x+rot_x+l)/8,(p1.y+rot_y+k)/8),0)
					if(flag) then
						p1.r=p1.lastr
					end
				end
 		end
 	end

 	pos_x+=8
 end

 if(table[6]!=nil) then
 	pos_x=0
 	pos_y=0

		for n=1,table[8],1 do

			rot_x,rot_y=rot(table[6]+pos_x,table[7]+pos_y)

		for v=0,7,7 do
 		for b=0,7,7 do
				if(val=="m") then
	 			flag=fget(mget((p1.x+rot_x+b)/8,(p1.y+rot_y+v)/8),0)
	 			if(flag) then
	 				p1.x=p1.lastx
	 				p1.y=p1.lasty
	 			end
				end
				if(val=="r") then
					flag=fget(mget((p1.x+rot_x+b)/8,(p1.y+rot_y+v)/8),0)
					if(flag) then
						p1.r=p1.lastr
					end
				end
 		end
 	end
			pos_x+=8
		end
 end
end

function drawspr()
	local pos_x=0
	local pos_y=0
	local rot_x=0
 local rot_y=0

	--first row
 for i=1,table[5],1 do

 	rot_x,rot_y=rot(table[3]+pos_x,table[4]+pos_y)

 	spr(p1.spr,p1.x+rot_x,p1.y+rot_y)
 	pos_x+=8
 end

 --check for another row
 if(table[6]!=nil) then
 	pos_x=0
 	pos_y=0

 	--second row
		for n=1,table[8],1 do
			rot_x,rot_y=rot(table[6]+pos_x,table[7]+pos_y)

			spr(p1.spr,p1.x+rot_x,p1.y+rot_y)
			pos_x+=8
		end
 end
end

function rot(val_x,val_y)
 if(p1.r==0) then
 	return val_x,val_y
	end

	if(p1.r==90) then
	 return (val_y)*-1,val_x
	end

	if(p1.r==180) then
		return (val_x)*-1,(val_y)*-1
	end

	if(p1.r==270) then
	 return val_y,(val_x)*-1
	end
end
__gfx__
00000000777777778888888811111111ccccccccbbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000777777778000000810000001ccccccccbbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700777777778000000810000001ccccccccbbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000777777778000000810000001ccccccccbbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000777777778000000810000001ccccccccbbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700777777778000000810000001ccccccccbbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000777777778000000810000001ccccccccbbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000777777778888888811111111ccccccccbbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000088888888bbbbbbbbaaaaaaaacccccccc44444444222222220000000000000000000000000000000000000000000000000000000000000000
000000000000000080000008b000000ba000000ac000000c40000004200000020000000000000000000000000000000000000000000000000000000000000000
000000000000000080000008b000000ba000000ac000000c40000004200000020000000000000000000000000000000000000000000000000000000000000000
000000000000000080000008b000000ba000000ac000000c40000004200000020000000000000000000000000000000000000000000000000000000000000000
000000000000000080000008b000000ba000000ac000000c40000004200000020000000000000000000000000000000000000000000000000000000000000000
000000000000000080000008b000000ba000000ac000000c40000004200000020000000000000000000000000000000000000000000000000000000000000000
000000000000000080000008b000000ba000000ac000000c40000004200000020000000000000000000000000000000000000000000000000000000000000000
000000000000000088888888bbbbbbbbaaaaaaaacccccccc44444444222222220000000000000000000000000000000000000000000000000000000000000000
__gff__
0001010001010000000000000000000000000101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0103030303030303030303030303030100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0103030303030303030303030303030100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0103030303030303030303030303030100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0103030303030303030303030303030100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0103030303030303030303030303030100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0103030303030303030303030303030100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0103030303030303030303030303030100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0103030303030303030303030303030100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0103030303030303030303030303030100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0103030303030303030303030303030100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0103030303030303030303030303030100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0103030303030303030303030303030100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0103030303030303030303030303030100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
