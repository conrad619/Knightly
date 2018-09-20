--gameLevel1
bump = require 'libs.bump'
Gamestate = require 'libs.gamestate'
Object = require 'libs.classic'

local LevelBase = require 'gamestates.LevelBase'

--local Entities = require 'objects.Entities'
--local Entity = require 'objects.Entity'

--local gameLevel1 = Gamestate.new()
local gameLevel1 = Object:extends()
gameLevel1:implement(LevelBase)

local Player = require 'objects.Player'
local Ground = require 'objects.Ground'

player=nil
--world =nil

function gameLevel1:enter()
	world = bump.newWorld(32)

	Entities:enter()
	player = Player(world, 32, 32)
	ground_0 = Ground(world, 0,32*10,32*20,32)

	Entities:addMany({player, ground_0})
end

function gameLevel1:update(dt)
	Entities:update(dt)
end

function gameLevel1:draw()
	Entities:draw()
end

return gameLevel1