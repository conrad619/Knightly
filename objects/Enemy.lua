--Enemy
local Entity = OBJECTS.entity
local anim = LIBS.anim
local Enemy = Entity:extend()

function Enemy:new(world,x,y,target)
	self.img = IMG.enemy
  	self.animation = {}
	self.load = function()
		local g = anim.newGrid(32,32,self.img:getWidth(),self.img:getHeight())
		self.animation = {
		  anim.newAnimation(g('1-1',1),0.1),
		  anim.newAnimation(g('1-8',1),0.1),
		  anim.newAnimation(g('1-1',1),0.1)
		}
	end
  self.loaded=false

	self.w=16
	self.h=32
	Enemy.super.new(self,world,x,y,self.w,self.h)
	self.target = target
	self.vx=0
	self.vy=0
	self.speed=50
	self.jumpSpeed=300
	self.gravity=500
	self.damp = 0.95
	self.isJumping=false
	self.animc=1
	self.flipped=false
	self.state = 'idle'
	self.world:add(self,self:getRect())
	self.type="Enemy"
	self.health=100

	self.offsetx = 8
	self.offsety = 16
	self.originx = 0
	self.originy = 0

	self.blinkRed=false


	self.collisionFilter = function(item,other)
    	local x,y,w,h = self.world:getRect(other)
		if other.properties then
			if other.properties.collidable then
				return 'slide'
			end
		elseif other.type == "Weapon" then
			return 'cross'
		elseif other.type == "HitBox" then
			return 'cross'
		elseif other.type == "Enemy" then
			return 'cross'
		elseif other.type == "Player" then
			return 'cross'
		end

	end

end


function Enemy:update(dt)

        if not self.loaded then
            self:load()
          self.loaded=true
        end
	local goalx=self.x
	local goaly=self.y
  
	if self.target.x+32 < self.x then
		goalx=self.x-self.speed*dt
	elseif self.target.x-16 > self.x then
		goalx=self.x+self.speed*dt
	end

	if self.target.y < self.y and self.vy==0 then
		self.vy = -self.jumpSpeed
	end
  
  	self.vy = self.vy + self.gravity * dt --gravity
	goaly = self.y + self.vy * dt

	if math.abs(self.vx) < 50 then
		self.vx=0
	else
		self.vx = self.vx * self.damp
	end

	goalx = goalx + self.vx * dt
  
	local cols = {}
	local len = 0
	local tempx = self.x
	local tempy = self.y
	
	self.x, self.y, cols, len = self.world:move(self,goalx,goaly,self.collisionFilter)
	for i, col in ipairs(cols) do
		if col.other.type=="Enemy" then
		  if self.x < col.other.x then
		    self.x = self.x - self.speed*dt
		  else
		    self.x = self.x + self.speed*dt
		  end
		end
	end
	if self.y ~= goaly then
	    self.vy=0
	end

	self.animation[self.animc]:update(dt)

	if tempx > self.x then
		self.state = 'moveLeft'
		self:faceLeft()
	elseif tempx < self.x then
		self.state = 'moveRight'
		self:faceRight()
	else
		self.state = 'idle'
	end

	if math.abs(self.vy) > 0 then
		self.state='jumping'
	end

	self:State()

	self.originx = self.x + self.offsetx
	self.originy = self.y + self.offsety

end

function Enemy:State()
  if self.state == 'moveLeft' then
    self.animc=2
    self:faceLeft()
  elseif self.state == 'moveRight' then
    self.animc=2
    self:faceRight()
  elseif self.state == 'jumping' then
    self.animc=3
  elseif self.state == 'idle' then
    self.animc=1
  end
end

function Enemy:faceLeft()
  if self.flipped == false and self.vx == 0 then
    for i=1,table.getn(self.animation) do
      self.animation[i]:flipH()
    end
    
    self.flipped=true
  end  
end

function Enemy:faceRight()
  if self.flipped == true and self.vx == 0 then
    for i=1,table.getn(self.animation) do
      self.animation[i]:flipH()
    end
    self.flipped=false
  end  
end

function Enemy:draw()
    love.graphics.rectangle("line",self.x,self.y,self.w,self.h)
  	if self.blinkRed then
  		love.graphics.setColor(2,.5,.5)
  	else
  		love.graphics.setColor(255,255,255)
  	end
  	self.animation[self.animc]:draw(self.img, self.x-8, self.y)
	love.graphics.setColor(255,255,255)
  
end

function Enemy:damage(damage,source)
	self.health = self.health - damage
		self.vy = -150
		if self.originx < source.originx then
			self.vx = -200
		elseif self.originx > source.originx then
			self.vx = 200
		end
	if self.health <= 0 then
		ENTITIES:remove(self)
	end

	local delay = .1
	local bt = function() self.blinkRed=true end
	local bf = function() self.blinkRed=false end
	LIBS.tick.delay(bt,delay)
	:after(bf,delay)
	:after(bt,delay)
	:after(bf,delay)
	:after(bt,delay)
	:after(bf,delay)
end

return Enemy