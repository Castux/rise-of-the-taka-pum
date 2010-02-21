require "class"

Pon = class()

function Pon:init(x,team)
	
	self.x = x
	
	self.team = team
	
	self.state = 'idle'
	self.anim = math.random(0,1) + 1
	
	self.target = 0
	
	return self
end

function Pon:update(dt)
	
	-- animate a bit
	if math.random() < 0.1*dt then
		self.anim = self.anim % 2 + 1
	end
	
	-- march
	if self.state == 'marching' then
		if self.x < self.target then
			self.x = self.x + 50*dt + rand(2)
		else
			self.state = 'idle'
		end
	
	
	elseif self.state == 'retreating' then
		if self.x > self.target then
			self.x = self.x - 50*dt - rand(2)
		else
			self.state = 'idle'
		end
	end
	
	
end

function Pon:draw()
	
	local sprite = "pon" .. self.anim
	
	img[sprite]:blit(self.x,400)
end

function Pon:launch(action)
	
	if action == 'march' then
		self.state = 'marching'
		self.target = self.x + 50 + rand(20)
	
	elseif action == 'retreat' then
		self.state = 'retreating'
		self.target = self.x - 50 - rand(20)
		
	end
end
