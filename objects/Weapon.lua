local Entity = OBJECTS.entity
local anim = LIBS.anim
local Weapon = Entity:extend()
local HitBox = require 'objects.HitBox'
local loaded = false
function Weapon:new(world,parent)
	self.img = IMG.sword
  	self.animation = {}
	self.load = function()
		local g = anim.newGrid(64,48,self.img:getWidth(),self.img:getHeight())

		self.animation = {
	      anim.newAnimation(g('1-1',1),0.1,function() self.animation[2]:resume() end),
	      anim.newAnimation(g('1-3',1),0.05,function() 
	      	self.animc=3 
			self.hitbox:setActive(true)
	      	end),
	      anim.newAnimation(g('4-7',1),0.05,function()
	      	self.hitbox:setActive(false) 
	      	self.isAttacking = false
	      	self.animc=1
	      	self.parent.canMove=true
			self.parent.canFlip=true
	      	end)
	    }
	end

	self.w=64
	self.h=64
	self.parent=parent
	Weapon.super.new(self,world,parent.x,parent.y,self.w,self.h)
	self.offsetx=16
	self.offsety=8
	self.flipped=false
	self.type="Weapon"
	self.animc=1
	self.flipped=false
	self.isAttacking=false

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

	self.hitbox = HitBox(self.world,parent)

end



function Weapon:update(dt)
	if LDR.finishedLoading then
	
	if not loaded then
		self.load()
		loaded=true
	end
	
	local goalx=self.parent.x+self.parent.originx
	local goaly=self.parent.y+self.parent.originy

	if self.parent.flipped then
		goalx = goalx + -self.offsetx
	else
		goalx = goalx + self.offsetx
	end
	goaly = goaly + self.offsety

	


	if not self.flipped and self.parent.flipped then
		for i,a in ipairs(self.animation) do
	      a:flipH()
	    end
	    self.flipped=true
	elseif self.flipped and not self.parent.flipped then
		for i,a in ipairs(self.animation) do
	      a:flipH()
	    end
	    self.flipped=false
	end



  	self.x, self.y, cols, len = self.world:move(self,goalx,goaly,self.collisionFilter)


  	self.animation[self.animc]:update(dt)


	end
end

function Weapon:keypressed(key)
	if key == 'z' and not self.isAttacking then
		self.animc=2
		self.isAttacking=true
		self.parent.canFlip=false
	end
end

function Weapon:keyreleased(key)

end


function Weapon:draw()
  if LDR.finishedLoading then
	love.graphics.rectangle("line",self.x,self.y,self.w,self.h)
  	self.animation[self.animc]:draw(self.img, self.x, self.y)
  end
end

return Weapon
