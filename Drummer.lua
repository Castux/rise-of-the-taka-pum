require "class"

Drummer = class()

patterns = {
	["1121"] = {0,1,2,3},
	["2121"] = {0,1,2,3},
	["13134"] = {0, 1.5, 2, 2.5, 3},
}

beat = 0.5	-- sec per beat
precision = 1/8


function Drummer:init(x,y)
	
	self.x = x
	self.y = y
	
	self.state = 0
	self.timer = 0
	
	self:reset_pattern()
	
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
	
	-- Pattern clock
	if self.clock >= 0 then
		self.clock = self.clock + dt
		
		if self.clock > self.times[#self.times]*beat + 2*beat then	-- timeout!
			print("timeout")
			self:reset_pattern()
		end
	end
	
	
	
end

function Drummer:draw()
	
	img["drummer".. self.state]:blit(self.x,self.y)
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
	
	local ref = patterns[self.pattern]
	
	if ref then
		
		-- check precision
		local correct = true
		for i,v in ipairs(self.times) do
			
			correct = correct and math.abs(v - ref[i]) < precision
		end
		
		-- launch action
		if correct then
			print "Correct!"
		else
			print "Fail!"
		end
		
		-- reset
		self:reset_pattern()
	end
end
