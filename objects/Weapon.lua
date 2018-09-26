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
	      ["idle"]=anim.newAnimation(g('1-1',1),0.1),
	      ["ready"]=anim.newAnimation(g('1-4',1),0.05,function() 
	      	self.animc="hit"
			self.hitbox:setActive(true)
	      	end),
	      ["hit"]=anim.newAnimation(g('5-6',1),0.05, function() 
	      	self.animc="rest" 	      	
	      	self.hitbox:setActive(false) 
	      	self.isAttacking = false
	      	end),
	      ["rest"]=anim.newAnimation(g('7-7',1),0.05,function()
	      	self.animc="idle"
	      	self.parent.canMove=true
			self.parent.canFlip=true
	      	end)
	    }
	end

	self.w=64
	self.h=64
	self.parent=parent
	Weapon.super.new(self,world,parent.x,parent.y,self.w,self.h)
	self.offsetx=32
	self.offsety=32
	self.flipped=false
	self.type="Weapon"
	self.animc="idle"
	self.flipped=false
	self.isAttacking=false

	self.originx=0
	self.originy=0

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

	self.hitbox = HitBox(self.world,self)

end



function Weapon:update(dt)
        if not self.loaded then
            self:load()
          self.loaded=true
        end
	
	local goalx= self.parent.originx
	local goaly= self.parent.originy

	if not self.flipped and self.parent.flipped then
		for i,a in pairs(self.animation) do
	      self.animation[i]:flipH()
	    end
	    self.flipped=true
	elseif self.flipped and not self.parent.flipped then
		for i,a in pairs(self.animation) do
	      self.animation[i]:flipH()
	    end
	    self.flipped=false
	end


	if self.flipped then
		goalx = goalx - 16
	else
		goalx = goalx + 16
	end


  	self.x, self.y, cols, len = self.world:move(self,goalx,goaly,self.collisionFilter)


  	self.animation[self.animc]:update(dt)

  	self.originx = self.x+self.offsetx
  	self.originy = self.y+self.offsety

end

function Weapon:attack(key)
	if not self.isAttacking then
		self.animc="ready"
		self.isAttacking=true
		self.parent.canFlip=false
	end
end

function Weapon:draw()
	--love.graphics.rectangle("line",self.x,self.y,3,64)
  	self.animation[self.animc]:draw(self.img, self.x, self.y,0,1,1,self.offsetx,self.offsety)
end

return Weapon
