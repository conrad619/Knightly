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


LDR = require 'libs.love-loader'
IMG={}
ANIM={}
Gamestate = LIBS.gamestate

-- Pull in each of our game states
local mainMenu = require 'gamestates.mainMenu'
local GameLevel1 = require 'gamestates.gameLevel1'
local pause = require 'gamestates.pause'


local anim = LIBS.anim
local loaded = false
function love.load()
	LDR.finishedLoading=false
	LDR.newImage(IMG,'player','images/player.png')
	LDR.newImage(IMG,'enemy','images/enemy.png')
	LDR.newImage(IMG,'sword','images/sword.png')
	LDR.start(function()
    LDR.finishedLoading = true
  end)

end

function love.keypressed(key)
	Gamestate.current().keypressed(key)
	Gamestate.current().keyreleased(key)
  if key == "escape" then
    love.event.push("quit")
  end
end

function love.update(dt)
	if not LDR.finishedLoading then
		LDR.update()
	elseif not loaded then
		loaded=true
		local gameLevel1 = GameLevel1()
		Gamestate.registerEvents()
		Gamestate.switch(gameLevel1)
	
	end
end


function love.draw()
	local x,y = love.mouse.getPosition()
	x = math.floor(x/32)*32
	y = math.floor(y/32)*32
	love.graphics.rectangle("line",x,y,32,32)
end