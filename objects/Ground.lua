--Ground
local Entity = OBJECTS.entity
local Ground = Entity:extend()

function Ground:new(world,x,y,w,h)
	Ground.super.new(self,world,x,y,w,h)
	self.type = "Ground"
	self.world:add(self,self:getRect())

end	

function Ground:draw()
	love.graphics.rectangle("fill",self:getRect())
end

return Ground