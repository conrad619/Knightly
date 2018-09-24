--gameLevel2

local LevelBase = require 'gamestates.LevelBase'

--local Entities = require 'objects.Entities'
--local Entity = require 'objects.Entity'

--local gameLevel2 = Gamestate.new()
local gameLevel2 = LevelBase:extend()

local Player = require 'objects.Player'
local Weapon = require 'objects.Weapon'
local Enemy = require 'objects.Enemy'
local Ground = require 'objects.Ground'

local player=nil
local weapon=nil
local enemy=nil

ENTITIES={}

function gameLevel2:new()
    gameLevel2.super.new(self,'levels/level_2.lua')
    
end

function gameLevel2:enter()
	player = Player(self.world, 32, 32)
  weapon = Weapon(self.world, player)
  enemy = Enemy(self.world, 32*5, 32*8, player)
  self.Entities:add(player)
  self.Entities:add(weapon)
  self.Entities:add(weapon.hitbox)
  self.Entities:add(enemy)
  ENTITIES = self.Entities

  --[[for i=0, 10,1 do ------------------create 25 enemies
    enemy = Enemy(self.world, love.math.random(1,500), 8, player)
    self.Entities:add(enemy)
  end--]]
end

function gameLevel2:update(dt)
  if LDR.finishedLoading then
  	self.map:update(dt)
      print(table.getn(self.Entities.entityList))
    --[[
    for i, e in ipairs(self.Entities.entityList) do
      if e.health then
        if e.health <= 0 then
          self.Entities:remove(e)
        end
      end
    end--]]
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
    self.Entities:add(enemy)
  end

  weapon:keypressed(key)
end

function gameLevel2:keyreleased(key)
  weapon:keyreleased(key)
end

return gameLevel2