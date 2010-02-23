menu = {}

function menu.init()
	
	
end

function menu.update(dt)
	
	img.menu:blit(evol.width/2,evol.height/2)
end

function menu.keydown(key)
	
	--[[for i = 1,9 do
		if key == evol["key_" .. i] then
			setGameMode(game, i)
			break
		end
	end]]
	if key == evol.key_2 then
		setGameMode(game, 2)
	end
end
