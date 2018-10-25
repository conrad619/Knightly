--gameLevel1

local LevelBase = require 'gamestates.LevelBase'

local gameLevel1 = LevelBase:extend()

local Player = require 'objects.Player'
local Enemy = require 'objects.Enemy'
local Gate = require 'objects.Gate'
local Trap = require 'objects.Trap'

local player=nil
local gate=nil
local gate2=nil
local weapon=nil
local enemy=nil
local px,py,load=false
local respawn = {x=0,y=0}
ENTITIES={}

function gameLevel1:new()
    gameLevel1.super.new(self,'levels/level_1.lua')
    
end

function gameLevel1:enter()

  if PLAYER.player == nil then
    player = Player(self.world, 0,0,1)

    --PLAYER.player = player
  else
    player = PLAYER.player
    player:transfer(self.world)
  end



  

  for i, p in ipairs(self.map.layers.entities.objects) do

    if p.name == "spawn_player" then
      player.world:update(player,p.x,p.y)
      player.x=p.x
      player.y=p.y
      player.checkPoint = {p.x,p.y}
      self.Entities:add(player)
    elseif p.name == "spawn_enemy" then
      enemy = Enemy(self.world, p.x,p.y, player,love.math.random(1,2))
      self.Entities:add(enemy)
    elseif p.name == "door_level_2" then
      gate = Gate(self.world,p.x,p.y)
      self.Entities:add(gate)  
    elseif p.name == "door_level_dummy" then
      gate2 = Gate(self.world,p.x,p.y)
      gate2.active=false
      self.Entities:add(gate2)
    end
      


  end

  for i, p in ipairs(self.map.layers.traps.objects) do

    if p.name == "spike" then
        local spike = Trap(self.world,p.x,p.y,p.name)
        self.Entities:add(spike)  
    end 
  end

  ENTITIES = self.Entities

  
  

end

function gameLevel1:update(dt)
  if LDR.finishedLoading then
    if gate.proceed then

      self.Entities:clear()

      return Gamestate.switch(LEVELS.GameLevel2.level())
    end

  	self.map:update(dt)    

    self.Entities:update(dt)

    self:positionCamera(player, camera)

  end

end

function gameLevel1:draw()
  if LDR.finishedLoading then
  	camera:set()
    
    self.map:draw(-camera.x,-camera.y)

    self.Entities:draw()
    
    camera:unset()

  end
end


function gameLevel1:keypressed(key)

  gameLevel1.super:keypressed(key)
  if key == 'x' then

    local x,y = love.mouse.getPosition()
    x = math.floor(x/32)*32
    y = math.floor(y/32)*32
    enemy = Enemy(self.world, x, y, player)
    self.Entities:add(enemy)
  end

  player:keypressed(key)
end


return gameLevel1