bump = require 'libs.bump'
Object = require 'libs.classic'

function love.load()

 	world = bump.newWorld(64)

 	
	player = {
	x=300,
	y=300,
	w=32,
	h=32,
	speed=100,
	xv=0,
	yv=0,
	jumpSpeed=300,
	ground=false,
	filter = function (item,other)
		if other.isEnemy then
			return 'cross'
		elseif other.isGround then
			return 'slide'
		end
	end
	}

	enemy = {
	x=350,
	y=480,
	w=32,
	h=32,
	speed=100,
	xv=0,
	yv=0,
	jumpSpeed=300,
	ground=false,
	filter = function (item,other)
		if other.isPlayer then
			return 'cross'
		
		end
	end,
	isEnemy=true
	}


	gravity = -300

	block = {
	x=0,
	y=500,
	w=500,
	h=64,
	isGround=true
	}

	world:add(player,player.x,player.y,player.w,player.h)
	world:add(enemy,enemy.x,enemy.y,enemy.w,enemy.h)
	world:add(block,block.x,block.y,block.w,block.h)
end

function love.update(dt)
	local goalx=player.x
	local goaly=player.y

	if love.keyboard.isDown('left') then
		goalx=player.x-player.speed*dt
	elseif love.keyboard.isDown('right') then
		goalx=player.x+player.speed*dt
	end

	if love.keyboard.isDown('space') and player.ground then
		player.yv = -player.jumpSpeed
		player.ground=false
	end

	goaly = player.y + player.yv * dt
	player.yv = player.yv - gravity * dt

	player.x, player.y, cols, len = world:move(player,goalx,goaly,player.filter)

	for i, col in ipairs(cols) do
		if col.normal.y < 0 then
			player.ground=true
		end
		if col.other.isEnemy then
			removeEnemy()
		end
	end

end

function removeEnemy()
	world:remove(enemy)
	enemy=nil
end	

function love.draw()
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle("fill",player.x,player.y,player.w,player.h)
	if enemy ~= nil then
		love.graphics.rectangle("fill",enemy.x,enemy.y,enemy.w,enemy.h)
	end
	love.graphics.print(player.y,200,200)
	love.graphics.rectangle("fill",block.x,block.y,block.w,block.h)
end