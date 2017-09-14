Vector = {
	x = nil,
	y = nil
}


function Vector:new (o, x, y)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	o.x = x
	o.y = y
	return o
end


function Vector:zero (o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	o.x = 0
	o.y = 0
	return o
end
VECTOR_ZERO = Vector:zero()

function Vector:add (otherV)
	return Vector:new ({}, self.x + otherV.x, self.y + otherV.y)
end

function Vector:sub (otherV)
	return Vector:new ({}, self.x - otherV.x, self.y - otherV.y)
end

function Vector:mul (v)
	return Vector:new ({}, self.x*v, self.y*v)
end

function Vector:div (v)
	return Vector:new ({}, self.x/v, self.y/v)
end

function Vector:intDiv (v)
	return Vector:new ({}, math.round(self.x / v), math.round(self.y / v))
end

function Vector:equals (otherV)
	if otherV then
		return (self.x == otherV.x) and (self.y == otherV.y)
	else
		return false
	end
end

function Vector:copy ()
	return Vector:new ({}, self.x, self.y)
end

function Vector:toString(name)
	name = name or ''
	return name .. '-->\tX: ' .. tostring(self.x) .. ',\tY: ' .. tostring(self.y)
end
