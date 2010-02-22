require "class"

Arrow = class()

function Arrow:init(x,y,dist)
	
	self.x = x
	self.y = y
	self.yinit = y

	self.g = 800

	self.vx = 500 * (dist > 0 and 1 or -1)
	self.vy = -self.g*dist/2/self.vx
	
	
	return self
end

function Arrow:update(dt)
	
	self.vy = self.vy + self.g*dt
	
	self.x = self.x + self.vx*dt
	self.y = self.y + self.vy*dt
	
	if self.y >= self.yinit then
		-- check collision
		game.inflict_damage(self.x, 10)
		
		-- die
		return true
	end
end

function Arrow:draw(shift,surf)
	
	local sprite
	local dir = self.vx > 0 and "arrow1" or "arrow2"
	
	if math.abs(self.vy) < 300 then
		sprite = img[dir .. "2"]
	elseif self.vy > 0 then
		sprite = img[dir .. "3"]
	else
		sprite = img[dir .. "1"]
	end
	
	sprite:blit(self.x-shift,self.y,surf)
	
end
