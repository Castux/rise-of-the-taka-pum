require "Drummer"
require "Pon"
require "Arrow"

game = {}

game.init = function()
	
	-- rendering crap
	game.screen1 = evol.makeImage(700,215)
	game.screen1.cx = 0
	game.screen1.cy = 0
	
	game.screen2 = evol.makeImage(700,215)
	game.screen2.cx = 0
	game.screen2.cy = 0
	
	game.drummer1 = Drummer(70,50,1)
	game.drummer2 = Drummer(630,50,2)
	
	game.pons1 = {}
	game.pons2 = {}
	

	game.spawn(5,5,1)
	game.spawn(5,5,2)
	
	game.arrows = {}
	
	-- pick a random background
	game.bg = img["bg" .. math.random(3)]

end

game.spawn = function(spike,bow,team,anim)
	
	local ground = 30 - 1

	local pos = team == 1 and 20 or 1180
	local tab = game["pons" .. team]
	
	local tmp = {}
	
	for i = 1,spike do
		TI(tmp, Pon(math.random()*200+ pos,game.screen1.h - ground,'spike',team))
	end
	
	for i = 1,bow do
		TI(tmp, Pon(math.random()*200+ pos,game.screen1.h - ground,'bow',team))
	end
	

	for i,v in ipairs(tmp) do
		if anim then
			v:spawn()
		end
		TI(tab,v)
	end
	
end

game.update = function(dt,fps,ticks)
	
	-- Update every thing
	
	game.drummer1:update(dt)
	game.drummer2:update(dt)
	
	local i = 1
	while i <= #game.pons1 do
		local die = game.pons1[i]:update(dt)
		if die then
			table.remove(game.pons1, i)
		else
			i = i + 1
		end
	end
	
	local i = 1
	while i <= #game.pons2 do
		local die = game.pons2[i]:update(dt)
		if die then
			table.remove(game.pons2, i)
		else
			i = i + 1
		end
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
		
	game.draw(0,game.screen1)
	game.draw(700,game.screen2)
	
	game.drummer1:draw(game.screen1)
	game.drummer2:draw(game.screen2)
	
	game.screen1:blit(0,0)
	game.screen2:blit(0,215)
end

game.draw = function(shift,surf)

	--evol.fill({153,0,0},nil,surf)
	game.bg:blit(-shift,0,surf)
	
	
	for i,v in ipairs(game.pons1) do
		v:draw(shift,surf)
	end
	
	for i,v in ipairs(game.pons2) do
		v:draw(shift,surf)
	end
	
	for i,v in ipairs(game.arrows) do
		v:draw(shift,surf)
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
	
	if action == 'spawn' then
		game.spawn(4,4,team,true)
		return
	end
	
	for i,v in ipairs(game["pons"..team]) do
		v:launch(action)
	end
end

game.add_arrow = function(x,y,dist)
	
	TI(game.arrows, Arrow(x,y,dist))
	
end

game.inflict_damage = function(x, hit, team)
	
	local eps = 20
	local didhit = false
	
	if not team or team == 2 then
		for i,v in ipairs(game.pons1) do
			if math.abs(v.x-x) < eps then
				v:hit(hit)
				didhit = true
				break
			end
		end
	end	


	if not team or team == 1 then
		for i,v in ipairs(game.pons2) do
			if math.abs(v.x-x) < eps then
				v:hit(hit)
				didhit = true
				break
			end
		end
	end
	
	return didhit
end
