vector = require "lib/vector"
require "planete"
local effil = require "effil"

function love.load()
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
	univ = {} --effil.table()
	math.randomseed(0)

	for i=1,1000 do
		univ[i] = add_planet(5, nil, {math.random(-100,100), math.random(-100,100)}, nil, false)
	end

	-- univ[1] = add_planet(500, {200,200})
	-- univ[2] = add_planet(500, {400,200})

	print(univ)
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
	local len = #univ
	for i=1,len do
		draw_planete(univ[i])
	end
	love.graphics.setColor(255,255,255)
	love.graphics.print("Entity: "..#univ, 10, 10)
	love.graphics.print("fps: "..love.timer.getFPS(), 10, 40)
end

function love.update(dt)
	for i=1,#univ do
		--local thr = effil.thread(update_planete_force)(i , univ, 0.01)
		--thr:wait()
		update_planete_force(i, univ, 0.0166666)
	end

	for k,v in ipairs(univ) do
		update_planete_colision(k, univ)
	end

	-- for k,v in ipairs(univ) do
	-- 	--update_planete_force(v, univ, 0.01)
	-- end
	-- for k,v in ipairs(univ) do
	-- 	update_planete_colision(v, univ)
	-- end
end

function love.keypressed(key, isrepeat)
	if key == "escape" then
		love.event.quit()
	end
end
