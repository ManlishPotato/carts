pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
function _init()

end

function _update()
		cls()

	for i=0,5,1 do 
		if(btn(i,0)) then print("player 0, btn: "..i) end
	end
	
		for i=0,5,1 do 
		if(btn(i,1)) then print("player 1, btn: "..i) end
	end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000