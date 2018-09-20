--gameLevel1
bump = require 'libs.bump'
Gamestate = require 'libs.gamestate'
Object = require 'libs.classic'

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
  self.Entities:update(dt)
  self:positionCamera(player, camera)
  
end

function gameLevel1:draw()
	camera:set()
  
  self.map:draw(-camera.x,-camera.y)
  self.Entities:draw()
  
  camera:unset()
end

function gameLevel1:keypressed(key)
  weapon:keypressed(key)
end

return gameLevel1