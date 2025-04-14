local dfpwm = require("cc.audio.dfpwm")
local decoder = dfpwm.make_decoder()
local speaker = peripheral.find("speaker")

-- Tu podaj adres WAV z internetu
local wavUrl = "https://raw.githubusercontent.com/Piotrekos69-Official/ComputerCraftMusic/main/Toby-Fox-Megalovania%20(1).wav"

-- Pobierz dane strumieniowo z internetu
local request = http.get(wavUrl, nil, true)
if not request then
    print("Błąd: Nie można połączyć się z URL")
    return
end

while true do
    local chunk = request.read(16 * 1024)
    if not chunk then break end

    local buffer = decoder(chunk)
    while not speaker.playAudio(buffer) do
        os.pullEvent("speaker_audio_empty")
    end
end

request.close()
