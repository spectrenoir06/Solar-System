vector = require "lib/vector"

function add_planet(mass, pos, speed, color, trace, interval)
	p = {
		mass = mass,
		radius = math.sqrt(mass/math.pi),
		pos = pos or vector(math.random(-500, 2000), math.random(-500, 1500)),
		color = color or {math.random(0,255), math.random(0,255), math.random(0,255)},
		speed = speed or vector(0,0),
		text = text or texture_img[math.random(1,7)],
		trace = trace and {} or nil,
		timer = 0,
		interval = interval or 0.2
	}
	if trace then
		p.trace[1], p.trace[2] = p.pos.x, p.pos.y
		p.trace[3], p.trace[4] = p.pos.x, p.pos.y
	end
	table.insert(univ, p)
end

function draw_planete(p)
	love.graphics.setColor(p.color)
	if p.trace then
		love.graphics.line(p.trace)
	end
	love.graphics.draw(p.text, p.pos.x - p.radius, p.pos.y - p.radius, 0, p.radius/(p.text:getWidth()/2), p.radius/(p.text:getHeight()/2))
	-- love.graphics.circle("line", p.pos.x , p.pos.y, 2)
	-- love.graphics.print("x: "..p.speed.x, p.pos.x, p.pos.y)
	-- love.graphics.print("y: "..p.speed.y, p.pos.x, p.pos.y + 15)
end


function update_planete_force(p,dt)
	local speed = p.speed
	local mass = p.mass
	for k,v in ipairs(univ) do
		if p ~= v then
			local dist = p.pos - v.pos
			local f = G * ((mass * v.mass) / dist:len2())
			speed = speed - (dist:normalizeInplace() * f * dt)
		end
	end
	p.speed = speed
	p.pos = p.pos + (p.speed / mass) * dt

	if p.mass > 100 and p.trace then
		p.timer = p.timer + dt
		if p.timer > p.interval then
			table.insert(p.trace, p.pos.x)
			table.insert(p.trace, p.pos.y)
			p.timer = 0
			if #p.trace > 200 then
				table.remove(p.trace, 1)
				table.remove(p.trace, 1)
			end
		end
	end
end

function update_planete_colision(p)
	local radius = p.radius
	local mass = p.mass
	for k,v in ipairs(univ) do
		if p ~= v then
			local sum_radius = radius + v.radius
			if mass >= v.mass and (p.pos - v.pos):len2() < (sum_radius * sum_radius) then
				p.mass = p.mass  + v.mass
				p.radius = math.sqrt(p.mass/math.pi)
				p.speed = p.speed + v.speed
				table.remove(univ, k)
			end
		end
	end
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
		add_planet(4, nil, vector(math.random(-100,100), math.random(-100,100)), nil, false)
	end
	-- add_planet(5000,  vector(500, 500), vector(0, 200000), nil, true)
	-- add_planet(5000,  vector(1000, 500), vector(0, -200000), nil, true)
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
		update_planete_force(v, 0.01)
	end
	for k,v in ipairs(univ) do
		update_planete_colision(v)
	end
end

function love.keypressed(key, isrepeat)
	if key == "escape" then
		love.event.quit()
	end
end
