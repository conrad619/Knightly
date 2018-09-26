--Enemy
local Entity = OBJECTS.entity
local Weapon = require 'objects.Weapon'
local anim = LIBS.anim
local Enemy = Entity:extend()

function Enemy:new(world,x,y,target)
	self.img = IMG.enemy
  	self.animation = {}
	self.load = function()
		local g = anim.newGrid(32,32,self.img:getWidth(),self.img:getHeight())
		self.animation = {
		  ["idle"]=anim.newAnimation(g('1-1',1),0.1),
		  ["walk"]=anim.newAnimation(g('1-8',1),0.1),
		  ["jump"]=anim.newAnimation(g('1-1',1),0.1)
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
	self.animc="idle"
	self.flipped=false
	self.state = 'idle'
	self.world:add(self,self:getRect())
	self.type="Enemy"
	self.health=100
	self.canJump=true

  	self.knockback = 200

	self.offsetx = 8
	self.offsety = 16
	self.originx = 0
	self.originy = 0

	self.blinkRed=false

	self.canAttack=true


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

	--compoonetnsntplsandtpasdnmf;lkm



  self.weapon = Weapon(self.world, self)
  self.weapon.hitbox:setEnemy("Player")

  self.compo = {self,self.weapon,self.weapon.hitbox}

end


function Enemy:update(dt)

        if not self.loaded then
            self:load()
          self.loaded=true
        end
	local goalx=self.x
	local goaly=self.y
  
	--[[if self.target.x+32 < self.x and self.target.y <= self.y then
		goalx=self.x-self.speed*dt
	elseif self.target.x-16 > self.x and self.target.y <= self.y then
		goalx=self.x+self.speed*dt
	end--]]
	if math.abs(self.target.x - self.x) < 32*4 and math.abs(self.target.x - self.x) > 32 and math.abs(self.target.y-self.y) < 64 then
		if self.target.x > self.x then
			goalx=self.x+self.speed*dt
		elseif self.target.x < self.x then
			goalx=self.x-self.speed*dt
		end
		if self.target.y < self.y and self.canJump then
			--self.vy = -self.jumpSpeed
		end
	end


	if math.abs(self.target.x - self.x) < 64 and math.abs(self.target.y-self.y) < 64 then
		if self.target.y-32 <= self.y and self.canAttack then
			self.canAttack=false
			LIBS.tick.delay(function()  self.weapon:attack() end,.5)	

			LIBS.tick.delay(function()  self.canAttack=true end,1.5)			
		end
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
	local jumpFilter = function(items,other) 
      if other.properties and other.properties.collidable then
          self.canJump=true
      end
      return 'cross'
    end
	
	self.x, self.y, cols, len = self.world:move(self,goalx,goaly,self.collisionFilter)
  	_, _, _, _=self.world:check(self,goalx,self.y+16,jumpFilter)
	for i, col in ipairs(cols) do
		if col.other.type=="Enemy" then
		  if self.x < col.other.x then
		    self.x = self.x - self.speed*dt
		  else
		    self.x = self.x + self.speed*dt
		  end
		end
	    if col.other.type == "Player" then
	        col.other:damage(10,self)
	    end

	end
	if self.y ~= goaly then
	    self.vy=0
	else
		self.canJump=false
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
    self.animc="walk"
    self:faceLeft()
  elseif self.state == 'moveRight' then
    self.animc="walk"
    self:faceRight()
  elseif self.state == 'jumping' then
    self.animc="jump"
  elseif self.state == 'idle' then
    self.animc="idle"
  end
end

function Enemy:faceLeft()
  if self.flipped == false and self.vx == 0 then
    for i, a in pairs(self.animation) do
      self.animation[i]:flipH()
    end
    
    self.flipped=true
  end  
end

function Enemy:faceRight()
  if self.flipped == true and self.vx == 0 then
    for i, a in pairs(self.animation) do
      self.animation[i]:flipH()
    end
    self.flipped=false
  end  
end

function Enemy:draw()
    --love.graphics.rectangle("line",self.x,self.y,self.w,self.h)
    --love.graphics.rectangle("line",self.x,self.y,5,200)
  	if self.blinkRed then
  		love.graphics.setColor(1,.5,.5)
  	else
  		love.graphics.setColor(255,255,255)
  	end
  	self.animation[self.animc]:draw(self.img, self.x, self.y,0,1,1,self.offsetx,0)
	love.graphics.setColor(255,255,255)
  
end

function Enemy:damage(damage,source)
	self.health = self.health - damage
		self.vy = -150
		if self.originx < source.originx then
			self.vx = -self.knockback
		elseif self.originx > source.originx then
			self.vx = self.knockback
		end
	if self.health <= 0 then
    	for i, e in ipairs(self:components()) do
	      ENTITIES:remove(e)
	    end
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

function Enemy:components()
  return self.compo
end

return Enemy