require "class"

Drummer = class()

patterns = {
	["221"] = {{0,1,2}, 'march-spike'},
	["224"] = {{0,1,2}, 'march-bow'},
	["2221"] = {{0,1,2,3}, 'march'},	

	["111"] = {{0,1,2}, 'retreat-spike'},
	["114"] = {{0,1,2}, 'retreat-bow'},
	["1121"] = {{0,1,2,3}, 'retreat'},

	["131"] = {{0, 1.5, 2}, 'attack-spike'},
	["134"] = {{0, 1.5, 2}, 'attack-bow'},
	["1321"] = {{0, 1.5, 2, 2.5}, 'attack'},
	
	["1331"] = {{0, 1, 1.5, 2}, 'protect-spike'},
	["1334"] = {{0, 1, 1.5, 2}, 'protect-bow'},
	["13321"] = {{0, 1, 1.5, 2, 2.5}, 'protect'},
	
	["42431312"] = {{0, 1, 2, 3.5, 4, 4.5, 5, 5.5}, 'heal'},
	["2311411"] = {{0, 0.5, 1, 1.5, 2, 2.5, 3}, 'sun'},
	
	["3131443131"] = {{0, 0.75, 1.5, 2, 2.5, 3, 4, 4.75, 5.5, 6}, 'spawn'},

}

function find_pattern(name)
	for k,v in pairs(patterns) do
		if v[2] == name then
			return k,copy(v[1])
		end
	end
end

beat = 0.5	-- sec per beat
precision = 1/8


function Drummer:init(x,y,team)
	
	self.x = x
	self.y = y
	self.team = team
	
	self.state = 0
	self.timer = 0
	
	self.fail_timer = -1

	self:reset_pattern()	-- sets pattern, times & clock
	
	self.auto_pattern = ""
	
	return self
end

function Drummer:update(dt)
	
	-- Arm banging timer
	
	if self.timer > 0 then
		self.timer = self.timer - dt
	end
	
	if self.timer < 0 then
		self.state = 0
	end
	
	-- fail timer
	if self.fail_timer > 0 then
		self.fail_timer = self.fail_timer - dt
	end
	
	-- Pattern clock
	if self.clock >= 0 then
		self.clock = self.clock + dt
		
		if self.clock > self.times[#self.times]*beat + 1.75*beat then	-- timeout!
			print("timeout")
			
			if game.tut and self == game.drummer1 then
				game.drummer2:start_auto(game.tut_pattern,patterns[game.tut_pattern][1],-beat)
			end
					
			self:reset_pattern()
		end
	end
	
	-- Auto stuff

	if #self.auto_pattern > 0 then
		self.auto_clock = self.auto_clock + dt
		
		if self.auto_clock >= self.auto_times[1]*beat then
			self:hit(self.auto_pattern:sub(1,1))
			table.remove(self.auto_times,1)
			self.auto_pattern = self.auto_pattern:sub(2,-1)
			
			if #self.auto_pattern == 0 then
				self.auto_clock = -1
			end
		end
	end
	
end

function Drummer:draw(surf)
	
	local x,y = 0,0
	
	if self.fail_timer > 0 then
		x,y = rand(3),rand(3)
	end
	
	img["drummer".. self.state]:blit(self.x+x,self.y+y,surf)
end

function Drummer:hit(n)
	
	self.state = n
	self.timer = 0.20
	
	snd["drum" .. n]:play()
	
	-- Add note to pattern
	
	self.pattern = self.pattern .. n
	
	-- If it's the first one, start the clock
	if self.clock < 0 then
		self.clock = 0
	end

	-- add the current time to the list
	TI(self.times,self.clock/beat)
	
	-- finally check if this matches anything
	self:check_pattern()
	
end

function Drummer:reset_pattern()
		self.pattern = ""
		self.times = {}
		self.clock = -1
end

function Drummer:check_pattern()
	print(self.pattern, table.concat(self.times,","))
	
	local pattern = patterns[self.pattern]
	
	if not pattern then return end
	

	-- check timing precision
	local ref = pattern[1]
	local correct = true
	for i,v in ipairs(self.times) do
		
		correct = correct and math.abs(v - ref[i]) < precision
	end
	
	-- launch action
	if correct then
		print ("Correct! " .. pattern[2])
		game.launch(pattern[2], self.team)
		
		if game.tut and self == game.drummer1 and self.pattern == game.tut_pattern then
			game.tut_ok = 1
		end
	else
		print "Fail!"
		self.fail_timer = 1
	end
	
	-- tutorial case : launch auto repeat
	if game.tut and self == game.drummer1 and not game.tut_ok then

		game.drummer2:start_auto(game.tut_pattern,patterns[game.tut_pattern][1],-beat)
	end
	
	-- reset
	self:reset_pattern()

end

function Drummer:start_auto(pat,times,delay)
	
	self.auto_pattern = pat
	self.auto_times = copy(times)
	
	self.auto_clock = delay or 0	-- give a certain delay
end
