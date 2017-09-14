

--[[<center> is the center of the hexagon in pixels
	<size> is the size of the side of the hexagon in pixels
	<i> is the index of the vertex
	returns the position {x,y} in pixels of the vertex	]]
function hexCorner(center, size, i)
    local angle = math.pi/3 * (i-1)
    return {x = center.x + size * math.cos(angle), y = center.y + size * math.sin(angle)}
end
