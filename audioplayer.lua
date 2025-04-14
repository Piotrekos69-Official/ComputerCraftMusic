local dfpwm = require("cc.audio.dfpwm")
local decoder = dfpwm.make_decoder()

local url = "https://raw.githubusercontent.com/Piotrekos69-Official/ComputerCraftMusic/refs/heads/main/mJjKg4p0.wav"

-- Zmienna czasu buforowania (w sekundach)
local bufferSeconds = 3

-- Domyślna jakość WAV (CraftOS używa zazwyczaj 48000 Hz)
local sampleRate = 48000

-- Ile bajtów WAV pobierzemy (przy mono i 1 byte/sample)
local bytesToBuffer = bufferSeconds * sampleRate

-- Pobieranie WAV
local response = http.get(url, nil, true)
if not response then
    print("Nie udało się połączyć!")
    return
end

-- Buforowanie danych
local rawData = ""
while #rawData < bytesToBuffer do
    local chunk = response.read(math.min(8192, bytesToBuffer - #rawData))
    if not chunk then break end
    rawData = rawData .. chunk
end
response.close()

-- Dekodowanie WAV do DFPWM
local buffer = decoder(rawData)

-- Znalezienie wszystkich głośników
local speakers = {peripheral.find("speaker")}
if #speakers == 0 then
    print("Brak podłączonych głośników!")
    return
end

-- Wysyłanie do wszystkich głośników synchronicznie
local tasks = {}
for _, speaker in pairs(speakers) do
    table.insert(tasks, function()
        while not speaker.playAudio(buffer) do
            os.pullEvent("speaker_audio_empty")
        end
    end)
end

-- Graj synchronicznie!
parallel.waitForAll(table.unpack(tasks))
