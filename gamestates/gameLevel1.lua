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
local Ground = require 'objects.Ground'

player=nil
--world =nil

function gameLevel1:new()
    gameLevel1.super.new(self,'levels/level_1.lua')
    
end

function gameLevel1:enter()
	player = Player(self.world, 32, 32)
  self.Entities:add(player)
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

return gameLevel1