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
		  anim.newAnimation(g('1-1',1),0.1),
		  anim.newAnimation(g('1-1',1),0.1)
		}
	end
  self.loaded=false

	self.w=32
	self.h=32
	Enemy.super.new(self,world,x,y,self.w,self.h)
	self.target = target
	self.vx=0
	self.vy=0
	self.speed=50
	self.jumpSpeed=300
	self.gravity=500
	self.isJumping=false
	self.animc=1
	self.flipped=false
	self.state = 'idle'
	self.world:add(self,self:getRect())
	self.type="Enemy"
	self.health=100

	self.collisionFilter = function(item,other)
		local x,y,w,h = self.world:getRect(other)
		if other.properties then
			if other.properties.collidable then
				return 'slide'
			end
		end

		if other.type == "Weapon" then
			return 'cross'
		end

		if other.type == "HitBox" then
			return 'cross'
		end
		if other.type == "Enemy" then
			return 'cross'
		end
	end

end


function Enemy:update(dt)
	if LDR.finishedLoading then
	    if not self.loaded then
        	self.load()
	    	self.loaded=true
	    end
	local goalx=self.x
	local goaly=self.y
  
	if self.target.x+64 < self.x then
		goalx=self.x-self.speed*dt
	elseif self.target.x-64 > self.x then
		goalx=self.x+self.speed*dt
	end

	if self.target.y < self.y and self.vy==0 then
		self.vy = -self.jumpSpeed
	end
  
  	self.vy = self.vy + self.gravity * dt --gravity
	goaly = self.y + self.vy * dt
  
	local cols = {}
	local len = 0
	local tempx = self.x
	local tempy = self.y
	
	self.x, self.y, cols, len = self.world:move(self,goalx,goaly,self.collisionFilter)
	
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


	end
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
  if self.flipped == false then
    for i,a in ipairs(self.animation) do
      a:flipH()
    end
    
    self.flipped=true
  end  
end

function Enemy:faceRight()
  if self.flipped == true then
    for i,a in ipairs(self.animation) do
      a:flipH()
    end
    self.flipped=false
  end  
end

function Enemy:draw()
  if LDR.finishedLoading then
	  self.animation[self.animc]:draw(self.img, self.x, self.y)
	end
  
end

function Enemy:damage(damage)
	self.health = self.health - damage
end

return Enemy