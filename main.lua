require "planete"

function love.load()
	univ = {}
	seed = os.time()

	texture_img = {}
	for k,v in ipairs(love.filesystem.getDirectoryItems("text/")) do
		texture_img[k] = love.graphics.newImage("text/"..v)
	end

	width, height, flags = love.window.getMode()

	math.randomseed(seed)

	for i=1,1000 do
		univ[i] = add_planet(
			5, -- mass
			{math.random(-100, width+100), math.random(-100, height+100)}, -- pos
			{math.random(-100,100), math.random(-100,100)} -- speed
		)
	end

	-- univ[1] = add_planet(500, {200,200}, {0,0}, {0xff,0x00,0x00})
	-- univ[2] = add_planet(500, {400,200}, {0,0}, {0xff,0xff,0x00})

	window = { translate = {x = 0, y = 0}, zoom = 1 }

end

function love.draw()
	love.graphics.push()
		love.graphics.translate(window.translate.x, window.translate.y)
		love.graphics.scale(window.zoom)
		for i=1,#univ do
			draw_planete(univ[i])
		end
	love.graphics.pop()

	love.graphics.setColor(255,255,255)
	love.graphics.print("Entity: "..#univ, 10, 10)
	love.graphics.print("fps: "..love.timer.getFPS().."  Vsync: "..(flags.vsync and "On" or "Off"), 10, 35)
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
	elseif key == "up" then
		window.translate.y = window.translate.y + 20
	elseif key == "down" then
		window.translate.y = window.translate.y - 20
	elseif key == "left" then
		window.translate.x = window.translate.x + 20
	elseif key == "right" then
		window.translate.x = window.translate.x - 20
	elseif key == "r" then
		window.translate.x = 0
		window.translate.y = 0
		window.zoom = 1
	end
end

function love.mousepressed(x, y, button, istouch)
	flags.vsync = not flags.vsync
	love.window.setMode( width, height, flags)
end

function love.wheelmoved(x, y)
		local mx,my = love.mouse.getPosition()
		local mouse_x = mx - window.translate.x
		local mouse_y = my - window.translate.y
		local lastzoom = window.zoom
		window.zoom = (window.zoom + (y / 10))
		window.zoom = (window.zoom < 0) and 0 or window.zoom
		local newx = mouse_x * (window.zoom/lastzoom)
		local newy = mouse_y * (window.zoom/lastzoom)
		window.translate.x = window.translate.x + (mouse_x-newx)
		window.translate.y = window.translate.y + (mouse_y-newy)
end
