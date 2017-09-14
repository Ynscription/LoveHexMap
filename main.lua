require 'src.components.game.Map'
require 'src.components.engine.Camera'
require 'src.geometry.math.Vector'

math.round = function (number)
	return math.floor(number + 0.5)
end

local testMap = {}
_Camera = {}

_MouseWheel = 0

_Engine = {}

local mouseClickSubscription = {}


function love.load ()
	print("Loading...")
	love.window.maximize()

	love.graphics.setColor(0, 0, 0)
	love.graphics.setBackgroundColor(255, 255, 255)

	Map:new(testMap)
	local hex = {}
	for q = 100, 0, -1 do
		local diff = math.floor(q/2)
		for r = 0,40 do
			hex = Hex:new({}, {q = q, r = r - diff})
			testMap:addHex(hex)
		end
	end

	Camera:new(_Camera)

end

function love.update(dt)
	testMap:update(dt)
	_Camera:update(dt)
	--Reset the MouseWheel movement at the end of every update
	_MouseWheel = 0
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
	if key == 'space' then
		testMap.opti = not testMap.opti
	end
end

function love.wheelmoved(x, y)
	_MouseWheel = y
end

function love.mousepressed(x, y, button, isTouch)
	for k,v in pairs(mouseClickSubscription) do
		v:mouseClick(x, y, button)
	end
end

function love.draw()
	_Camera:set()

	testMap:draw()

	_Camera:unset()
end

function _Engine.mouseClickSubscribe (o)
	mouseClickSubscription[#mouseClickSubscription] = o
end
