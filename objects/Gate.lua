--Ground
local Entity = OBJECTS.entity
local Gate = Entity:extend()

function Gate:new(world,x,y)
	self.img=IMG.gate
	self.x=x
	self.y=y
	Gate.super.new(self,world,x,y,self.img:getWidth(),self.img:getHeight())

	self.type = "Gate"
	self.proceed=false
	self.active=true

	self.world:add(self,self:getRect())

	self.filter = function(item,other) 
		          	if other.type=="Player" and self.active then 
		              self.proceed=true 
		              return 'cross'
		            end 
		          end

end	

function Gate:update(dt)
	self.x,self.y,_,_ = self.world:check(self, self.x, self.y, self.filter)
end 

function Gate:draw()
    love.graphics.draw(self.img,self.x,self.y)
end

return Gate