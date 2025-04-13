-- Audioplayer script by Piotrekos v2.2
local function loadFiles(path)
    local files = {}
    for _, f in ipairs(fs.list(path)) do
        if not fs.isDir(path.."/"..f) then table.insert(files, f) end
    end
    return files
end

local function playFile(path, file, loop)
    local filePath = path.."/"..file
    if fs.exists(filePath) then
        local speakers = {}
        for _, name in ipairs(peripheral.getNames()) do
            if peripheral.getType(name) == "speaker" then
                table.insert(speakers, peripheral.wrap(name))
            end
        end
        
        if #speakers > 0 then
            local dfpwm = require("cc.audio.dfpwm")
            local decoder = dfpwm.make_decoder()

            local function playBuffer(buffer)
                for _, speaker in ipairs(speakers) do
                    while not speaker.playAudio(buffer) do
                        os.pullEvent("speaker_audio_empty")
                    end
                end
            end

            if loop then
                while true do
                    for chunk in io.lines(filePath, 16 * 1024) do
                        playBuffer(decoder(chunk))
                        sleep(0.05)
                    end
                end
            else
                for chunk in io.lines(filePath, 16 * 1024) do
                    playBuffer(decoder(chunk))
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

-- Main
local path = "sounds/"
local files = loadFiles(path)
if #files > 0 then
    print("Now playing: " .. files[1])
    playFile(path, files[1], false)
else
    print("No audio files found in the 'sounds/' folder.")
end
