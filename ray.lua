Ray = {}
Ray.__index = Ray

function Ray.create(a,b,p,q)
	local self = {}
	setmetatable(self,Ray)
	self.a = a
	self.b = b
	self.p = p
	self.q = q
	return self
end

function Ray:getTX(y)
	if self.q == 0 then return 0,0 end

	local t = (y-self.b)/self.q	
	local x = self.a + t*self.p
	return t,x
end

function Ray:getTY(x)
	if self.p == 0 then return 0,0 end

	local t = (x - self.a)/self.p
	local y = self.b + t*self.q
	return t,y
end

function Ray:getXY(t)
	local x = self.a + t*self.p	
	local y = self.b + t*self.q
	return x,y
end

function Ray:collideBox(x,y,w,h)
	local min = 999	
	local col = 0
	local t,ym,xm

	-- left wall
	t,ym = self:getTY(x)
	if ym >= y and ym <= y+h and t > 0 and t < min then
		min = t
		col = 1
	end
	-- right wall
	t,ym = self:getTY(x+w)
	if ym >= y and ym <= y+h and t > 0 and t < min then
		min = t
		col = 2
	end
	-- upper wall
	t,xm = self:getTX(y)
	if xm >= x and xm <= x+w and t > 0 and t < min then
		min = t
		col = 3
	end
	-- lower wall
	t,xm = self:getTX(y+h)
	if xm >= x and xm <= x+w and t > 0 and t < min then
		min = t
		col = 4
	end
	
	if min < 0 then print(min) end
	return min,col
end
