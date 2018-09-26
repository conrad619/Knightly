local bump = LIBS.bump
local Gamestate = LIBS.gamestate
local Object = LIBS.classic
local sti = LIBS.sti
local Entities = OBJECTS.entities
local camera = LIBS.camera

local LevelBase = Object:extend()
LevelBase:implement(Gamestate)

function LevelBase:new(mapFile)
  self.map = sti(mapFile, {'bump'})
  self.world = bump.newWorld(32)
  self.map:resize(love.graphics.getWidth(), love.graphics.getHeight())
  
  self.map:bump_init(self.world)
  Entities:enter()
  self.Entities = Entities
  self.camera = camera
end

function LevelBase:keypressed(key)
  if Gamestate.current() ~= pause and key =='p' then
    Gamestate.push(pause)
  end
end


function LevelBase:positionCamera(player,camera)
  local mapWidth = self.map.width * self.map.tilewidth
  local halfScreenx = love.graphics.getWidth() / 2
  local mapHeight = self.map.height * self.map.tileheight
  local halfScreeny = love.graphics.getHeight() / 2
  
  if player.x < (mapWidth - halfScreenx) then
    boundX = math.max(0, player.x - halfScreenx)
  else
    boundX = math.min(player.x - halfScreenx, mapWidth - love.graphics.getWidth())
  end

  if player.y < (mapHeight - halfScreeny) then
    boundY = math.max(0, player.y - halfScreeny)
  else
    boundY = math.min(player.y - halfScreeny, mapHeight - love.graphics.getHeight())
  end
  camera:setPosition(boundX,boundY)
end

return LevelBase
