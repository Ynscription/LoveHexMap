require 'src.geometry.math.Vector'
require 'src.geometry.math.CoordMath'
require 'src.geometry.Hex'


Map = {
	HEX_SIZE = 100,
	hexes = {},
	hoveredHex = nil,
	selectedHex = nil,
	batchHex = Hex:new({},{q = 0, r = 0}),
	opti = true
}

function Map:new (o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self

	_Engine.mouseClickSubscribe(o)

	return o
end

function Map:addHex (hex)
	self.hexes[hex.q] = self.hexes[hex.q] or {}
	self.hexes[hex.q][hex.r] = hex
end

function Map:getHex (hex)
	local aux = self.hexes [hex.q]
	if aux then
		return self.hexes[hex.q][hex.r]
	else
		return nil
	end
end

function Map:update(dt)
	--self.hoveredHex = self.hexes[]
	local mouse = Vector:new ({}, love.mouse.getX(), love.mouse.getY())
	local aux = pixelToHex(_Camera:getPos(mouse), self.HEX_SIZE*_Camera.scaleV)
	local hex = self:getHex(aux)
	if self.hoveredHex and hex then
		if not (self.hoveredHex:equals(hex)) then
			self.hoveredHex:setHovered(false)
			hex:setHovered(true)
			self.hoveredHex = hex
		end
	elseif self.hoveredHex then
		self.hoveredHex:setHovered(false)
		self.hoveredHex = hex
	elseif hex then
		hex:setHovered(true)
		self.hoveredHex = hex
	end
end

function Map:mouseClick (x, y, button)
	if button == 1 then
		local mouse = Vector:new ({}, x, y)
		local aux = pixelToHex(_Camera:getPos(mouse), self.HEX_SIZE*_Camera.scaleV)
		local hex = self:getHex(aux)
		if self.selectedHex and hex then
			if not (self.selectedHex:equals(hex)) then
				self.selectedHex:setSelected(false)
				hex:setSelected(true)
				self.selectedHex = hex
			end
		elseif self.selectedHex then
			self.selectedHex:setSelected(false)
			self.selectedHex = hex
		elseif hex then
			hex:setSelected(true)
			self.selectedHex = hex
		end
	end
end

function Map:draw ()

	local view = _Camera:getVisible()
	local hexStart = pixelToHex(view.origin, self.HEX_SIZE*_Camera.scaleV)
	local hexEnd = pixelToHex(view.ending, self.HEX_SIZE*_Camera.scaleV)

	--Calculate the visible hexes and only draw those
	local rangeR = hexEnd.q - hexStart.q
	local startR = hexStart.r

	--We add two to the range, since the geometry of the hex makes difficult to know the edge values
	for q=hexEnd.q + 1, hexStart.q - 1, -1 do
		local diff = math.floor((q - hexStart.q - 1)/2)
		local aux = self.hexes[q]
		if aux then
			for r=startR-1, startR + rangeR+1 do
				if aux[r-diff] then
					local pos = hexToPixel(aux[r-diff], self.HEX_SIZE)
					aux[r-diff]:draw(pos, self.HEX_SIZE)
				end
			end
		end
	end
	--[[Old drawing code without optimization
	for k1,v1 in pairs(self.hexes) do
		for k2,v2 in pairs(v1) do
			local pos = hexToPixel(v2, self.HEX_SIZE)
			v2:draw(pos, self.HEX_SIZE)
		end
	end
	]]

end
