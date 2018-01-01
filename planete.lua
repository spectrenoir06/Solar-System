	local G = 100
	local sqrt = math.sqrt

function add_planet(mass, pos, speed, color)
	p = {
		mass = mass,
		radius = math.sqrt(mass/math.pi),
		pos = pos or {math.random(-500, 2000), math.random(-500, 1500)},
		color = color or {math.random(0,255), math.random(0,255), math.random(0,255)},
		speed = speed or {0,0},
		text = math.random(1,7)
	}
	return p
end

function update_planete_force(univ, dt)
	local univ_size = #univ
	for i=1,univ_size do
		local p = univ[i]
		local speed_x, speed_y = p.speed[1], p.speed[2]
		local pos_x, pos_y = p.pos[1], p.pos[2]
		local mass = p.mass
		for j=i+1,univ_size do
			local v = univ[j]
			local dist_x, dist_y = pos_x - v.pos[1], pos_y - v.pos[2]
			local len2 = dist_x * dist_x + dist_y * dist_y
			local len  = math.sqrt(len2)
			local f = G * ((mass * v.mass) / len2)
			local fx, fy = dist_x / len * f * dt, dist_y / len * f * dt
			speed_x, speed_y = speed_x - fx, speed_y - fy
			v.speed[1], v.speed[2] = v.speed[1] + fx, v.speed[2] + fy
		end
		p.speed[1], p.speed[2] = speed_x, speed_y
		p.pos[1], p.pos[2] = pos_x + dt * (speed_x  / mass), pos_y + dt * (speed_y / mass)
	end
end

function update_planete_colision(univ)
	local univ_size = #univ
	local i = 1
	while i <= univ_size do
		local p = univ[i]
		local speed_x, speed_y = p.speed[1], p.speed[2]
		local pos_x, pos_y = p.pos[1], p.pos[2]
		local mass = p.mass
		local radius = p.radius
		local j=i+1
		while j <= univ_size do
			local v = univ[j]
			local sum_radius = radius + v.radius
			local dx, dy = pos_x - v.pos[1], pos_y - v.pos[2]
			if (dx*dx+dy*dy) < (sum_radius * sum_radius) then
				local speed = {
					speed_x + v.speed[1],
					speed_y + v.speed[2]
				}
				univ_size = univ_size - 1
				if mass >= v.mass then
					p.mass = mass + v.mass
					p.speed = speed
					p.radius = math.sqrt(p.mass/math.pi)
					table.remove(univ, j)
				else
					v.mass = mass + v.mass
					v.speed = speed
					v.radius = math.sqrt(v.mass/math.pi)
					table.remove(univ, i)
					break
				end
			end
			j = j + 1
		end
		i = i + 1
	end
end

function draw_planete(p)
	love.graphics.setColor(p.color[1],p.color[2],p.color[3])
	local img = texture_img[p.text]
	love.graphics.draw(img, p.pos[1] - p.radius, p.pos[2] - p.radius, 0, p.radius/(img:getWidth()/2), p.radius/(img:getHeight()/2))
	-- love.graphics.circle("line", p.pos.x , p.pos.y, 2)
	-- love.graphics.print("x: "..p.speed[1], p.pos[1], p.pos[2])
	-- love.graphics.print("y: "..p.speed[2], p.pos[1], p.pos[2] + 15)
end
