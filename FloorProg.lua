-- Attach the monitor peripheral
local mon = peripheral.wrap("left") -- Change to correct side
mon.setTextScale(0.5)

-- Get size
local width, height = mon.getSize()

-- Color palette (change/add colors as you like)
local colorsList = {
  colors.red, colors.orange, colors.yellow, colors.green,
  colors.blue, colors.purple, colors.cyan, colors.pink,
  colors.lime, colors.lightBlue
}

-- Main loop
while true do
  for y = 1, height do
    for x = 1, width do
      local bg = colorsList[math.random(1, #colorsList)]
      mon.setBackgroundColor(bg)
      mon.setCursorPos(x, y)
      mon.write(" ")
    end
  end
  sleep(0.2)
end
