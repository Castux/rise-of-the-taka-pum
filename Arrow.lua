require "class"

Arrow = class()

function Arrow:init(x,y,dist)
	
	self.x = x
	self.y = y

	self.g = 1500

	self.vx = 500
	self.vy = -self.g*dist/2/self.vx
	
	
	return self
end

function Arrow:update(dt)
	
	self.vy = self.vy + self.g*dt
	
	self.x = self.x + self.vx*dt
	self.y = self.y + self.vy*dt
	
	if self.y >= 400 then
		-- die
		return true
	end
end

function Arrow:draw()
	
	img.arrow11:blit(self.x,self.y)
	
end
