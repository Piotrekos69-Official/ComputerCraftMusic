local function drawFloor()
    term.clear()
    term.setCursorPos(1, 1)

    for y = 1, 3 do
        for x = 1, 3 do
            term.setBackgroundColor(colors.blue)
            term.setCursorPos((x - 1) * 4 + 1, (y - 1) * 2 + 1)
            term.write("   ")
            term.setCursorPos((x - 1) * 4 + 1, (y - 1) * 2 + 2)
            term.write("   ")
        end
    end

    term.setBackgroundColor(colors.black)
end

drawFloor()
