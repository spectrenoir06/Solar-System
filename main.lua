require "planete"

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

	univ = {}
	math.randomseed(0)

	for i=1,1000 do
		univ[i] = add_planet(5, nil, {math.random(-100,100), math.random(-100,100)})
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
	love.graphics.print("fps: "..love.timer.getFPS(), 10, 40)
end

function love.update(dt)
	update_planete_force(univ, 0.0166666)
	update_planete_colision(univ)
end

function love.keypressed(key, isrepeat)
	if key == "escape" then
		love.event.quit()
	end
end
