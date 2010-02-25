menu = {}

function menu.init(tut)
	
	menu.state = tut and 'tutorials' or 'menu' -- or 'tutorials'
end

function menu.update(dt)
	
	if menu.state == 'menu' then
		img.menu:blit(evol.width/2,evol.height/2)
	else
		img.menutut:blit(evol.width/2,evol.height/2)
	end
end

function menu.keydown(key)
	
	if menu.state == 'menu' then
		
		if key == evol.key_1 then
			--setGameMode(game, 'solo')
		elseif key == evol.key_2 then
			setGameMode(game, 'versus')
		elseif key == evol.key_3 then
			menu.state = 'tutorials'
		end
		
	else
		if key == evol.key_1 then
			setGameMode(game, 'tut', 1)
		elseif key == evol.key_2 then
			setGameMode(game, 'tut', 2)
		elseif key == evol.key_3 then
			setGameMode(game, 'tut', 3)
		elseif key == evol.key_4 then
			setGameMode(game, 'tut', 4)
		elseif key == evol.key_7 then
			setGameMode(game, 'tut', 5)
		elseif key == evol.key_8 then
			setGameMode(game, 'tut', 6)
		elseif key == evol.key_9 then
			setGameMode(game, 'tut', 7)
		else
			menu.state = 'menu'
		end
	end
end
