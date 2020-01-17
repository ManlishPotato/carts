pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function _init()
	p1={}
	
	p1.x=50
	p1.y=70
	p1.r=1	
	
	p1.lastx=0
	p1.lasty=0
end

function _update()
	cls()
	map(0,0,0,0,16,16)
	spr(33,p1.x,p1.y,3,1)
	
	move()
	drawrspr()
end

function move()
	if(btnp(0)) then p1.r-=1 end
	if(btnp(1)) then p1.r+=1 end

	if(p1.r>4) then p1.r=1 end
	if(p1.r<1) then p1.r=4 end
	
	print(p1.r)
end

function drawrspr()
end
__gfx__
00000000111111118888888888888888888888888888888888888888888888880000000000000000000000000000000000000000000000000000000000000000
00000000188888818000000880000000000000088000000000000000000000080000000000000000000000000000000000000000000000000000000000000000
00700700188888818011110880111111111111088011111111111111111111080000000000000000000000000000000000000000000000000000000000000000
00077000188888818010010880100000000001088010000000000000000001080000000000000000000000000000000000000000000000000000000000000000
00077000188888818010010880100000000001088010000000000000000001080000000000000000000000000000000000000000000000000000000000000000
00700700188888818011110880111111111111088011111111111111111111080000000000000000000000000000000000000000000000000000000000000000
00000000188888818000000880000000000000088000000000000000000000080000000000000000000000000000000000000000000000000000000000000000
00000000111111118888888888888888888888888888888888888888888888880000000000000000000000000000000000000000000000000000000000000000
0000000077777777bbbbbbbb88888888cccccccc0000000770000000777777770000000070000000000000070000000000000000000000000000000000000000
0000000077777777bbbbbbbb88888888cccccccc0000000770000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000bbbbbbbb88888888cccccccc0000000770000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000bbbbbbbb88888888cccccccc0000000770000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000077777777bbbbbbbb88888888cccccccc0000000770000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000077777777bbbbbbbb88888888cccccccc0000000770000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000bbbbbbbb88888888cccccccc0000000770000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000bbbbbbbb88888888cccccccc0000000770000000000000007777777700000000000000007000000000000007000000000000000000000000
00000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000800000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000080cccc080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000080c00c080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000080c00c080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000080cccc080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000800000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0001000000000000000000000000000000000204080101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
1c18181818181818181818181818181b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1511111111111111111111111111111600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1511111111111111111111111111111600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1511111111111111111111111111111600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1500000000000000000000000000001600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1500001212121212000014140000001600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1500121212121212000014140000001600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1500001212121212000000140000001600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1500000000000000000000000000001600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1500000000000000000000000000001600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1500001300130000000013000000001600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1500001300130000001300130013001600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1500001313130000000000000000001600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1500000000000000000000140000001600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1500000000000000000012130000001600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1a17171717171717171717171717171900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
