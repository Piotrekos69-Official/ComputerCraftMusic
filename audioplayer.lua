-- Audioplayer script by Piotrekos
-- Version: 2.2
-- Automatically plays a song on all speakers

-- Load file list from 'sounds/' directory
function loadFileList(interface)
    local fileList = {}
    for _, file in ipairs(fs.list(interface)) do
      if not fs.isDir(interface.."/"..file) then
        table.insert(fileList, file)
      end
    end
    return fileList
end

-- Function to play a file
function playFile(interface, selectedFile, loop)
    local filePath = interface.."/"..selectedFile
    if fs.exists(filePath) and not fs.isDir(filePath) then
      -- Find all connected speakers
      local speakerNames = {}
      for _, name in ipairs(peripheral.getNames()) do
        if peripheral.getType(name) == "speaker" then
          table.insert(speakerNames, peripheral.wrap(name))
        end
      end

      if #speakerNames > 0 then
        local dfpwm = require("cc.audio.dfpwm")
        local decoder = dfpwm.make_decoder()

        local function playBuffer(buffer)
          for _, speaker in ipairs(speakerNames) do
            while not speaker.playAudio(buffer) do
              os.pullEvent("speaker_audio_empty")
            end
          end
        end

        -- Play the file, looping if necessary
        if loop then
          while true do
            for chunk in io.lines(filePath, 16 * 1024) do
              local buffer = decoder(chunk)
              playBuffer(buffer)
              sleep(0.05)
            end
          end
        else
          for chunk in io.lines(filePath, 16 * 1024) do
            local buffer = decoder(chunk)
            playBuffer(buffer)
            sleep(0.05)
          end
        end

        print("File played successfully.")
      else
        print("No speakers found.")
      end
    else
      print("File not found.")
    end
end

-- Main program
local interface = "sounds/"  -- Folder for audio files
createInterface(interface)

-- Load the file list
local fileList = loadFileList(interface)

-- Choose the first file automatically (you can change this)
local selectedFile = fileList[1]

-- Check if we found any files
if selectedFile then
  print("Now playing: " .. selectedFile)
  playFile(interface, selectedFile, false)  -- Play the selected file without looping
else
  print("No audio files found in the 'sounds/' folder.")
end
