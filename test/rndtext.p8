pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
prog = {}
prog.ltime=0
prog.delay=0.5

function _init()
	var=0
	cls()
end

function _update()
	if prog.delay <= time() - prog.ltime then
		print("hello world",1+var,0.01+var,rnd(15))
		prog.ltime = time()
		var+=10
	end
end
