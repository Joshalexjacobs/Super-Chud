--main.lua

function love:keypressed(key, code)
  if key == 'escape' then -- quit on escape
    love.event.quit()
  end
end

function love.load(arg)
  -- load stuff
end

function love.update(dt)
  -- update stuff
end

function love.draw()
  love.graphics.printf("Hello world", 400, 400, 800)
end
