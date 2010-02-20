require "class"

Drummer = class()

function Drummer:init(x,y)
	
	self.x = x
	self.y = y
	
	self.state = 0
	self.timer = 0
	
	return self
end

function Drummer:update(dt)
	
	if self.state ~= 0 then
		self.timer = self.timer - dt
	end
	
	if self.timer < 0 then
		self.state = 0
	end
	
end

function Drummer:draw()
	
	img["drummer".. self.state]:blit(self.x,self.y)
end

function Drummer:hit(n)
	
	self.state = n
	self.timer = 0.20
	
	snd["drum" .. n]:play()
	
end
