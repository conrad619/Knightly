Gamestate = require 'libs.gamestate'

-- Pull in each of our game states
local mainMenu = require 'gamestates.mainmenu'
local GameLevel1 = require 'gamestates.gameLevel1'
local pause = require 'gamestates.pause'

function love.load()
  local gameLevel1 = GameLevel1()
  Gamestate.registerEvents()
  Gamestate.switch(gameLevel1)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.push("quit")
  end
end