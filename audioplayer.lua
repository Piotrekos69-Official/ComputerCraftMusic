-- simpleplayer.lua
-- Usage: simpleplayer <file>

local args = { ... }
if #args < 1 then
  print("Usage: simpleplayer <file>")
  return
end

local filePath = args[1]
if not fs.exists(filePath) or fs.isDir(filePath) then
  print("Invalid file: " .. filePath)
  return
end

-- Find a speaker (using the first available speaker)
local speaker = peripheral.find("speaker")
if not speaker then
  print("No speaker found.")
  return
end

local dfpwm = require("cc.audio.dfpwm")
local decoder = dfpwm.make_decoder()

-- Read the file in chunks, decode, and play on the speaker
for chunk in io.lines(filePath, 16 * 1024) do
  local buffer = decoder(chunk)
  while not speaker.playAudio(buffer) do
    os.pullEvent("speaker_audio_empty")
  end
  sleep(0.05)
end

print("Playback finished.")
