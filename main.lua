-- Player Objects
	player1 = {x = 20, y = 20, speed = 300, img = nil}
	player2 = {x = 860, y = 20, speed = 300, img = nil}
	Player2Score = 0
	Player1Score = 0
	
-- ball
	ball = {x = 450, y = 240, img = nil}
	a = 350
	b = 350
	reflectTimer = .05
	canReflect = true
	reflectTimerMax = .05

	reflectTimer2 = 1
	canReflect2 = true
	reflectTimerMax2 = 1

	math.randomseed( os.time() )

	startingAngle = math.random(4)

-- Collision detection taken function from http://love2d.org/wiki/BoundingBox.lua
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function love.load()
	gunSound = love.audio.newSource("assets/Klap trap.wav", "static")
	Point = love.audio.newSource("assets/Banana coin.mp3", "static")
end

function love.update( dt )
	-- I always start with an easy way to exit the game
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end

	reflectTimer = reflectTimer - (1 * dt)
	if reflectTimer < 0 then
		canReflect = true
		reflectTimer = reflectTimerMax
	end

	reflectTimer2 = reflectTimer2 - (1 * dt)
	if reflectTimer2 < 0 then
		canReflect2 = true
		reflectTimer2 = reflectTimerMax2
	end

	if love.keyboard.isDown("w") then
		if player1.y > 0 then
			player1.y = player1.y - player1.speed*dt
		end
	elseif love.keyboard.isDown("s") then
		if player1.y < 400 then
			player1.y = player1.y + player1.speed*dt
		end
	end

	if love.keyboard.isDown("up") then
		if player2.y > 0 then
			player2.y = player2.y - player2.speed*dt
		end
	elseif love.keyboard.isDown("down") then
		if player2.y < 400 then
			player2.y = player2.y + player2.speed*dt
		end
	end

	if ball.x > 900 then
		Player1Score = Player1Score + 1
		ball = {x = 450, y = 240, img = nil}
		startingAngle = math.random(4)
		Point:play()
	end

	if ball.x < 0 then
		Player2Score = Player2Score + 1
		ball = {x = 450, y = 240, img = nil}
		startingAngle = math.random(4)
		Point:play()
	end

	if ball.y > 480 or ball.y < 0 then
		if canReflect == true then 
			b = b * (-1)
			canReflect = false
			reflectTimer = reflectTimerMax
			gunSound:play()
		end
	end

	if startingAngle == 1 then
		ball.y = ball.y + b * dt
		ball.x = ball.x + a * dt
	elseif startingAngle == 2 then
		ball.y = ball.y - b * dt
		ball.x = ball.x - a *dt
	elseif  startingAngle == 3 then
		ball.y = ball.y + b * dt
		ball.x = ball.x - a *dt
	elseif startingAngle == 4 then
		ball.y = ball.y + b * dt
		ball.x = ball.x - a *dt
	end

	if CheckCollision(player1.x + 30, player1.y, 1, 80, ball.x, ball.y, 10, 10) then
		if canReflect2 == true then
			a = a * (-1)
			canReflect2 = false
			reflectTimer2 = reflectTimerMax2
			gunSound:play()
		end
	end

	if CheckCollision(player2.x, player2.y, 1, 80, ball.x, ball.y, 10, 10) then
		if canReflect2 == true then
			a = a * (-1)
			canReflect2 = false
			reflectTimer2 = reflectTimerMax2
			gunSound:play()
		end
	end	
end

function love.draw(  )

	-- ball
	love.graphics.setColor(255,255,255,255)
	love.graphics.circle( "fill", ball.x, ball.y, 10, 100 )

	-- middle bar
	love.graphics.setColor(192,192,192,100)
	love.graphics.rectangle("fill", 449, 0, 1, 480)

	-- player1
	love.graphics.setColor(192,192,192,255)
	love.graphics.rectangle("fill", player1.x, player1.y, 20, 80)
	love.graphics.print("Player 1:" .. tostring(Player1Score), 300, 10)

	-- player2
	love.graphics.setColor(192,192,192,255)
	love.graphics.rectangle("fill", player2.x, player2.y, 20, 80)
	love.graphics.print("Player 2:" .. tostring(Player2Score), 600, 10)

	-- love.graphics.print(startingAngle)
	-- random comment
end