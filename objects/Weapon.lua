local Entity = OBJECTS.entity
local anim = LIBS.anim
local Weapon = Entity:extend()
local HitBox = require 'objects.HitBox'
local Arrow = require 'objects.Arrow'
local loaded = false
function Weapon:new(world,parent,wep)
  	self.animation = {}
	
	self.wep = wep

	self.switch = {function()
			self.w=64
			self.h=48
			self.offsetx=32
			self.offsety=32
			self.offx=16
			self.offy=0
			self.range=32*2
			self.rangeChase=32*4

			self.img = IMG.sword
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
		end

		,function()
			self.w=64
			self.h=32
			self.offsetx=32
			self.offsety=16
			self.offx=16
			self.offy=0
			self.range=32*5
			self.rangeChase=32

			self.img = IMG.bow
			self.load = function()
				local g = anim.newGrid(64,32,self.img:getWidth(),self.img:getHeight())

				self.animation = {
			      ["idle"]=anim.newAnimation(g('1-1',1),0.1),
			      ["ready"]=anim.newAnimation(g('1-5',1),0.1,function() 
			      	self.animc="fire"

			      	local arrow = Arrow(self.world,self.x,self.y,self.flipped,self.parent.enemy)

			      	end),
			      ["fire"]=anim.newAnimation(g('1-1',1),0.05, function() 
			      	self.animc="idle"
			      	self.isAttacking = false
			      	self.parent.canMove=true
					self.parent.canFlip=true
			      	end)
			    }
			end
		end
		}
	
	self.switch[self.wep]()


	self.parent=parent
	Weapon.super.new(self,world,parent.x,parent.y,self.w,self.h)
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
		goalx = goalx - self.offx
	else
		goalx = goalx + self.offx
	end


  	self.x, self.y, cols, len = self.world:move(self,goalx,goaly,self.collisionFilter)


  	self.animation[self.animc]:update(dt)

  	self.originx = self.x
  	self.originy = self.y

end

function Weapon:attack(key)
	if not self.isAttacking then
		self.animc="ready"
		self.isAttacking=true
		self.parent.canFlip=false
	end
end

function Weapon:draw()
	--love.graphics.rectangle("line",self.x,self.y,3,3)
  	self.animation[self.animc]:draw(self.img, self.x, self.y,0,1,1,self.offsetx,self.offsety)
end

return Weapon
