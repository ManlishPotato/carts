pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--effect1
cycles=10 --0.5s @ 60f/s
table={}
size=0.1

--effect2
cycles2=10
table2={}

function _init()
	table=new_table()
	table2=new_table2()
end

function _update60()
	cls()
	map(0,0,0,0,16,16)
	if(btn(4)) then effect1() end
	if(btn(5)) then effect2() end
end

function new_table()
	local x_span=120
	local y_span=8
	local ntable={}
	for i=0,18,2 do
		ntable[1+i]=rnd(x_span)+3
		ntable[2+i]=rnd(y_span)+50
	end
	return ntable
end

function new_table2()
	local ntable={}
	for i=0,27,3 do
		ntable[1+i]=rnd(120)+3
		ntable[2+i]=rnd(8)+30
		ntable[3+i]=0.1+rnd(5)+0.1
	end
	return ntable
end

function effect2()
	rect(3,30,123,38,0)
	if(cycles2>0) then
		for i=0,27,3 do
			table2[3+i]+=0.5
			circfill(table2[1+i],table2[2+i],table2[3+i],8)
		end
		cycles2-=1
	elseif(cycles2<=0) then table2=new_table2() cycles2=10 end
end

function effect1()
	rect(3,50,123,58,0)
	if(cycles>0) then
		for i=0,18,2 do
			circfill(table[1+i],table[2+i],size+rnd(2)+0.5,8)
		end
		size+=0.4
		cycles-=1
	elseif(cycles<=0) then table=new_table() cycles=10 size=0.1 end
end
__gfx__
00000000a777777a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a777777a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
