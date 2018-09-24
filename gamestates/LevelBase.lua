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
  local halfScreen = love.graphics.getWidth() / 2
  
  if player.x < (mapWidth - halfScreen) then
    boundX = math.max(0, player.x - halfScreen)
  else
    boundX = math.min(player.x - halfScreen, mapWidth - love.graphics.getWidth())
  end
  camera:setPosition(boundX,boundY)
end

return LevelBase
