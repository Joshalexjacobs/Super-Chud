-- maze.lua

maze = {}

-- https://love2d.org/forums/viewtopic.php?p=203198#p203198

local Feeler = require 'lib/maze/feeler'
local Connector = require 'lib/maze/connector'
require 'lib/maze/autobatch'

local cellWidth, cellHeight = 100, 100 -- 100 x 100, 200 x 200, 400 x 300
local screenWidth, screenHeight = love.graphics.getDimensions()
local cellsWide, cellsHigh = screenWidth / cellWidth, screenHeight / cellHeight
local map, drawMap, scaleX, scaleY, quadWidth, quadHeight
local DEBUG = false
-- The path coloring debug option uses images to take advantage of autobatch
-- Before: 15-60 FPS; After: 60 (steady)
local indicesImage, colors
local done

local function debug( self, cellWidth, cellHeight )
	love.graphics.draw( indicesImage, colors[self.id], ( self.x - 1 ) * cellWidth, ( self.y - 1 ) * cellHeight, 0, scaleX, scaleY )
	for i = 1, #self.path do
		love.graphics.draw( indicesImage, colors[self.id], ( self.path[i][1] - 1 ) * cellWidth, ( self.path[i][2] - 1 ) * cellHeight, 0, scaleX, scaleY )
	end
end

function maze:enter(menu, w, h)
	done = false

	cellWidth, cellHeight = w, h

	local mazeImage = love.graphics.newImage( 'lib/maze/maze.png' )
	local mazeImageWidth, mazeImageHeight = mazeImage:getDimensions()
	indicesImage = love.graphics.newImage( 'lib/maze/indices.png' )
	local indicesImageWidth, indicesImageHeight = indicesImage:getDimensions()

	quadWidth, quadHeight = 5, 5
	scaleX, scaleY = cellWidth / quadWidth, cellHeight / quadHeight
	local quads = {}
	-- l    r    t    b
	-- lb   rb   tb
	-- lt   rt   lrtb ltb
	-- lr   brt  lrt  lrb
	-- Names are alphabetized
	-- b l r t
	local names = { 'l', 'r', 't', 'b', 'bl', 'br', 'bt', '', 'lt', 'rt', 'blrt', 'blt', 'lr', 'brt', 'lrt', 'blr' }
	local i = 0
	for y = 0, mazeImageHeight - quadHeight, quadHeight do
		for x = 0, mazeImageWidth - quadWidth, quadWidth do
			i = i + 1
			quads[names[i]] = love.graphics.newQuad( x, y, quadWidth, quadHeight, mazeImageWidth, mazeImageHeight )
		end
	end

	colors = {}
	for y = 0, indicesImageHeight - quadHeight, quadHeight do
		for x = 0, indicesImageWidth - quadWidth, quadWidth do
			table.insert( colors, love.graphics.newQuad( x, y, quadWidth, quadHeight, indicesImageWidth, indicesImageHeight ) )
		end
	end

	map = {}
	for y = 1, screenHeight / cellHeight do
		map[y] = {}
		for x = 1, screenWidth / cellWidth do
			map[y][x] = { value = '', id = '' }
		end
	end

	function drawMap(map)
		for y = 1, #map do
			for x = 1, #map[y] do
				love.graphics.draw( mazeImage, quads[map[y][x].value], ( x - 1 ) * cellWidth, ( y - 1 ) * cellHeight, 0, scaleX, scaleY )
			end
		end
	end

	a = Feeler( 1, 1, 1, map )
	b = Feeler( #map[1], 1, 2, map )
	c = Feeler( #map[1], #map, 3, map )
	d = Feeler( 1, #map, 4, map )
	e = Feeler( math.floor( #map[1] / 2 ), math.floor( #map / 2 ), 5, map )

	connector = Connector( map, a, b, c, d, e )
end

function maze:update( dt )
	if not done then
		local adone = a:step()
		local bdone = b:step()
		local cdone = c:step()
		local ddone = d:step()
		local edone = e:step()

		if not (adone or bdone or cdone or ddone or edone) then
			done = true
			connector:connect()
		else
			connector:update()
		end
	elseif done then
		local level = {
			map = map,
			draw = drawMap
		}

		Gamestate.switch(game, level) -- when finished, switch to the main menu
	end
end

function maze:draw()
	love.graphics.setColor({255, 255, 255, 255})

	if DEBUG then
		debug(a, cellWidth, cellHeight)
		debug(b, cellWidth, cellHeight)
		debug(c, cellWidth, cellHeight)
		debug(d, cellWidth, cellHeight)
		debug(e, cellWidth, cellHeight)
	end

	drawMap(map)
end

function maze:keyreleased( key )
	if key == 'escape' then love.event.quit() end
end
