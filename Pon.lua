require "class"

Pon = class()

function Pon:init(x,kind,team)
	
	self.x = x
	
	self.kind = kind
	
	self.team = team
	self.dir = self.team == 1 and 1 or -1
	
	self.state = 'idle'
	self.anim = math.random(0,1) + 1
	
	-- for marching/retreating
	self.target = 0
	
	-- for protecting
	self.protect_time = 3
	
	-- multi purpose
	self.timer = 0
	self.bowtimer = 0
	self.spiked = false
	
	-- life!
	self.hp = 100
	
	return self
end

function Pon:update(dt)
	
	local anim_speed = 0.1
	local d = self.dir
	
	-- march
	if self.state == 'marching' then
		if (d == 1 and self.x < self.target) or
			(d == -1 and self.x > self.target) then
			self.x = self.x + d*(50*dt + rand(2))
		else
			self.state = 'idle'
		end
		anim_speed = 5
		
	-- retreat
	elseif self.state == 'retreating' then
		if (d == 1 and self.x > self.target) or
			(d == -1 and self.x < self.target) then
			self.x = self.x - d*(50*dt + rand(2))
		else
			self.state = 'idle'
		end
		anim_speed = 5
	
	-- protect
	elseif self.state == 'protecting' then
		self.timer = self.timer - dt
		if self.timer < 0 then
			self.state = 'idle'
		end
		anim_speed = 0
	
	-- attack
	elseif self.state == 'attacking' then
		self[self.kind .."_attack"](self,dt)
		
	end
	
	-- animate a bit
	if math.random() < anim_speed*dt then
		self.anim = self.anim % 2 + 1
	end
	
	-- die?
	if self.hp < 0 then
		return true
	end
	
end

function Pon:draw()
	
	local sprite
	
	if self.state == 'idle' or
		self.state == 'marching' or
		self.state == 'retreating' or
		self.state == 'attacking' and self.kind == 'bow' then
		
		sprite = img["pon" .. self.kind .. self.team .. self.anim]
	
	
	elseif self.state == 'protecting' then

		sprite = img["pon" .. self.kind .. self.team .. "3"]
	
	elseif self.state == 'attacking' and self.kind == 'spike' then
		sprite = img["pon" .. self.kind .. self.team .. "4"]
	end

	sprite:blit(self.x,400)
end

function Pon:launch(action)

	local d = self.dir
	
	if action == 'march' then
		self.state = 'marching'
		self.target = self.x + d*(50 + rand(20))
	
	elseif action == 'retreat' then
		self.state = 'retreating'
		self.target = self.x - d*(50 + rand(20))
	
	elseif action == 'protect' then
		self.state = 'protecting'
		
		self.timer = self.protect_time + rand(1)
		
	elseif action == 'attack' then
		self.state = 'attacking'
		self.target = self.x + d*(100 + rand(20))
		self.bowtimer = rand(1)
		self.spiked = false
		self.timer = 3
		
	end
end

function Pon:bow_attack(dt)
	
	local d = self.dir
	
	self.bowtimer = self.bowtimer - dt
	if self.bowtimer < 0 then
		game.add_arrow(self.x,400 - 40,d*500)
		
		self.bowtimer = rand(1)
	end
	
	self.timer = self.timer - dt
	if self.timer < 0 then
		self.state = 'idle'
	end
	
end

function Pon:spike_attack(dt)
	
	local d = self.dir
	
	if (d == 1 and self.x < self.target) or 
		(d == -1 and self.x > self.target) then
			self.x = self.x + d*(100*dt + rand(2))

			if not self.spiked then
				-- check collision
				self.spiked = game.inflict_damage(self.x + d*75,50,self.team)
			end
		
		else
			self.state = 'idle'
		end
end
