require "planete"

function love.load()
	univ = {}
	seed = 1234 -- os.time()

	texture_img = {}
	for k,v in ipairs(love.filesystem.getDirectoryItems("text/")) do
		texture_img[k] = love.graphics.newImage("text/"..v)
	end

	width, height, flags = love.window.getMode()

	math.randomseed(0)

	for i=1,1000 do
		univ[i] = add_planet(
			5, -- mass
			{math.random(-100, width+100), math.random(-100, height+100)}, -- pos
			{math.random(-100,100), math.random(-100,100)} -- speed
		)
	end

	-- univ[1] = add_planet(500, {200,200}, {0,0}, {0xff,0x00,0x00})
	-- univ[2] = add_planet(500, {400,200}, {0,0}, {0xff,0xff,0x00})

end

function love.draw()
	local len = #univ
	for i=1,len do
		draw_planete(univ[i])
	end
	love.graphics.setColor(255,255,255)
	love.graphics.print("Entity: "..#univ, 10, 10)
	love.graphics.print("fps: "..love.timer.getFPS().."  Vsync: "..(flags.vsync and "On" or "Off	"), 10, 35)
	love.graphics.print("Seed: "..seed, 10, 60)
end

function love.update(dt)
	update_planete_force(univ, 0.0166666)
	update_planete_colision(univ)
end

function love.keypressed(key, isrepeat)
	if key == "escape" then
		love.event.quit()
	elseif key == "space" then
		flags.vsync = not flags.vsync
		love.window.setMode( width, height, flags)
	end
end

function love.mousepressed( x, y, button, istouch )
	flags.vsync = not flags.vsync
	love.window.setMode( width, height, flags)
end
