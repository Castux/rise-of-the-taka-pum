-- revenge.lua -- Revenge of the Orange
-- Copyright (C) 2008 Noé Falzon

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

-- All the super globals

evol.init(700,430)
evol.showCursor(false)

-- Main loop


quit = false

while not quit do	
	
	dt,fps,ticks = evolcore.timer()
	
	print(evol.key_escape)
	
	evol.input {
		function(key)
			if key == evol.key_escape then quit = true end
		end
	}
	
	
	evol.flip()		
end

evol.quit()
