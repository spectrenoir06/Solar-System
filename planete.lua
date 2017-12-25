function add_planet(mass, pos, speed, color, trace, interval)
	p = {
		mass = mass,
		radius = math.sqrt(mass/math.pi),
		pos = pos or vector(math.random(-500, 2000), math.random(-500, 1500)),
		color = color or {math.random(0,255), math.random(0,255), math.random(0,255)},
		speed = speed or vector(0,0),
		text = math.random(1,7),
		trace = trace and {} or nil,
		timer = 0,
		interval = interval or 0.2
	}
	if trace then
		p.trace[1], p.trace[2] = p.pos.x, p.pos.y
		p.trace[3], p.trace[4] = p.pos.x, p.pos.y
	end
	return p
end

function update_planete_force(p,univ,dt)
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

function update_planete_colision(p, univ)
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

function update_planete_both(p, univ, dt)
	local speed = p.speed
	local mass = p.mass
	local radius = p.radius
	local i = 1
	local nb = #univ
	while i < nb do
		local v = univ[i]
		if p ~= v then
			local sum_radius = radius + v.radius
			local dist = p.pos - v.pos
			local len2 = dist:len2()
			local f = G * ((mass * v.mass) / len2)
			speed = speed - (dist:normalizeInplace() * f * dt)
			if mass >= v.mass and len2 < ((sum_radius) * (sum_radius)) then
				p.mass = p.mass  + v.mass
				p.radius = math.sqrt(p.mass/math.pi)
				p.speed = p.speed + v.speed
				table.remove(univ, i)
				i = i - 1
			end
		end
		i = i + 1
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

function draw_planete(p)
	love.graphics.setColor(p.color)
	if p.trace then
		love.graphics.line(p.trace)
	end
	local img = texture_img[p.text]
	love.graphics.draw(img, p.pos.x - p.radius, p.pos.y - p.radius, 0, p.radius/(img:getWidth()/2), p.radius/(img:getHeight()/2))
	-- love.graphics.circle("line", p.pos.x , p.pos.y, 2)
		-- love.graphics.print("x: "..p.speed.x, p.pos.x, p.pos.y)
		-- love.graphics.print("y: "..p.speed.y, p.pos.x, p.pos.y + 15)
end
