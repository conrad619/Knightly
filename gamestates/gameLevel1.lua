--gameLevel1

local LevelBase = require 'gamestates.LevelBase'

--local Entities = require 'objects.Entities'
--local Entity = require 'objects.Entity'

--local gameLevel1 = Gamestate.new()
local gameLevel1 = LevelBase:extend()

local Player = require 'objects.Player'
local Weapon = require 'objects.Weapon'
local Enemy = require 'objects.Enemy'
local Ground = require 'objects.Ground'

player=nil
weapon=nil
enemy=nil
--world =nil

function gameLevel1:new()
    gameLevel1.super.new(self,'levels/level_1.lua')
    
end

function gameLevel1:enter()
	player = Player(self.world, 32, 32)
  weapon = Weapon(self.world, player)
  enemy = Enemy(self.world, 32*5, 32*8, player)
  self.Entities:add(player)
  self.Entities:add(weapon)
  self.Entities:add(weapon.hitbox)
  self.Entities:add(enemy)
end

function gameLevel1:update(dt)
	self.map:update(dt)
  for i, e in ipairs(self.Entities.entityList) do
    if e.health then
      if e.health <= 0 then
        self.Entities:remove(e)
      end
    end
  end
  self.Entities:update(dt)
  self:positionCamera(player, camera)
  print( table.getn(self.Entities.entityList) )
  
end

function gameLevel1:draw()
	camera:set()
  
  self.map:draw(-camera.x,-camera.y)
  self.Entities:draw()
  
  camera:unset()
end

function gameLevel1:keypressed(key)
  if key == 'x' then

    local x,y = love.mouse.getPosition()
    x = math.floor(x/32)*32
    y = math.floor(y/32)*32
    enemy = Enemy(self.world, x, y, player)
    self.Entities:add(enemy)
  end

  weapon:keypressed(key)
end

function gameLevel1:keyreleased(key)
  weapon:keyreleased(key)
end

return gameLevel1