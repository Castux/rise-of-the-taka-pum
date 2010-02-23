win = {}

function win.init(winner)
	
	win.win = winner
end

function win.update(dt)
	img["win"..win.win]:blit(evol.width/2,evol.height/2)
end

function win.keydown(k)
	setGameMode(menu)
end
