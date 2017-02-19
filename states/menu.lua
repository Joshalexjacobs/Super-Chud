-- menu.lua

menu = {}

local options = {
  {num1 = 10, num2 = 10, name = "10 x 10"},
  {num1 = 25, num2 = 25, name = "25 x 25"},
  {num1 = 50, num2 = 50, name = "50 x 50"},
  {num1 = 100, num2 = 100, name = "100 x 100"},
  {num1 = 200, num2 = 200, name = "200 x 200"},
  {num1 = 400, num2 = 300, name = "400 x 300"}
}

local selection = 1

function menu:keypressed(key, code)
  if key == "space" then
    Gamestate.switch(maze, options[selection].num1, options[selection].num2)
  end
  if key == "up" then
    if selection == 1 then
      selection = #options
    else
      selection = selection - 1
    end
  elseif key == "down" then
    if selection == #options then
      selection = 1
    else
      selection = selection + 1
    end
  end
end

function menu:enter()

end

function menu:update(dt)
  -- nothing
end

function menu:draw()
  love.graphics.setColor({100, 100, 100, 100})
  love.graphics.rectangle("fill", -5, selection * 25 - 2, 810, 17.5)

  love.graphics.setColor({0, 0, 0, 255})
  love.graphics.rectangle("line", -5, selection * 25 - 2, 810, 17.5)

  for i = 1, #options do
    love.graphics.printf(options[i].name, 0, 25 * i, love.graphics.getWidth(), "center")
  end
end
