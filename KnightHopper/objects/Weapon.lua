Entity = require 'objects.Entity'
local anim = require 'libs.anim8'
local Weapon = Entity:extend()

function Weapon:new(world,parent)
	self.img = love.graphics.newImage('images/sword.png')

	self.w=32
	self.h=32
	self.parent=player
	Weapon.super.new(self,world,player.x,player.y,self.w,self.h)
	self.offsetx=16
	self.offsety=-8
	self.flipped=false
	self.type="Weapon"
	self.world:add(self,self:getRect())
	self.collisionFilter=function(item,other)
	local x,y,w,h = self.world:getRect(other)
		if other.properties then
		if other.properties.collidable then
			return 'cross'
		elseif other.type == "Player" then    
	    	return 'cross'
	   	end
	   end

	   	return nil
	end
end



function Weapon:update(dt)
	local goalx=self.x
	local goaly=self.y
	if love.keypressed == 'z' and self.vy==0 then
		
	end

	if self.parent.flipped then
		goalx = self.parent.x + -self.offsetx
	else
		goalx = self.parent.x + self.offsetx
	end
	goaly = self.parent.y + self.offsety



  	self.x, self.y, cols, len = self.world:move(self,goalx,goaly,self.collisionFilter)

  	for i, col in ipairs(cols) do

  	end
end


function Weapon:draw()
	love.graphics.draw(self.img,self.x,self.y)
end

return Weapon
