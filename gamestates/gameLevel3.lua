--gameLevel2

local LevelBase = require 'gamestates.LevelBase'

local gameLevel2 = LevelBase:extend()

local Player = require 'objects.Player'
local Enemy = require 'objects.Enemy'
local Gate = require 'objects.Gate'
local Trap = require 'objects.Trap'


local player=nil
local weapon=nil
local enemy=nil
local gate=nil
local gate2=nil
    
    
ENTITIES={}

function gameLevel2:new()
    gameLevel2.super.new(self,'levels/level_3.lua')
    
end

function gameLevel2:enter()
  if PLAYER.player == nil then
    player = Player(self.world, 0,0,1)

    PLAYER.player = player
  else
    player = PLAYER.player
    player:transfer(self.world)
  end



  

  for i, p in ipairs(self.map.layers.entities.objects) do
    if p.name == "spawn_player" then
      player.world:update(player,p.x,p.y)
      player.checkPoint = {p.x,p.y}
      player.x=p.x
      player.y=p.y
      self.Entities:add(player)
    elseif p.name == "spawn_enemy_s" then
      enemy = Enemy(self.world, p.x,p.y, player,1)
      self.Entities:add(enemy)
      elseif p.name == "spawn_enemy_a" then
      enemy = Enemy(self.world, p.x,p.y, player,2)
      self.Entities:add(enemy)
    elseif p.name == "door_level_1" then
      gate = Gate(self.world,p.x,p.y)
      self.Entities:add(gate)  
    elseif p.name == "door_level_dummy" then
      gate2 = Gate(self.world,p.x,p.y)
      gate2.active = false
      self.Entities:add(gate2)
    end
  end

  for i, p in ipairs(self.map.layers.traps.objects) do

    if p.name == "spike" then
        local spike = Trap(self.world,p.x,p.y,p.name)
        self.Entities:add(spike)  
    elseif p.name == "void" then
        local void = Trap(self.world,p.x,p.y,p.name,p.width,p.height)
        print()
        self.Entities:add(void)  
    end 
  end
  self.Entities:swapOrder(player,gate)

  ENTITIES = self.Entities
  
  

end

function gameLevel2:update(dt)
  if LDR.finishedLoading then
    if gate.proceed then
      --self.Entities:clear()
       -- return Gamestate.switch(LEVELS.GameLevel1.level())
    end
    
    self.map:update(dt)

    self.Entities:update(dt)

    self:positionCamera(player, camera)
    --print( table.getn(self.Entities.entityList) )
  end

end

function gameLevel2:draw()
  if LDR.finishedLoading then
    camera:set()
    
    self.map:draw(-camera.x,-camera.y)

    self.Entities:draw()
    
    camera:unset()

  end
end


function gameLevel2:keypressed(key)

  gameLevel2.super:keypressed(key)
  if key == 'x' then

    local x,y = love.mouse.getPosition()
    x = math.floor(x/32)*32
    y = math.floor(y/32)*32
    enemy = Enemy(self.world, x, y, player)
    self.Entities:addMany(enemy:components())
  end

  player:keypressed(key)
end


return gameLevel2