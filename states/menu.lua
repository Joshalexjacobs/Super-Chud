-- menu.lua

menu = {}

local ourMap = {
  map = nil,
  draw = function(map)
		for y = 1, #map do
			for x = 1, #map[y] do
				love.graphics.draw( mazeImage, quads[map[y][x].value], ( x - 1 ) * cellWidth, ( y - 1 ) * cellHeight, 0, scaleX, scaleY )
			end
		end
	end,
}

function menu:enter(maze)
end

function menu:update(dt)

end

function menu:draw()

end
