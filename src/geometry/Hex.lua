require 'src.components.engine.Colors'
require 'src.geometry.math.CoordMath'
require 'src.geometry.math.GeoMath'
require 'src.geometry.math.Vector'

local HOVERED_COLOR = {0, 192, 192, 128}
local SELECTED_COLOR = {0, 192, 0, 192}

Hex = {
	q = nil,
	r = nil,
	isHovered = false,
	isSelected = false,
	color = Colors.WHITE,
}
local zeroVertices = {}
local zeroSize = 0

function Hex:new (o, coords)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	o.q = coords.q
	o.r = coords.r
	return o
end

function Hex:getCoords ()
	return {q = self.q, r = self.r}
end

function Hex:setCoords (coords)
	self.q = coords.q
	self.r = coords.r
end

function Hex:equals (other)
	return self.q == other.q and self.r == other.r
end

--[[<coords> is the coordinates of the hex whose neighbour is looked for
	<direction> is the direction in which we are looking for the neighbour
	returns the hex coordinates {q,r} of the neighbour	]]
function Hex:getNeighbour (direction)
	local dir = AXIAL_DIRECTIONS[direction]
	return {q = self.q + dir.q, r = self.r + dir.r}
end

--[[<coords> is the coordinates of the hex whose diagonal is looked for
	<direction> is the direction in which we are looking for the diagonal
	returns the hex coordinates {q,r} of the diagonal	]]
function Hex:getDiagonal (direction)
	local dir = AXIAL_DIAGONALS[direction]
	return {q = self.q + dir.q, r = self.r + dir.r}
end

function Hex:getDistance (other)
	return math.max(
		math.abs(self.q - other.q),
		math.abs(self.q + self.r  -  other.q - other.r),
		math.abs(self.r - other.r))
end


function Hex:setHovered (v)
	self.isHovered = v
	if not self.isSelected then
		if self.isHovered then
			self.color = HOVERED_COLOR
		else
			self.color = Colors.WHITE
		end
	end
end

function Hex:setSelected (v)
	self.isSelected = v
	if self.isSelected then
		self.color = SELECTED_COLOR
	else
		self:setHovered(self.isHovered)
	end
end

function Hex:getVertices(position, size)
	local vertices = {}
	--By calculating only the location of the zero hex, we can calculate every other
	--hex with 12 sums as opposed to calling hexCorner that uses sin,cos,*,/ 
	if size ~= zeroSize then
		local aux = {}
		for i=1, 6 do
			aux = hexCorner({x = 0, y = 0}, size, i-1)
			zeroVertices [i*2-1] = aux.x
			zeroVertices [i*2] = aux.y
		end
		zeroSize = size
	end
	for i=1, 6 do
		vertices [i*2-1] = zeroVertices[i*2-1] + position.x
		vertices [i*2] = zeroVertices[i*2] + position.y
	end
	return vertices
end
function Hex:draw (position, size)
	local vertices = self:getVertices(position, size)

	love.graphics.setColor(self.color)
	love.graphics.polygon('fill', vertices)
	love.graphics.setColor(Colors.BLACK)
	love.graphics.polygon('line', vertices)

end

function Hex:toString ()
	return 'Q: ' .. tostring(self.q) .. '\tR: ' .. tostring(self.r)
end
