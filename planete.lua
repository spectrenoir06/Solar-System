	local G = 1

function add_planet(mass, pos, speed, color, trace, interval)
	p = {
		mass = mass,
		radius = math.sqrt(mass/math.pi),
		pos = pos or {math.random(-500, 2000), math.random(-500, 1500)},
		color = color or {math.random(0,255), math.random(0,255), math.random(0,255)},
		speed = speed or {0,0},
		text = math.random(1,7),
		trace = trace and {} or nil,
		timer = 0,
		interval = interval or 0.2
	}
	if trace then
		p.trace[1], p.trace[2] = p.pos[1], p.pos[2]
		p.trace[3], p.trace[4] = p.pos[1], p.pos[2]
	end
	return p
end

function update_planete_force(nb1, nb2, univ ,dt)
	for i=nb1,nb2 do
		update_planete_force(i, univ, dt)
	end
end

function update_planete_force(nb,univ,dt)
	local p = univ[nb]

	local speed_x = p.speed[1]
	local speed_y = p.speed[2]
	local pos_x = p.pos[1]
	local pos_y = p.pos[2]

	local mass = p.mass
	local univ_size = #univ

	for k,v in ipairs(univ) do
		if k ~= nb then
			local dist_x = pos_x - v.pos[1]
			local dist_y = pos_y - v.pos[2]
			local len  = math.sqrt(dist_x * dist_x + dist_y * dist_y)
			local f = G * ((mass * v.mass) / len)
			speed_x = speed_x - ((dist_x / len) * f * dt)
			speed_y = speed_y - ((dist_y / len) * f * dt)
		end
	end
	p.speed = {speed_x, speed_y}
	p.pos[1] = p.pos[1] + (speed_x / mass) * dt
	p.pos[2] = p.pos[2] + (speed_y / mass) * dt

	if p.mass > 100 and p.trace then
		p.timer = p.timer + dt
		if p.timer > p.interval then
			table.insert(p.trace, p.pos[1])
			table.insert(p.trace, p.pos[2])
			p.timer = 0
			if #p.trace > 200 then
				table.remove(p.trace, 1)
				table.remove(p.trace, 1)
			end
		end
	end
end

function update_planete_colision(nb, univ)
	local p = univ[nb]
	local radius = p.radius
	local mass = p.mass
	local pos_x = p.pos[1]
	local pos_y = p.pos[2]
	local speed_x = p.speed[1]
	local speed_y = p.speed[2]

	for k,v in ipairs(univ) do
		if nb ~= k then
			local sum_radius = radius + v.radius
			local x = pos_x - v.pos[1]
			local y = pos_y - v.pos[2]
			if (x*x+y*y) < (sum_radius * sum_radius) then
				local speed = {
					speed_x + v.speed[1],
					speed_y + v.speed[2]
				}
				if mass >= v.mass then
					-- print("hello")
					p.mass = mass + v.mass
					p.speed = speed
					p.radius = math.sqrt(p.mass/math.pi)
					table.remove(univ, k)
				else
					v.mass = mass + v.mass
					v.speed = speed
					v.radius = math.sqrt(v.mass/math.pi)
					table.remove(univ, nb)
					return
				end
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
	love.graphics.setColor(p.color[1],p.color[2],p.color[3])
	if p.trace then
		love.graphics.line(p.trace)
	end
	local img = texture_img[p.text]
	love.graphics.draw(img, p.pos[1] - p.radius, p.pos[2] - p.radius, 0, p.radius/(img:getWidth()/2), p.radius/(img:getHeight()/2))
	-- love.graphics.circle("line", p.pos.x , p.pos.y, 2)
		-- love.graphics.print("x: "..p.speed.x, p.pos.x, p.pos.y)
		-- love.graphics.print("y: "..p.speed.y, p.pos.x, p.pos.y + 15)
end
