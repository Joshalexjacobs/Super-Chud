--main.lua

Gamestate = require "lib/Gamestate"

-- states
require "states/menu"
require "states/maze"

function love:keypressed(key, code)
  if key == 'escape' then -- quit on escape
    love.event.quit()
  end
end

function love.load(arg)
  -- load stuff

  Gamestate.registerEvents()
  Gamestate.switch(maze) -- swtich to game screen
end
