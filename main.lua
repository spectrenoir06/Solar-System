vector = require "lib/vector"
require "planete"

function love.load()

	G = 500
	texture_name = {
		"earth.png",
		"jupiter.png",
		"mars.png",
		"mercury.png",
		"neptune.png",
		"pluto.png",
		"venus.png"
	}
	texture_img = {}
	for k,v in ipairs(texture_name) do
		texture_img[k] = love.graphics.newImage("text/"..v)
	end
	univ = {}
	math.randomseed(0)

	for i=1,1000 do
		table.insert(univ, add_planet(4, nil, vector(math.random(-100,100), math.random(-100,100)), nil, false))
	end
	-- add_planet(5000,  vector(500, 500), vector(0, 200000), nil, true)
	-- add_planet(5000,  vector(1000, 500), vector(0, -200000), nil, true)

	-- thread = {}
	-- --
	-- -- for i=1,4 do
	-- 	thread.t = love.thread.newThread ( "thread.lua" );
	-- 	thread.t:start();
	-- 	thread.c1 = love.thread.getChannel("send")
	-- 	thread.c2 = love.thread.getChannel("receive")
	-- -- end


end

function love.draw()
	for k,v in ipairs(univ) do
		draw_planete(v)
	end
	love.graphics.setColor(255,255,255)
	love.graphics.print("Entity: "..#univ, 10, 10)
	love.graphics.print("fps: "..love.timer.getFPS(), 10, 40)
end

function love.update(dt)
	for k,v in ipairs(univ) do
		update_planete_force(v, univ, 0.01)
	end
	for k,v in ipairs(univ) do
		update_planete_colision(v, univ)
	end
end

function love.keypressed(key, isrepeat)
	if key == "escape" then
		love.event.quit()
	end
end
