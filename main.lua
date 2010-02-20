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

-- Set it up

evol.init(700,350)

function main()

	quit = false

	while not quit do	
		
		local dt,fps,t = evol.timer(25)
		
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
