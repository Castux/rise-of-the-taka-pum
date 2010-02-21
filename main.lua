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

-- Shortcuts

TI = table.insert
rand = function(x) return (math.random()*x) end

-- Set it up

evol.init(700,430)

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
	
	ponbow11 = evol.loadImage("img/ponbow11.png"),
	ponbow12 = evol.loadImage("img/ponbow12.png"),
	ponbow13 = evol.loadImage("img/ponbow13.png"),
}

img.ponspike11.cx = 17
img.ponspike12.cx = 17
img.ponspike13.cx = 17
img.ponspike11.cy = img.ponspike11.h
img.ponspike12.cy = img.ponspike12.h
img.ponspike13.cy = img.ponspike13.h


img.ponbow11.cx = 17
img.ponbow12.cx = 17
img.ponbow13.cx = 17
img.ponbow11.cy = img.ponbow11.h
img.ponbow12.cy = img.ponbow12.h
img.ponbow13.cy = img.ponbow13.h

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
setGameMode = function(mode)
	gameMode = mode
	mode.init()
end

setGameMode(game)
main()
