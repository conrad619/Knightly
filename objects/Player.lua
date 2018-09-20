--Player
Entity = require 'objects.Entity'
local anim = require 'libs.anim8'
local Player = Entity:extend()

function Player:new(world,x,y)
	self.img = love.graphics.newImage('images/player.png')
  local g = anim.newGrid(32,32,self.img:getWidth(),self.img:getHeight())
  self.animation = {
      anim.newAnimation(g('1-1',1),0.1),
      anim.newAnimation(g('1-4',1),0.1),
      anim.newAnimation(g('5-5',1),0.1)
    }

  self.w=32
  self.h=32
	Player.super.new(self,world,x,y,self.w,self.h)

	self.vx=0
	self.vy=0
	self.speed=100
	self.jumpSpeed=300
	self.gravity=500

	self.isJumping=false
  
  self.animc=1
  self.flipped=false

  self.state = 'idle'
	self.world:add(self,self:getRect())
end

function Player:collisionFilter(other)
	local x,y,w,h = self.world:getRect(other)

	if other.isGround then
		return 'slide'
	end
end

function Player:update(dt)
	local goalx=self.x
	local goaly=self.y
  
	if love.keyboard.isDown('left') then
		goalx=self.x-self.speed*dt
	elseif love.keyboard.isDown('right') then
		goalx=self.x+self.speed*dt
	end

	if love.keyboard.isDown('space') and self.vy==0 then
		self.vy = -self.jumpSpeed
	end
  
  self.vy = self.vy + self.gravity * dt --gravity
	goaly = self.y + self.vy * dt
  
	local cols = {}
	local len = 0
  local tempx = self.x
  local tempy = self.y
  self.x, self.y, cols, len = self.world:move(self,goalx,goaly,collisionFilter)
  if self.y ~= goaly then
    self.vy=0
  end
  
  
  for i, col in ipairs(cols) do
		if col.other.isEnemy then
			--removeEnemy()
		end
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

function Player:State()
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

function Player:faceLeft()
  if self.flipped == false then
    for i,a in ipairs(self.animation) do
      a:flipH()
    end
    
    self.flipped=true
  end  
end

function Player:faceRight()
  if self.flipped == true then
    for i,a in ipairs(self.animation) do
      a:flipH()
    end
    self.flipped=false
  end  
end

function Player:draw()
	--love.graphics.draw(self.img,self.x,self.y)
  self.animation[self.animc]:draw(self.img, self.x, self.y)
end

return Player