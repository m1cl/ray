require("ray")

local lg = love.graphics

WIDTH = 80
HEIGHT = 60
SCALE = math.floor(800/WIDTH)
FOVX = 1.04 -- ~ 60 degrees

cols = {}
cols[0] = {0,0,0,255}
cols[1] = {255,0,0,255}
cols[2] = {0,255,0,255}
cols[3] = {0,0,255,255}
cols[4] = {255,255,0,255}

x,y = 3.5, 3.5
rot = 0

function love.load()
	lg.setMode(WIDTH*SCALE,HEIGHT*SCALE,false)
	map = genMap(8,8)

	dists = {}
	colors = {}
	for i=0,WIDTH-1 do
		dists[i] = 0
		colors[i] = 0
	end
end

function love.update(dt)
	if love.keyboard.isDown("left") then
		rot = rot-2*dt
	elseif love.keyboard.isDown("right") then
		rot = rot+2*dt
	end
	if love.keyboard.isDown("up") then
		x = x + math.cos(rot)*3*dt
		y = y + math.sin(rot)*3*dt
	elseif love.keyboard.isDown("down") then
		x = x - math.cos(rot)*3*dt
		y = y - math.sin(rot)*3*dt
	end
end

function love.draw()
	castRays()

	lg.scale(SCALE)	
	lg.setColor(128,128,128,255)
	lg.rectangle("fill",0,HEIGHT/2,WIDTH,HEIGHT/2)

	for i=0,WIDTH-1 do
		local colh = HEIGHT/dists[i]
		lg.setColor(cols[colors[i]])
		lg.rectangle("fill",i,(HEIGHT-colh)/2,1,colh)
	end
end

function castRays()
	for i=0,WIDTH-1 do
		local rotm = rot - FOVX/2 + i*(FOVX/WIDTH)
		local pm = math.cos(rotm)
		local qm = math.sin(rotm)
		local r = Ray.create(x,y,pm,qm)
		local mint = 999
		for ix = 0,7 do
			for iy = 0,7 do
				if map[ix][iy] > 0 then
					local t,c = r:collideBox(ix,iy,1,1)
					if t < mint then
						mint = t
						colors[i] = c
					end
				end
			end
		end
		dists[i] = mint
	end
end

function genMap(w,h)
	local map = {}
	for i=0,w-1 do
		map[i] = {}
	end

	for ix=0,w-1 do
		for iy=0,h-1 do
			map[ix][iy] = 0
		end
	end

	for i = 0,w-1 do
		map[i][0] = 1
		map[i][h-1] = 1
	end
	for i = 0,h-1 do
		map[0][i] = 1
		map[w-1][i] = 1
	end
	map[w-1][4] = 0
	map[w-1][2] = 0
	map[1][4] = 1

	return map
end

function love.keypressed(k,uni)
	if k == 'escape' then
		love.event.push('q')	
	end
end
