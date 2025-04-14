local dfpwm = require("cc.audio.dfpwm")
local decoder = dfpwm.make_decoder()

local url = "https://raw.githubusercontent.com/Piotrekos69-Official/ComputerCraftMusic/refs/heads/main/mJjKg4p0.wav"

-- Sekundy buforowania
local bufferSeconds = 3
local sampleRate = 48000  -- Hz
local bytesToBuffer = bufferSeconds * sampleRate

-- Pobierz WAV do RAM
local response = http.get(url, nil, true)
if not response then
    print("Błąd pobierania!")
    return
end

local rawData = ""
while #rawData < bytesToBuffer do
    local chunk = response.read(math.min(8192, bytesToBuffer - #rawData))
    if not chunk then break end
    rawData = rawData .. chunk
end
response.close()

-- Dekoduj do DFPWM (jeden wielki buffer)
local decoded = decoder(rawData)

-- Znajdź głośniki
local speakers = {peripheral.find("speaker")}
if #speakers == 0 then
    print("Brak głośników!")
    return
end

-- Ustaw rozmiar porcji (musi być <= 16 KB)
local chunkSize = 16 * 1024

-- Odtwarzaj po kawałkach
local i = 1
while i <= #decoded do
    local chunk = string.sub(decoded, i, i + chunkSize - 1)

    -- Graj synchronicznie na wszystkich głośnikach
    local tasks = {}
    for _, speaker in pairs(speakers) do
        table.insert(tasks, function()
            while not speaker.playAudio(chunk) do
                os.pullEvent("speaker_audio_empty")
            end
        end)
    end

    parallel.waitForAll(table.unpack(tasks))
    i = i + chunkSize
end
