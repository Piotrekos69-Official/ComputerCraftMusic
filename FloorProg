-- Lista kolorów (maksymalnie 16)
local colorsList = {
  colors.red, colors.orange, colors.yellow, colors.lime,
  colors.green, colors.cyan, colors.blue, colors.purple,
  colors.magenta, colors.pink, colors.brown, colors.lightBlue,
  colors.lightGray, colors.gray, colors.black, colors.white
}

-- Do którego urządzenia rysować (np. term, peripheral)
local mon = term
-- Jeśli chcesz rysować na monitorze, odkomentuj linię poniżej:
-- mon = peripheral.wrap("right") -- zmień "right" na stronę monitora

-- Funkcja rysująca kwadrat 3x3
local function drawSquare(x, y, color)
  mon.setBackgroundColor(color)
  for dy = 0, 2 do
    mon.setCursorPos(x, y + dy)
    mon.write("   ")
  end
end

-- Wyczyść ekran
mon.setTextScale(0.5)
mon.setBackgroundColor(colors.black)
mon.clear()

-- Rozmiar ekranu
local w, h = mon.getSize()

-- Rysuj siatkę kolorowych kwadratów
local x, y = 1, 1
for i = 1, #colorsList do
  drawSquare(x, y, colorsList[i])
  x = x + 4
  if x + 2 > w then
    x =
