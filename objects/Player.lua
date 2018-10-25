--Player
local Weapon = require 'objects.Weapon'
local Entity = OBJECTS.entity
local anim = LIBS.anim
local Player = Entity:extend()
function Player:new(world,x,y,wep)
	self.img = IMG.player
  self.animation = {}
  self.load = function()
    local g = anim.newGrid(32,32,self.img:getWidth(),self.img:getHeight())
    self.animation = {
        ["idle"]=anim.newAnimation(g('1-1',1),0.1),
        ["run"]=anim.newAnimation(g('2-9',1),0.1),
        ["jump"]=anim.newAnimation(g('7-7',1),0.1)
      }
  end
  self.loaded=false

  self.w=16
  self.h=28
	Player.super.new(self,world,x,y,self.w,self.h)
  self.offsetx = 8
  self.offsety = 16
  self.offx = 8
  self.offy = 4
  self.originx=0
  self.originy=0
	self.vx=0
	self.vy=0
  self.damp = 0.95
	self.speed=100
	self.jumpSpeed=300
	self.gravity=500

	self.isJumping=false

  self.health=300

  self.knockback = 200

  
  self.animc="idle"
  self.flipped=false
  self.canMove=true
  self.canFlip=true
  self.canJump=true

  self.invul=false

  self.checkPoint={}

  self.state = 'idle'
	self.world:add(self,self:getRect())


  self.type="Player"
  self.collisionFilter = function(item,other)
    local x,y,w,h = self.world:getRect(other)
    if other.properties and other.properties.collidable then
        return 'slide'
    end
    if other.type == "Weapon" then
      return 'cross'
    end


    if other.type == "Enemy" then
      return 'cross'
    end

    return 'cross'

  end

  self.jumpFilter = function(items,other) 
      if other.properties and other.properties.collidable then
          self.canJump=true
      end
      return 'cross'
    end

  self.wep=wep
  self.weapon = Weapon(self.world, self,self.wep)
  self.enemy="Enemy"
  self.weapon.hitbox:setEnemy(self.enemy)
  self.compo = {self,self.weapon,self.weapon.hitbox}
end


function Player:update(dt)

        if not self.loaded then
          self:load()
          self.loaded=true
        end
	local goalx=self.x
	local goaly=self.y
  
  if self.canMove or self.state=="jumping" then
  	if love.keyboard.isDown('left') then
  		goalx=goalx-self.speed*dt
  	elseif love.keyboard.isDown('right') then
  		goalx=goalx+self.speed*dt
  	end

  	if love.keyboard.isDown('space') and self.canJump then
  		self.vy = -self.jumpSpeed
  	end
  end
  
  self.vy = self.vy + self.gravity * dt --gravity
	goaly = goaly + self.vy * dt
  
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
  _, _, _, _=self.world:check(self,goalx,self.y+8,self.jumpFilter)

  if self.y ~= goaly then
    self.vy=0
  else
    self.canJump=false
  end
  
  self.animation[self.animc]:update(dt)
  if self.vx == 0 then
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
  end
  
  self:State()
  self.originx = self.x + self.offsetx
  self.originy = self.y + self.offsety

  local comp = self:components()
  for i=2, #comp do
    comp[i]:update(dt)
  end
end


function Player:State()
  if self.state == 'moveLeft' then
    self.animc="run"
    self:faceLeft()
  elseif self.state == 'moveRight' then
    self.animc="run"
    self:faceRight()
  elseif self.state == 'jumping' then
    self.animc="jump"
  elseif self.state == 'idle' then
    self.animc="idle"
  end
end

function Player:faceLeft()
  if self.flipped == false and self.canFlip then
    for i,a in pairs(self.animation) do
      self.animation[i]:flipH()
    end
    
    self.flipped=true
  end  
end

function Player:faceRight()
  if self.flipped == true and self.canFlip then
    for i,a in pairs(self.animation) do
      self.animation[i]:flipH()
    end
    self.flipped=false
  end  
end

function Player:draw()
  if self.blinkRed then
    love.graphics.setColor(255,0,0)
  else
    love.graphics.setColor(255,255,255)
  end
  --love.graphics.draw(self.img,self.x,self.y)
  self.animation[self.animc]:draw(self.img, self.x, self.y,0,1,1,self.offx,self.offy)
  --love.graphics.rectangle("line",self:getRect())
  --love.graphics.rectangle("line",self.originx,self.originy,3,100)

  if self.blinkRed then
      love.graphics.setColor(2,.5,.5)
  else
    love.graphics.setColor(255,255,255)
  end
  --love.graphics.rectangle("line",self.x,self.y,self.w-30,self.h-30)
  local comp = self:components()
  for i=2, #comp do
    comp[i]:draw()
  end

  love.graphics.setColor(.3,0,.7)
  love.graphics.rectangle("fill",self.x-10*10/2+self.offsetx,self.y-32,(self.health/300)*(10*10),10)
  love.graphics.setColor(255,255,255)
  
end

function Player:keypressed(key)
  if key == 'z' then
    self.weapon:attack()
  end
end

function Player:transfer(world)
    for i, e in ipairs(self:components()) do
      e.world = world
      e.world:add(e,e:getRect())
    end
end

function Player:components()

  return self.compo
end

function Player:damage(damage,source)
  if not self.invul then
    if self.health > 0 then
    self.health = self.health - damage
      self.vy = -self.jumpSpeed/2
      if self.originx < source.originx then
        self.vx = -self.knockback
      elseif self.originx > source.originx then
        self.vx = self.knockback
      end
    elseif self.health <= 0 then
      for i, e in ipairs(self:components()) do
        ENTITIES:remove(e)
      end
    end
    self.invul=true
    local delay = .1
    local bt = function() self.blinkRed=true end
    local bf = function() self.blinkRed=false end
    LIBS.tick.delay(bt,delay)
    :after(bf,delay)
    :after(bt,delay)
    :after(bf,delay)
    :after(bt,delay)
    :after(bf,delay)
    :after(function() self.invul=false end ,delay)
  end
end

function Player:respawn()
  local x,y
  x = self.checkPoint[1]
  y = self.checkPoint[2]
  print(x)
  print(y)
  self.world:update(self,x,y)
  self.x = x
  self.y = y
end


return Player