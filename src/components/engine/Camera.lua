require 'src.geometry.math.Vector'

Camera = {
	pos = Vector:zero(),
	scaleV = 1,
	rotation = 0,
}

function Camera:new (o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self

	return o
end

function Camera:set()
	local cx,cy = math.round(love.graphics.getWidth()/(2*self.scaleV)), math.round(love.graphics.getHeight()/(2*self.scaleV))
	love.graphics.push()
	love.graphics.scale(self.scaleV)
	love.graphics.translate(cx, cy)
	love.graphics.rotate(-self.rotation)
	love.graphics.translate(-self.pos.x, -self.pos.y)
end

function Camera:unset()
	love.graphics.pop()
end

function Camera:move(dx, dy)
	self.pos.x = self.pos.x + (dx or 0)
	self.pos.y = self.pos.y + (dy or 0)
end

function Camera:rotate(dr)
	self.rotation = self.rotation + dr
end

function Camera:scale(s)
	--sx = sx or 1
	self.scaleV = self.scaleV + s
	if self.scaleV < 0.5 then
		self.scaleV = 0.5
	elseif self.scaleV > 3.5 then
		self.scaleV = 3.5
	end
end

function Camera:setPosition(x, y)
	self.pos.x = x or self.pos.x
	self.pos.y = y or self.pos.y
end

function Camera:setScale(s)
	self.scaleV = s or self.scaleV
end

function Camera:getPos (pos)
	local screen = Vector:new ({}, love.graphics.getWidth(), love.graphics.getHeight())
	return pos:add(self.pos:mul(self.scaleV):sub(screen:intDiv(2))) --pos + (self.pos*scaleV - screen//2)
end

function Camera:getVisible ()
	local rect = {}
	rect.origin = self:getPos(Vector:zero())
	rect.ending = self:getPos(Vector:new ({}, love.graphics.getWidth(), love.graphics.getHeight()))
	--print(rect.origin:toString('Visible') .. '\t||\t' .. rect.ending:toString())
	return rect
end

function Camera:print (string, x, y)
	self:unset()
	love.graphics.print(string, x, y)
	self:set()
end

function Camera:update (dt)
	if love.keyboard.isDown('left') then
		self:move(-256*dt/self.scaleV, 0)
	end
	if love.keyboard.isDown('right') then
		self:move(256*dt/self.scaleV, 0)
	end
	if love.keyboard.isDown('up') then
		self:move(0, -256*dt/self.scaleV)
	end
	if love.keyboard.isDown('down') then
		self:move(0, 256*dt/self.scaleV)
	end
	if _MouseWheel ~= 0 then
		self:scale(_MouseWheel*0.25)
	end
end
