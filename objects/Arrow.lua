--Ground
local Entity = OBJECTS.entity
local Arrow = Entity:extend()

function Arrow:new(world,x,y,flip,enemy)
	self.img=IMG.arrow
	self.offsetx=16
	self.offsety=3
	self.x=x-self.offsetx
	self.y=y-self.offsety
	self.h=5
	self.w=32
	self.enemy=enemy
	Arrow.super.new(self,world,self.x,self.y,self.img:getWidth(),self.h)

	self.speed = 150
	self.flipped=flip
	self.offy=13

	self.health=10

	if not self.flipped then
		self.scalex=1
		self.offx=0
	elseif self.flipped then
		self.scalex=-1
		self.offx=32
	end
	self.type = "Arrow"
	self.active=true

	self.world:add(self,self:getRect())

	self.filter = function(item,other) 

					if other.properties then
						if other.properties.collidable then
							--print(other.layer.name)
							return 'touch'
						end
					elseif other.type=="Player" then 
		              	return 'cross'
		            elseif other.type == "Enemy" then
						return 'cross'
		            end 

		            return 'cross'
		          end

  	ENTITIES:add(self)

  	self.originx=0
  	self.originy=0

end	

function Arrow:update(dt)

	local goalx=self.x
	local goaly=self.y

	if self.flipped then
		goalx=goalx-self.speed*dt
	elseif not self.flipped then
		goalx=goalx+self.speed*dt
	end

	local cols,len

	self.x,self.y,cols,len = self.world:move(self, goalx, goaly, self.filter)
	for i, col in ipairs(cols) do
		if col.other.type==self.enemy then
			
			col.other:damage(10,self)
			ENTITIES:remove(self)
		elseif col.other.layer and col.other.layer.name=="ground" or (col.other.type=="HitBox" and col.other.active) then

			ENTITIES:remove(self)
		end

	end

	self.originx =self.x + 16
	self.originy =self.y + 3


end 

function Arrow:draw()
    love.graphics.draw(self.img,self.x,self.y,0,self.scalex,1,self.offx,self.offy)
	--love.graphics.rectangle("line",self.originx,self.originy,3,3)	
end


return Arrow