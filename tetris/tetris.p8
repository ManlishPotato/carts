pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
p1={}
p1.x=0
p1.y=0
p1.lastx=0
p1.lasty=10

p1.spr=19
p1.r=0
p1.lastr=0
p1.sel=0
p1.grav=0.25

ti={}
ti.last=0
ti.active=false
ti.doonce=true

gameover=false

fx={}
fx.cycles=10
fx.table={}
fx.state=false
fx.pos=0 --effect y pos
fx.doonce=true

sc={}
sc.stack=0 --score stack 1-4
sc.scorep=0

debug_b=0
debug_a=0
debug_bool=false
debug_table={}

start_y=-10
-- start pos | row1 | row2
--tab={px,py, cx,cy,n, cx,cy,n}
tet_i={56,start_y, -8,0,4} --1
tet_t={56,start_y, -8,0,3, 0,8,1} --2
tet_o={56,start_y, -8,0,2, -8,8,2} --3
tet_s={56,start_y, -8,0,2, -16,8,2} --4
tet_z={56,start_y, -8,0,2, 0,8,2} --5
tet_l={56,start_y, -8,0,3, -8,8,1} --6
tet_j={56,start_y, -8,0,3, 8,8,1} --7

function _init()
	init_tet()
end

function _update60()
	cls()
	map(0,0,0,0,16,16)

	if(level_check() or gameover) then game_over() end

	if(void_check() or ti.active and gameover!=true) then
		time_keeper("start")
		if(timer(0.7)) then clear_block() fx.state=false fx.doonce=true end
		if(timer(0.8)) then time_keeper("end") drag_block() sfx(5) end
	end

	effect()
	score()

	if(ti.active==false and gameover==false) then
		move()
		collision("move")
		rotate()
		collision("rot")

		gravity()
		collision("gravity")

		draw_tet()
		map(0,0,0,0,16,16)
	end
end

function next_tet()
	
end

function score()
	rectfill(0,40,23,55,8)

	if(sc.stack==1) then sc.scorep+=100 sc.stack=0 end
	if(sc.stack==2) then sc.scorep+=200 sc.stack=0 end
	if(sc.stack==3) then sc.scorep+=300 sc.stack=0 end
	if(sc.stack==4) then sc.scorep+=1000 sc.stack=0 end

	print(sc.scorep,2,45,0)
end

function effect()
	local pos_x=24
	local gain=0.5
	local range={}

	if(sc.stack==1) then range={0.1,0.5,0.1} end
	if(sc.stack==2) then range={0.1,0.5,0.1} end
	if(sc.stack==3) then range={0.1,0.5,0.1} end
	if(sc.stack==4) then range={0.1,0.5,0.1} end

	if(sc.stack==0) then range={0.1,0.5,0.1} end

	if(fx.state) then
		if(fx.table[1]==nil or fx.cycles<=0 or fx.doonce) then
			fx.doonce=false
			fx.cycles=10
			for i=0,27,3 do
				fx.table[1+i]=rnd(80)+pos_x
				fx.table[2+i]=rnd((fx.pos+(sc.stack*8))-fx.pos)+fx.pos
				fx.table[3+i]=range[1]+rnd(range[2])+range[3]
			end
		end
		if(fx.cycles>0) then
			for i=0,27,3 do
				fx.table[3+i]+=gain
				circfill(fx.table[1+i],fx.table[2+i],fx.table[3+i],rnd(2)+5)
			end
			fx.cycles-=1
		end
	end
end

function game_over()
	gameover=true

	local pos_x=24
	local pos_y=0
	for i=1,16,1 do
		for n=1,10,1 do
			mset(pos_x/8,pos_y/8,0)
			pos_x+=8
		end
		pos_x=24
		pos_y+=8
	end
	init_tet()

	print("game over",46,50,8)
	print("-----------",42,56,7)
	print("⬆️ to continue",36,62,8)

	if(btnp(2)) then gameover=false sc.scorep=0  end
end

function level_check()
	local pos_x=24
	local pos_y=0
	local count=0
	for i=1,16,1 do
		for n=1,10,1 do
			if(fget(mget(pos_x/8,pos_y/8),0)) then count+=1 break end
			pos_x+=8
		end
		pos_x=24
		pos_y+=8
	end
	if(count==16) then return true end
end

function time_keeper(op)
	if(op=="start") then
		ti.active=true
		if(ti.doonce) then ti.last=time() ti.doonce=false sfx(2) end
	end

	if(op=="end") then
		ti.doonce=true
		ti.active=false
	end
end

function timer(delay)
	if(time()-ti.last>delay) then return true end
end

function drag_block()
	local pos_x=24
	local pos_y=128
	local done=true

	for i=1,16,1 do
		pos_x=24
		pos_y-=8
		local count=0
		local countab=0
		for n=1,10,1 do
			if(mget(pos_x/8,pos_y/8)==0) then count+=1 end
			if(mget(pos_x/8,(pos_y-8)/8)!=0) then countab+=1 end
			pos_x+=8
		end
		if(count==10 and countab>=1) then
			pos_x=24
			done=false
			for v=1,10,1 do
				mset(pos_x/8,pos_y/8,mget(pos_x/8,(pos_y-8)/8))
				mset(pos_x/8,(pos_y-8)/8,0)
				pos_x+=8
			end
		end
	end
	if(done==false) then drag_block() end
end

function grav_block()
	local pos_x=24
	local pos_y=128
	local done=true

	for i=1,16,1 do
		pos_x=24
		pos_y-=8
		for n=1,10,1 do
			if(fget(mget(pos_x/8,pos_y/8),0)==true) then
				if(fget(mget(pos_x/8,(pos_y+8)/8),0)==false) then
					mset(pos_x/8,(pos_y+8)/8,mget(pos_x/8,pos_y/8))
					mset(pos_x/8,pos_y/8,0)
					done=false
				end
			end
			pos_x+=8
		end
	end
	if(done==false) then grav_block() end
end

function clear_block()
	local  pos_x=24
	local  pos_y=0
	local count=0
	for i=1,16,1 do
		for n=1,10,1 do
			if(fget(mget(pos_x/8,pos_y/8),1)) then count+=1 end
			pos_x+=8
		end
		if(count==10) then pos_x=24 for v=1,10,1 do mset(pos_x/8,pos_y/8,0) pos_x+=8 end end
		count=0
		pos_x=24
		pos_y+=8
	end
end

function void_check()
	local pos_x=24
	local pos_y=0
	local count=0
	local del_mode=false
	local doonce=true
	for i=1,16,1 do
		for n=1,10,1 do
			if(fget(mget(pos_x/8,pos_y/8),0)) then count+=1 end
			pos_x+=8
		end
		if(count==10) then
			pos_x=24
			del_mode=true
			if(doonce) then fx.pos=pos_y fx.state=true doonce=false end
			sc.stack+=1
			for v=1,10,1 do mset(pos_x/8,pos_y/8,(mget(pos_x/8,pos_y/8))+20) pos_x+=8 end
		end
		count=0
		pos_x=24
		pos_y+=8
	end
	if(del_mode) then return true	end
end

function mapset()
	local pos_x=0
	local pos_y=0
	local rot_x=0
 local rot_y=0

 for i=1,table[5],1 do
 	rot_x,rot_y=rot(table[3]+pos_x,table[4]+pos_y)
		mset((p1.x+rot_x)/8,flr(((p1.y+rot_y)/8)+0.5),p1.spr)
 	pos_x+=8
 end

 if(table[6]!=nil) then
 	pos_x=0
 	pos_y=0

		for n=1,table[8],1 do
			rot_x,rot_y=rot(table[6]+pos_x,table[7]+pos_y)
			mset((p1.x+rot_x)/8,flr(((p1.y+rot_y)/8)+0.5),p1.spr)
			pos_x+=8
		end
	end
end

function init_tet()
	p1.sel=flr(rnd(7))+1
	p1.r=0

	if(p1.sel==1) then table=tet_i p1.spr=18 end
	if(p1.sel==2) then table=tet_t p1.spr=19 end
	if(p1.sel==3) then table=tet_o p1.spr=20 end
	if(p1.sel==4) then table=tet_s p1.spr=21 end
	if(p1.sel==5) then table=tet_z p1.spr=22 end
	if(p1.sel==6) then table=tet_l p1.spr=23 end
	if(p1.sel==7) then table=tet_j p1.spr=24 end

	p1.x,p1.y=table[1],table[2]
end

function gravity()
	p1.lastx,p1.lasty=p1.x,p1.y
	if(btn(3)) then p1.y+=p1.grav+4 else p1.y+=p1.grav end
end

function move()
	if(btnp(0)) then p1.x-=8 end
	if(btnp(1)) then p1.x+=8 end
end

function rotate()
	p1.lastr=p1.r

	if(btnp(4)) then p1.r-=90 end
	if(btnp(5)) then p1.r+=90 end
	if(p1.r>270) then p1.r=0 end
	if(p1.r<0) then p1.r=270 end
end

function collision(op)
	local pos_x=0
	local pos_y=0
	local rot_x=0
 local rot_y=0

 for i=1,table[5],1 do
 	rot_x,rot_y=rot(table[3]+pos_x,table[4]+pos_y)
 	for k=0,7,7 do
 		for l=0,7,7 do
				if(op=="gravity") then
					flag=fget(mget((p1.x+rot_x+l)/8,(p1.y+rot_y+k)/8),0)
	 			if(flag) then
						p1.y=p1.lasty
						mapset()
						init_tet()
						sfx(0)
						goto continue_init
	 			end
				end
				if(op=="move") then
	 			flag=fget(mget((p1.x+rot_x+l)/8,(p1.y+rot_y+k)/8),0)
	 			if(flag) then
	 				p1.x=p1.lastx
	 			end
			 end
				if(op=="rot") then
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
 	pos_x,pos_y=0,0
		for n=1,table[8],1 do
			rot_x,rot_y=rot(table[6]+pos_x,table[7]+pos_y)
			for v=0,7,7 do
	 		for b=0,7,7 do
					if(op=="gravity") then
						flag=fget(mget((p1.x+rot_x+b)/8,(p1.y+rot_y+v)/8),0)
		 			if(flag) then
							p1.y=p1.lasty
							mapset()
		 				init_tet()
							sfx(0)
							goto continue_init
		 			end
					end
					if(op=="move") then
		 			flag=fget(mget((p1.x+rot_x+b)/8,(p1.y+rot_y+v)/8),0)
		 			if(flag) then
		 				p1.x=p1.lastx
		 			end
					end
					if(op=="rot") then
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
	::continue_init::
end

function draw_tet()
	local pos_x=0
	local pos_y=0
	local rot_x=0
 local rot_y=0

 for i=1,table[5],1 do
 	rot_x,rot_y=rot(table[3]+pos_x,table[4]+pos_y)
		spr(p1.spr,p1.x+rot_x,p1.y+rot_y)
 	pos_x+=8
 end
 if(table[6]!=nil) then
 	pos_x, pos_y=0,0
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
00000000666161117777777700000000777777770000888000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000161166117777777700000000777777770088000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700611116117777777700000000777777778800000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000616111117777777700000000777777770000008800000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000616661167777777700000000777777770008880000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700611116667777777700000000777777778880000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000116611117777777700000000777777770000008800000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111661667777777700000000777777770000080000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000001666116666ee888877666bbbfffffaaa77776ccc77766444777ddd227777666600000000000000000000000000000000000000000000000000000000
00000000116111116ee88888766bbbbbffaaaaaa776ccccc7754444477dd22227766666600000000000000000000000000000000000000000000000000000000
0000000061111161eee8888866bbbbbbfaaaaaaa76cccccc754444447dd222227666666600000000000000000000000000000000000000000000000000000000
0000000066611161e88888886bbbbbbbfaaaaaaa7ccccccc64444444dd2222227666666500000000000000000000000000000000000000000000000000000000
0000000011161161888888886bbbbbb3faaaaaaa6ccccccc54444446d222222d6666666500000000000000000000000000000000000000000000000000000000
000000001666116188888882bbbbbbb3aaaaaaa9cccccccc44444446222222d16666665500000000000000000000000000000000000000000000000000000000
000000001111611188888822bbbbbb33aaaaaa99ccccccc14444466522222d116666655100000000000000000000000000000000000000000000000000000000
000000001166611188888221bbbb3333aaaaa999cccccc1144466655222ddd116665551100000000000000000000000000000000000000000000000000000000
000000001116111611111117711111177111116671111177660e888877660bbbfff00aaa77006ccc770004440000dd2277076660000000000000000000000000
0000000011111166666666677777711776666661711117716e08880076600bbbffa0aaa0770ccccc7054044077d0022270066600000000000000000000000000
000000006616611611111117111177777111111177777711ee00000866b00bbbfa0000007600cccc704400007dd0000270666066000000000000000000000000
000000001616611111111117111111177111111171111111e80088886b0b0bbbf000aaaa7cc0cccc00440444dd00220070000665000000000000000000000000
0000000016111111666666671111111771111666711111118808888860bbb0b300a00aaa6c0000cc00044446d002200d60066665000000000000000000000000
0000000011666111611111177777777776666611777771118008888200bbbb03aaaa0aa9c00cc000044004460022220100006655000000000000000000000000
000000006611666611111117111111177111111171111771808888220bbbbb03aaaa0a99c0ccccc14444006520022d0106606551000000000000000000000000
00000000166111616666666711177777766666667111117780888221bbbb3003aaaa099900cccc1144466055220ddd0166600511000000000000000000000000
000000000007e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ee000000000000000000000007c000076000000770000000077000000000000000000000000000000000000000000000000000000000000000000
00000000000e80000007b00000ffaa0000007c0000740000007d0000000076000000000000000000000000000000000000000000000000000000000000000000
00000000000880000006b00000faa9000077c1000074440000d20000000066000000000000000000000000000000000000000000000000000000000000000000
000000000008800007bbbb3000faa900007cc1000074440000220000000066000000000000000000000000000000000000000000000000000000000000000000
000000000008200006bbb33000aa9900007c0000000046000022dd00007765000000000000000000000000000000000000000000000000000000000000000000
0000000000021000000000000000000000c10000000076000022d100007651000000000000000000000000000000000000000000000000000000000000000000
00000000000110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000088880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000088880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000088880000000000000000000000000000000000000000000000cccc00000000000000000000000000000000000000000000000000000000000000000000
00000088880000000000000000000000000000000000000000000000cccc00000000000000000000000000000000000000000000000000000000000000000000
0000008888000000000000bbbb0000000000aaaaaaaa000000000000cccc00000000000000000000000000000000000000000000000000000000000000000000
0000008888000000000000bbbb0000000000aaaaaaaa00000000cccccccc00000000000000000000000000000000000000000000000000000000000000000000
0000008888000000000000bbbb0000000000aaaaaaaa00000000cccccccc00000000000000000000000000000000000000000000000000000000000000000000
0000008888000000000000bbbb0000000000aaaaaaaa00000000cccccccc00000000000000000000000000000000000000000000000000000000000000000000
000000888800000000bbbbbbbbbbbb000000aaaaaaaa00000000cccccccc00000000000000000000000000000000000000000000000000000000000000000000
000000888800000000bbbbbbbbbbbb000000aaaaaaaa00000000cccc000000000000000000000000000000000000000000000000000000000000000000000000
000000888800000000bbbbbbbbbbbb000000aaaaaaaa00000000cccc000000000000000000000000000000000000000000000000000000000000000000000000
000000888800000000bbbbbbbbbbbb000000aaaaaaaa00000000cccc000000000000000000000000000000000000000000000000000000000000000000000000
0000008888000000000000000000000000000000000000000000cccc000000000000000000000000000000000000000000000000000000000000000000000000
00000088880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000088880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000088880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000bbbbbbbb0000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000b888888b0000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000b888888b0000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000b888888b0000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000b888888b0000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000b888888b0000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000b888888b0000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000bbbbbbbb0000000000000000000000000000000000000000111111111111111177777777
777777771111111111111111000000000000000000000000bbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000111111111111111177777777
777777771111111111111111000000000000000000000000b888888bb888888bb888888b00000000000000000000000000000000111111111111111177777777
777777771111111111111111000000000000000000000000b888888bb888888bb888888b00000000000000000000000000000000111111111111111177777777
777777771111111111111111000000000000000000000000b888888bb888888bb888888b00000000000000000000000000000000111111111111111177777777
777777771111111111111111000000000000000000000000b888888bb888888bb888888b00000000000000000000000000000000111111111111111177777777
777777771111111111111111000000000000000000000000b888888bb888888bb888888b00000000000000000000000000000000111111111111111177777777
777777771111111111111111000000000000000000000000b888888bb888888bb888888b00000000000000000000000000000000111111111111111177777777
777777771111111111111111000000000000000000000000bbbbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000f00000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
777777771111111111111111000000000000000000000000000f0000000000000000000000000000000000000000000000000000111111111111111177777777
777777771111111111111111000000000000000000000000000000000000000f00000000000f0000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000f00f00000000000000000000000000000000111111111111111177777777
7777777711111111111111110000000000000000000000000000000000000000f00000f000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000f00000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777
77777777111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111177777777

__gff__
0001010102000000000000000000000000010101010101010100000000000000000101010101020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
1101220000000000000000000024011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111230000000000000000000025111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0111220000000000000000000024111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111230000000000000000000024211100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111220000000000000000000025211100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030000000000000000000003350300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030000000000000000000025212100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1101220000000000000000000025011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1101230000000000000000000025011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2111220000000000000000000024011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2121230000000000000000000024011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2121220000000000000000000024012100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1121230000000000000000000024010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2121220000000000000000000025112100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1121230000000000000000000024110100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1121230000000000000000000025010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0111210202020202020202020211010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001b0501705015050110500e0500b0500805006050030500005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0001000005050060500705007050080500b0500f05011050180502205000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00010000076100c6100e6100f61012610166101c650206501c0501a0501705014050110500d050090500805007050060500605006050050500505004050040500405004050030500305003050020500205001050
000100000605006050050500405004050030500305003050030500305003050030500305003050020500205001050010500105001050010500105001050010500105001050010500105001050010500005001050
000100000965009650096500965008650076500765005650046500365003650026500265002650026500265002640026400164001640016300063000630006200062000610006000060000600006000060000000
000300002d650266501f6501a650186501465011650106500c650096500865007650076400764007630056200060011600106000e6000c6000a60008600066000460000600000000000000000000000000000000
