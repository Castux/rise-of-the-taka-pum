require "Drummer"
require "Pon"
require "Arrow"
require "tutorials"

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
	game.bg = math.random(3)
	
	-- fade to win screen
	game.fade = -1
	game.fade_img = evol.makeImage(700,430)
	game.fade_img:fill{255,255,255,10}
	game.fade_img.cx = 0
	game.fade_img.cy = 0
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
	
	-- Winning condition
	if not game.winner and #game.pons1 == 0 then
		game.winner = 2
		game.fade = 2
		print "2 wins"
	elseif not game.winner and #game.pons2 == 0 then
		game.winner = 1
		game.fade = 2
		print "1 wins"
	end
	
	-- Draw
		
	game.draw(0,game.screen1)
	game.draw(700,game.screen2)
	
	game.drummer1:draw(game.screen1)
	game.drummer2:draw(game.screen2)
	
	game.screen1:blit(0,0)
	game.screen2:blit(0,215)
	
	local x,y = evol.mouse()
	textwrap(font,"Hé falut les copains, ça va bien ? Moi oui, super !",x,y,150,100,{0,100,0})
	
	
	-- fade
	if game.fade > 0 then
		game.fade_img:fill{255,255,255,(2-game.fade)/2*255}
		game.fade_img:blit()
		game.fade = game.fade - dt
		if game.fade < 0 then
			setGameMode(win,game.winner)
		end
	end
end

game.draw = function(shift,surf)

	img["bg"..game.bg]:blit(-shift,0,surf)
	

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


gind = nil
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
	
	if key == evol.key_a then
	
		gind = next(patterns,gind)
		game.drummer2:start_auto(gind,patterns[gind][1])
	end
end

game.launch = function(action, team)
	
	if action == 'spawn' then
		game.spawn(2,2,team,true)
		return
	elseif action == 'sun' then
		game.bg = game.bg % 3 + 1
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
