--Player
Entity = require 'objects.Entity'
Player = Entity:extend()

function Player:new(world,x,y)
	self.img = love.graphics.newImage('images/player.png')

	Player.super.new(self,world,x,y,self.img:getWidth(),self.img:getHeight())

	self.vx=0
	self.vy=0
	self.speed=100
	self.jumpSpeed=300
	self.gravity=500

	self.isJumping=false
	self.isGrounded=false


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

	if love.keyboard.isDown('space') and self.isGrounded then
		self.vy = -self.jumpSpeed
		self.isGrounded=false
	end
  
  
	self.vy = self.vy + self.gravity * dt
  if self.isGrounded then
    self.vy = 0
  end
	goaly = self.y + self.vy * dt
  
	local cols = {}
	local len = 0
	self.x, self.y, cols, len = self.world:move(self,goalx,goaly,collisionFilter)
  self.isGrounded=false
	for i, col in ipairs(cols) do
		if col.normal.y < 0 then
			self.isGrounded=true
		end
		if col.other.isEnemy then
			--removeEnemy()
		end
	end
end

function Player:draw()
	love.graphics.draw(self.img,self.x,self.y)
end

return Player