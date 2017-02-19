-- game.lua

game = {}

local level

function game:enter(maze, n)
  level = n
end

function game:update(dt)

end

function game:draw()
  level.draw(level.map)
end
