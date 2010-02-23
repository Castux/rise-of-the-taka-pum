-- Copyright (C) 2009 Noé Falzon <firstname.lastname@aliceadsl.fr>

-- This program is  free software:  you can redistribute it and/or modify it
-- under  the terms  of the  GNU General Public License  as published by the
-- Free Software Foundation, version 3 of the License.
--
-- This program  is  distributed  in the hope  that it will  be useful,  but
-- WITHOUT  ANY WARRANTY;  without  even the implied  warranty of MERCHANTA-
-- BILITY  or  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
-- License for more details.
--
-- You should have received a copy of the  GNU General Public License  along
-- with this program. If not, see <http://www.gnu.org/licenses/>.

require "evol"

require "game"
require "win"

-- Shortcuts

TI = table.insert
rand = function(x) return (math.random()*x) end

copy = function(t)
	local u = {}
	for k,v in pairs(t) do u[k] = v end
	return u
end

-- Set it up

evol.init(700,430)
math.randomseed(os.time())

-- Load stuff

img = {
	drummer0 = evol.loadImage("img/drummer.png"),
	drummer1 = evol.loadImage("img/drummer1.png"),
	drummer2 = evol.loadImage("img/drummer2.png"),
	drummer3 = evol.loadImage("img/drummer3.png"),
	drummer4 = evol.loadImage("img/drummer4.png"),
	
	ponspike11 = evol.loadImage("img/ponspike11.png"),
	ponspike12 = evol.loadImage("img/ponspike12.png"),
	ponspike13 = evol.loadImage("img/ponspike13.png"),
	ponspike14 = evol.loadImage("img/ponspike14.png"),
	
	ponspike21 = evol.loadImage("img/ponspike21.png"),
	ponspike22 = evol.loadImage("img/ponspike22.png"),
	ponspike23 = evol.loadImage("img/ponspike23.png"),
	ponspike24 = evol.loadImage("img/ponspike24.png"),
	
	ponbow11 = evol.loadImage("img/ponbow11.png"),
	ponbow12 = evol.loadImage("img/ponbow12.png"),
	ponbow13 = evol.loadImage("img/ponbow13.png"),
	
	ponbow21 = evol.loadImage("img/ponbow21.png"),
	ponbow22 = evol.loadImage("img/ponbow22.png"),
	ponbow23 = evol.loadImage("img/ponbow23.png"),
	
	arrow11 =  evol.loadImage("img/arrow11.png"),
	arrow12 =  evol.loadImage("img/arrow12.png"),
	arrow13 =  evol.loadImage("img/arrow13.png"),
	
	arrow21 =  evol.loadImage("img/arrow21.png"),
	arrow22 =  evol.loadImage("img/arrow22.png"),
	arrow23 =  evol.loadImage("img/arrow23.png"),
	
	bg1 = evol.loadImage("img/bg1.png"),
	bg2 = evol.loadImage("img/bg2.png"),
	bg3 = evol.loadImage("img/bg3.png"),
	
	blood1 = evol.loadImage("img/blood1.png"),
	blood2 = evol.loadImage("img/blood2.png"),
	blood3 = evol.loadImage("img/blood3.png"),
	
	heal = evol.loadImage("img/heal.png"),
	spawn = evol.loadImage("img/spawn.png"),
	
	win1 = evol.loadImage("img/win1.png"),
	win2 = evol.loadImage("img/win2.png"),
}

img.ponspike11.cx = 17
img.ponspike12.cx = 17
img.ponspike13.cx = 17
img.ponspike14.cx = 17
img.ponspike11.cy = img.ponspike11.h
img.ponspike12.cy = img.ponspike12.h
img.ponspike13.cy = img.ponspike13.h
img.ponspike14.cy = img.ponspike14.h

img.ponspike21.cx = img.ponspike21.w - 17
img.ponspike22.cx = img.ponspike22.w - 17
img.ponspike23.cx = img.ponspike23.w - 17
img.ponspike24.cx = img.ponspike24.w - 17
img.ponspike21.cy = img.ponspike21.h
img.ponspike22.cy = img.ponspike22.h
img.ponspike23.cy = img.ponspike23.h
img.ponspike24.cy = img.ponspike14.h

img.ponbow11.cx = 17
img.ponbow12.cx = 17
img.ponbow13.cx = 17
img.ponbow11.cy = img.ponbow11.h
img.ponbow12.cy = img.ponbow12.h
img.ponbow13.cy = img.ponbow13.h

img.ponbow21.cx = img.ponbow21.w - 17
img.ponbow22.cx = img.ponbow22.w - 17
img.ponbow23.cx = img.ponbow23.w - 17
img.ponbow21.cy = img.ponbow21.h
img.ponbow22.cy = img.ponbow22.h
img.ponbow23.cy = img.ponbow23.h

for i = 1,3 do
	img["bg"..i].cx = 0
	img["bg"..i].cy = 0
end

snd = {}
for i = 1,4 do
	snd["drum" .. i] = evol.loadSound("snd/drum" .. i .. ".ogg")
end

function main()

	quit = false

	while not quit do	
		
		local dt,fps,t = evol.timer()
		
		evol.input {
			gameMode.keydown
		}
		
		if gameMode.update then
			gameMode.update(dt,fps,t)
		end
		
		evol.flip()
	end

	evol.quit()
end

-- Game mode manager
setGameMode = function(mode,...)
	gameMode = mode
	mode.init(...)
end

setGameMode(game)
main()
