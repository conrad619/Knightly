LIBS = {
	gamestate = require 'libs.gamestate',
	sti = require 'libs.sti',
	anim = require 'libs.anim8',
	bump = require 'libs.bump',
	classic = require 'libs.classic',
	camera = require 'libs.camera'
}

OBJECTS = {
	entity = require 'objects.Entity',
	entities = require 'objects.Entities',

}

Gamestate = LIBS.gamestate

-- Pull in each of our game states
local mainMenu = require 'gamestates.mainMenu'
local GameLevel1 = require 'gamestates.gameLevel1'
local pause = require 'gamestates.pause'

function love.load()
  local gameLevel1 = GameLevel1()
  Gamestate.registerEvents()
  Gamestate.switch(gameLevel1)
end

function love.keypressed(key)
	Gamestate.current().keypressed(key)
	Gamestate.current().keyreleased(key)
  if key == "escape" then
    love.event.push("quit")
  end
end

function love.draw()
	local x,y = love.mouse.getPosition()
	x = math.floor(x/32)*32
	y = math.floor(y/32)*32
	love.graphics.rectangle("line",x,y,32,32)
end