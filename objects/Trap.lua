--Ground
local Entity = OBJECTS.entity
local Trap = Entity:extend()

function Trap:new(world,x,y,name,w,h)
	self.type = "trap"
	self.name = name
	if self.name == "spike" then
		self.img=IMG.spike
		self.h=16
		self.w=16
		self.offsetx=8
		self.offsety=8
		print("spikey")
	elseif self.name == "void" then
		self.img = IMG.void
		self.w=w
		self.h=h
		self.offsetx=0
		self.offsety=0
	end
	Trap.super.new(self,world,x,y,self.w,self.h)

	self.active=true

	self.world:add(self,self:getRect())

	self.filter = function(item,other) 
				if other.type == "Player" then
			      return 'cross'
			    end
			end


  	self.originx=0
  	self.originy=0

end	

function Trap:update(dt)

	local goalx=self.x
	local goaly=self.y

	local cols,len

	self.x,self.y,cols,len = self.world:check(self, goalx, goaly, self.filter)

	for i, col in ipairs(cols) do
		if col.other.type=="Player" or col.other.type == "Enemy" then
			if self.name=="spike" then
				col.other:damage(10,self)
			elseif self.name == "void" then
				col.other:damage(10,self)
				col.other:respawn()
			end
		end
	end

	self.originx =self.x+self.offsetx
	self.originy =self.y+self.offsety


end 

function Trap:draw()
	if self.name == "void" then
    	love.graphics.draw(self.img,self.x,self.y,0,math.floor(self.w/32),1,0,0)
	else
	    love.graphics.draw(self.img,self.x,self.y)
	end
	--love.graphics.rectangle("line",self.x,self.y,self.w,self.h)	
end


return Trap