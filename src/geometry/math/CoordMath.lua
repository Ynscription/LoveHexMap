require 'src.geometry.math.Vector'

--Array of unitary hex vectors of the 6 immediate directions of a hex
AXIAL_DIRECTIONS = {									--Map	3
	{q = 1, r = 0}, {q = 1, r =-1}, {q = 0, r =-1},			--4   2
	{q =-1, r = 0}, {q =-1, r = 1}, {q = 0, r = 1}			--5   1
}															--	6

--Array of unitary hex vectors of the 6 immediate diagonals of a hex
AXIAL_DIAGONALS = {										--Map	3 2
	{q = 2, r =-1}, {q = 1, r =-2}, {q =-1, r =-1},			-- 4   1
	{q =-2, r = 1}, {q =-1, r = 2}, {q = 1, r = 1}			--  5 6
}

--[[<cube> is the cube coordinates {x,y,z}
	returns the axial coordinates {q,r}	]]
function cubeToAxial (cube)
	return {q = cube.x, r = cube.z}
end

--[[<coords> is the axial coordinates {q,r}
	returns the cube coordinates {x,y,z}	]]
function axialToCube (coords)
	local aux = - coords.q - coords.r
	return {x = coords.q, y = aux, z = coords.r}
end


function hexToPixel (hex, size)
	local x = size * 3/2 * hex.q
    local y = size * math.sqrt(3) * (hex.r + hex.q/2)
    return Vector:new({}, x, y)
end

function pixelToHex (pos, size)
	local q = ((pos.x * 2/3)/size )
    local r = ((-(pos.x / 3) + (math.sqrt(3)/3) * pos.y) / size )
    return (roundHex({q = q, r = r}))
end


function roundHex (hex)
	local cube = axialToCube(hex)
	local rx = math.round(cube.x)
    local ry = math.round(cube.y)
    local rz = math.round(cube.z)

    local x_diff = math.abs(rx - cube.x)
    local y_diff = math.abs(ry - cube.y)
    local z_diff = math.abs(rz - cube.z)

    if x_diff > y_diff and x_diff > z_diff then
        rx = -ry-rz
    elseif y_diff > z_diff then
        ry = -rx-rz
    else
        rz = -rx-ry
	end

    return cubeToAxial({x = rx, y = ry, z = rz})
end
