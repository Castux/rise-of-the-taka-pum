require "Drummer"
require "Pon"
require "Arrow"

game = {}

game.init = function()
	
	game.drummer1 = Drummer(70,50,1)
	game.drummer2 = Drummer(630,50,2)
	
	game.pons1 = {}
	
	for i=1,5 do
		TI(game.pons1, Pon(math.random()*200+20,'spike',1))
		TI(game.pons1, Pon(math.random()*200+20,'bow',1))
	end
	
	game.arrows = {}
	
end

game.update = function(dt,fps,ticks)
	
	-- Update every thing
	
	game.drummer1:update(dt)
	game.drummer2:update(dt)
	
	for i,v in ipairs(game.pons1) do
		v:update(dt)
	end
	
	local i = 1
	while i <= #game.arrows do
		local die = game.arrows[i]:update(dt)
		if die then
			table.remove(game.arrows, i)
		else
			i = i + 1
		end
	end
	
	-- Draw
	
	evol.fill({153,0,0})
	
	game.drummer1:draw()
	game.drummer2:draw()
	
	for i,v in ipairs(game.pons1) do
		v:draw()
	end
	
	for i,v in ipairs(game.arrows) do
		v:draw(dt)
	end
	
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

game.launch = function(action, team)
	
	for i,v in ipairs(game["pons"..team]) do
		v:launch(action)
	end
end

game.add_arrow = function(x,y,dist)
	
	TI(game.arrows, Arrow(x,y,dist))
	
end
