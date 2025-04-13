-- Audioplayer script by Piotrekos v2.2
local function playFile(path, file, loop)
    local filePath = path.."/"..file
    if not fs.exists(filePath) then return print("File not found.") end

    local speakers = {}
    for _, name in ipairs(peripheral.getNames()) do
        if peripheral.getType(name) == "speaker" then
            table.insert(speakers, peripheral.wrap(name))
        end
    end
    if #speakers == 0 then return print("No speakers found.") end

    local dfpwm, decoder = require("cc.audio.dfpwm"), require("cc.audio.dfpwm").make_decoder()
    local function playBuffer(buffer)
        for _, speaker in ipairs(speakers) do
            while not speaker.playAudio(buffer) do os.pullEvent("speaker_audio_empty") end
        end
    end

    local chunkIterator = io.lines(filePath, 16 * 1024)
    repeat
        for chunk in chunkIterator do
            playBuffer(decoder(chunk))
            sleep(0.05)
        end
    until not loop
    print("File played successfully.")
end

-- Main
local files = fs.list("sounds/")
if #files > 0 then playFile("sounds", files[1], false) else print("No audio files found.") end
