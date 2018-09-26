
--HitBox
local Entity = OBJECTS.entity
local HitBox = Entity:extend()

function HitBox:new(world,parent)

	self.w=32
	self.h=32
	self.damage=25
	self.parent=parent
	self.offsetx=32
	self.offsety=0
	self.active=false

	self.enemy = "Enemy"

	HitBox.super.new(self,world,parent.x,parent.y,self.w,self.h)

	self.world:add(self,self:getRect())
	
	self.type="HitBox"

	self.hitList={}

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
	local goalx=self.parent.x
	local goaly=self.parent.y-16

	if self.parent.flipped then
		goalx = self.parent.x-32
	else
		goalx = self.parent.x
	end

	local cols = {}
	local len = 0

	self.x, self.y, cols, len = self.world:move(self,goalx,goaly,self.collisionFilter)

	self:checkHit(cols,self.enemy)
  
end

function HitBox:draw()
	love.graphics.setColor(255,255,255,0.3)
	if self.active then
		--love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)		
	end
	love.graphics.setColor(255,255,255,1)
end

function HitBox:setActive(active)
	self.active=active
	if not self.active then
		self.hitList = {}
	end
end


function HitBox:checkHit(cols,typee)
	for i, col in ipairs(cols) do

		if col.other.type==typee and self.active then

			local hits =function () 
				if col.other.health then
					if col.other.health > 0 then
						col.other:damage(self.damage,self.parent.parent)
						table.insert(self.hitList,col.other)
					end
				end
			end
			
			local existed=false

			if  #self.hitList == 0 then
				hits()			
			else
				for j=1, #self.hitList do
					if self.hitList[j] == col.other then
						existed=true
					end
				end


				if not existed then
					hits()
				end
			end


		end
	end
end

function HitBox:setEnemy(enemy)
	self.enemy=enemy
end




return HitBox