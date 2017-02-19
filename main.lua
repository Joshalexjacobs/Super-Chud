--main.lua

Gamestate = require "lib/Gamestate"

-- states
require "states/menu"
require "states/maze"
require "states/game"

function love:keypressed(key, code)
  if key == 'escape' then -- quit on escape
    love.event.quit()
  end
end

function love.load(arg)
  -- load stuff
  love.graphics.setDefaultFilter( 'nearest', 'nearest' )
  love.graphics.setBackgroundColor( 255, 255, 255 )
  Gamestate.registerEvents()
  Gamestate.switch(menu)
end
