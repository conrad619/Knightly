--Entities
local Entities = {
	active=true,
	world=nil,
	entityList={}
}

function Entities:enter(world)
	self:clear()

	self.world = world
end

function Entities:add(entity)
	table.insert(self.entityList, entity)
end

function Entities:addMany(entities)
	for i, entity in ipairs(entities) do
		table.insert(self.entityList, entity)
	end
end

function Entities:remove(entity)
	for i, e in ipairs(self.entityList) do
		if e == entity then
			table.remove(self.entityList, i)
			e.world:remove(e)
			return
		end
	end
end

function Entities:removeAt(index)
	table.remove(self.entityList, index)
end

function Entities:clear()
	for i=1, #self.entityList do
		self.entityList[i] = nil
		table.remove(self.entityList,i)
	end
	self.world=nil
	self.entities={}

end

function Entities:draw()
	if LDR.finishedLoading then
		for i, e in ipairs(self.entityList) do
			e:draw(i)
		end
	end
end

function Entities:update(dt)
	if LDR.finishedLoading then
		for i, e in ipairs(self.entityList) do
			e:update(dt, i)
		end
	end
end

function Entities:length()
	return table.getn(self.entityList)
end


return Entities