require "Drummer"

game = {}

game.init = function()
	
	game.drummer1 = Drummer(70,50)
	game.drummer2 = Drummer(630,50)
end

game.update = function(dt,fps,ticks)
	
	-- Update every thing
	
	game.drummer1:update(dt)
	game.drummer2:update(dt)
	
	
	-- Draw
	
	evol.fill({99,0,0})
	
	game.drummer1:draw()
	game.drummer2:draw()
	
end

game.keydown = function(key)
	
	if key == evol.key_1 then
		game.drummer1:hit(1)
	elseif key == evol.key_2 then
		game.drummer1:hit(2)
	elseif key == evol.key_3 then
		game.drummer1:hit(3)
	elseif key == evol.key_4 then
		game.drummer1:hit(4)
	end
	
	if key == evol.key_6 then
		game.drummer2:hit(1)
	elseif key == evol.key_7 then
		game.drummer2:hit(2)
	elseif key == evol.key_8 then
		game.drummer2:hit(3)
	elseif key == evol.key_9 then
		game.drummer2:hit(4)
	end
	
end
