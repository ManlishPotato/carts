pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
deg=0
rad=5

ox=63
oy=63

startx=10
starty=10
endx=120
endy=120

startrad=1
endrad=20

circcount=0
circmax=10

function _init()
	cls()
	pset(ox,oy,7)
end

function _update60()
	for i=0,15,1 do
		px=((cos(deg/360))*rad)+ox
		py=((sin(deg/360))*rad)+oy
		
		pset(px,py,8)
		
		if(deg>=360) then 
			deg=0

			ox=flr(rnd(endx-startx)+startx)
			oy=flr(rnd(endy-starty)+starty)
			rad=flr(rnd(endrad-startrad)+startrad)			
						
			pset(ox,oy,7)
			circcount+=1
		else 
			deg+=1
		end
	end
	
	if(circcount>circmax) then
		circcount=0
		cls()
	end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000