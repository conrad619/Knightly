--Entity
local Object = require 'libs.classic'
local Entity = Object:extend()

function Entity:new(world,x,y,w,h)
	self.world=world
	self.x=x
	self.y=y
	self.w=w
	self.h=h
end

function Entity:getRect()
	return self.x,self.y,self.w,self.h
end

function Entity:update(dt)

end

function Entity:draw()

end

return Entity
