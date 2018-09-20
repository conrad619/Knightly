--HitBox
Entity = require 'objects.Entity'
local HitBox = Entity:extend()

function HitBox:new(world,parent)

	self.w=32
	self.h=32
	self.damage=50
	self.parent=parent
	self.offsetx=16
	self.offsety=-8
	self.active=false

	HitBox.super.new(self,world,parent.x,parent.y,self.w,self.h)

	self.world:add(self,self:getRect())
	
	self.type="HitBox"

	self.collisionFilter = function(item,other)
	local x,y,w,h = self.world:getRect(other)
		if other.type=="Enemy" then
			return 'cross'
		end
		if other.type=="Player" then
			return 'cross'
		end
		if other.type=="Ground" then
			return 'cross'
		end

	end
end


function HitBox:update(dt)
	local goalx=self.parent.x+self.offsetx
	local goaly=self.parent.y+self.offsety

	if self.parent.flipped then
		goalx = self.parent.x + -self.offsetx
	else
		goalx = self.parent.x + self.offsetx
	end
	goaly = self.parent.y + self.offsety
	local cols = {}
	local len = 0

	self.x, self.y, cols, len = self.world:move(self,goalx,goaly,self.collisionFilter)

	for i, col in ipairs(cols) do
		if col.other.type=="Enemy" and self.active then
			col.other.health = col.other.health - self.damage
		end
	end
  
end

function HitBox:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
end

function HitBox:setActive(active)
	self.active=active
end


return HitBox