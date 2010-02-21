require "class"

Pon = class()

function Pon:init(x,kind,team)
	
	self.x = x
	
	self.kind = kind
	
	self.team = team
	
	self.state = 'idle'
	self.anim = math.random(0,1) + 1
	
	-- for marching/retreating
	self.target = 0
	
	-- for protecting
	self.protect_time = 3
	
	-- multi purpose
	self.timer = 0
	self.bowtimer = 0
	
	return self
end

function Pon:update(dt)
	
	local anim_speed = 0.1
		
	-- march
	if self.state == 'marching' then
		if self.x < self.target then
			self.x = self.x + 50*dt + rand(2)
		else
			self.state = 'idle'
		end
		anim_speed = 5
		
	-- retreat
	elseif self.state == 'retreating' then
		if self.x > self.target then
			self.x = self.x - 50*dt - rand(2)
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
	
	if action == 'march' then
		self.state = 'marching'
		self.target = self.x + 50 + rand(20)
	
	elseif action == 'retreat' then
		self.state = 'retreating'
		self.target = self.x - 50 - rand(20)
	
	elseif action == 'protect' then
		self.state = 'protecting'
		
		self.timer = self.protect_time + rand(1)
		
	elseif action == 'attack' then
		self.state = 'attacking'
		self.target = self.x + 100 + rand(20)
		self.bowtimer = rand(1)
		self.timer = 3
		
	end
end

function Pon:bow_attack(dt)
	
	self.bowtimer = self.bowtimer - dt
	if self.bowtimer < 0 then
		game.add_arrow(self.x,400 - 40,400)
		
		self.bowtimer = rand(1)
	end
	
	self.timer = self.timer - dt
	if self.timer < 0 then
		self.state = 'idle'
	end
	
end

function Pon:spike_attack(dt)

	if self.x < self.target then
			self.x = self.x + 100*dt + rand(2)
		else
			self.state = 'idle'
		end
end
