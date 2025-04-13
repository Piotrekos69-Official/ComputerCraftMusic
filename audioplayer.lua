-- Audioplayer script by GroupXyz

-- Version: 2.1
-- Play audio files!

function loadFileList(interface)
    local fileList = {}
    for _, file in ipairs(fs.list(interface)) do
      if not fs.isDir(interface.."/"..file) then
        table.insert(fileList, file)
      end
    end
    return fileList
  end
  
  function displayFileList(fileList)
    term.clear()
    term.setCursorPos(1, 1)
    print("----------Audioplayer by GroupXyz----------")
    print("Please place your audio files in the folder 'sounds/'")
    print("Files:")
    for i, file in ipairs(fileList) do
      print(i..". "..file)
    end
  end
  
  function playFile(interface, selectedFile, loop)
    local filePath = interface.."/"..selectedFile
    if fs.exists(filePath) and not fs.isDir(filePath) then
      local speaker = peripheral.find("speaker")
      if speaker then
        local dfpwm = require("cc.audio.dfpwm")
        local decoder = dfpwm.make_decoder()
  
        local function playBuffer(buffer)
          while not speaker.playAudio(buffer) do
            os.pullEvent("speaker_audio_empty")
          end
        end
  
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
        print("Speaker not found.")
      end
    else
      print("File not found.")
    end
  end
  
  function createInterface(interface)
    if not fs.exists(interface) then
      fs.makeDir(interface)
    end
  end

  local queue = {}

  function showInstructions()
    if fs.exists("hideinstructions") then
      return
    end
  
    print("Instructions:")
    print("1. Type the file number to play a file.")
    print("2. Type 'repeat' to loop a file.")
    print("3. Type 'queue' to add a file to the queue.")
    print("4. Type 'playqueue' to play the queue.")
    print("5. Type 'skip' to skip the current file in the queue.")
    print("6. Type 'w' to scroll up and 's' to scroll down.")
    print("7. Type '0' to exit.")
    print("Type 'ok' to continue or 'hide' to disable instructions permanently.")
    while true do
      local input = read()
      if input == "ok" then
        break
      elseif input == "hide" then
        local file = fs.open("hideinstructions", "w")
            if not file then
                term.clear()
                print("Failed to open file for writing, disk space full? Waiting 5s")
                sleep(5)
                return
            end
            file.write("delete this file to show instructions again")
            file.close()
            term.clear()
            print("Instructions hidden, delete the file hideinstructions to reset. Waiting 3s")
            sleep(3)
        break
      else
        print("Please type 'ok' to continue or 'hide' to disable instructions permanently.")
      end
    end
  end
  
  function addToQueue(file)
    table.insert(queue, file)
    print(file .. " added to queue.")
  end
  
  function playQueue(interface)
    while #queue > 0 do
      local file = table.remove(queue, 1)
      playFile(interface, file, false)
    end
  end
  
  function skipQueue()
    if #queue > 0 then
      table.remove(queue, 1)
      print("Skipped current file in queue.")
    else
      print("Queue is empty.")
    end
  end
  
  function scrollFileList(fileList, startIndex, endIndex)
    term.clear()
    term.setCursorPos(1, 1)
    for i = startIndex, endIndex do
      if fileList[i] then
        print(i .. ": " .. fileList[i])
      end
    end
  end  
  
  -- Main program
  local interface = "sounds/"
  createInterface(interface)
  local fileList = loadFileList(interface)
  local startIndex = 1
  local endIndex = 10
  
  showInstructions()

while true do
  scrollFileList(fileList, startIndex, endIndex)
  --print("Which file do you want to play? (Type 'repeat' to loop, 'queue' to add to queue, 'playqueue' to play queue, 'skip' to skip current file in queue, 'scroll' to scroll, 0 to exit)")
  local choice = read()

  if choice == "0" then
    break
  elseif choice == "repeat" then
    print("Enter the file number to repeat:")
    local repeatChoice = tonumber(read())
    if fileList[repeatChoice] then
      playFile(interface, fileList[repeatChoice], true)
    else
      print("Invalid selection.")
    end
  elseif choice == "queue" then
    print("Enter the file number to add to queue:")
    local queueChoice = tonumber(read())
    if fileList[queueChoice] then
      addToQueue(fileList[queueChoice])
    else
      print("Invalid selection.")
    end
  elseif choice == "playqueue" then
    playQueue(interface)
  elseif choice == "skip" then
    skipQueue()
  elseif choice == "w" and startIndex > 1 then
    startIndex = startIndex - 10
    endIndex = endIndex - 10
  elseif choice == "s" and endIndex < #fileList then
    startIndex = startIndex + 10
    endIndex = endIndex + 10
  elseif tonumber(choice) and fileList[tonumber(choice)] then
    playFile(interface, fileList[tonumber(choice)], false)
  else
    print("Invalid selection.")
  end
end
  
