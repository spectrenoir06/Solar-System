vector = require "lib/vector"

function add_planet(mass, pos, speed, color)
	table.insert(univ, {
		mass = mass,
		radius = math.sqrt(mass/math.pi),
		pos = pos or vector(math.random(-500, 2000), math.random(-500, 1500)),
		color = color or {math.random(0,255), math.random(0,255), math.random(0,255)},
		speed = speed or vector(0,0),
		text = text or texture_img[math.random(1,7)]
	})
end

function draw_planete(p)
	love.graphics.setColor(p.color)
	love.graphics.draw(p.text, p.pos.x - p.radius, p.pos.y - p.radius, 0, p.radius/(p.text:getWidth()/2), p.radius/(p.text:getHeight()/2))
	-- love.graphics.circle("line", p.pos.x , p.pos.y, 2)
	-- love.graphics.print("x: "..p.speed.x, p.pos.x, p.pos.y)
	-- love.graphics.print("y: "..p.speed.y, p.pos.x, p.pos.y + 15)
end


function update_planete(p,dt)
	local speed = p.speed
	local nb = #univ
	local i = 1
	while i <= nb do
		local v = univ[i]
		if v ~= p then
			local sum_radius = p.radius + v.radius
			local dist = p.pos - v.pos
			length = dist:len2()
			local f = G * ((p.mass * v.mass) / length)
			speed = speed - (dist:normalizeInplace() * f * dt)
			if length < (sum_radius * sum_radius) and p.mass >= v.mass then
				p.mass = p.mass  + v.mass
				p.radius = math.sqrt(p.mass/math.pi)
				speed = speed + v.speed
				table.remove(univ, i)
				nb = nb - 1
				i = i - 1
			end
		end
		i = i + 1
	end
	p.speed = speed
	p.pos = p.pos + (p.speed / p.mass) * dt
end

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
		add_planet(4,nil,vector(math.random(-100,100),math.random(-100,100)),nil)
	end
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
		update_planete(v, 0.01)
	end
end

function love.keypressed(key, isrepeat)
	if key == "escape" then
		love.event.quit()
	end
end
