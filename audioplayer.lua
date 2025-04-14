local dfpwm = require("cc.audio.dfpwm")
local decoder = dfpwm.make_decoder()
local speakers = {peripheral.find("speaker")}

local url = "https://remote.craftos-pc.cc/music/content/mJjKg4p0.wav"
local handle = http.get(url, nil, true)
if not handle then
    print("Nie udało się połączyć z URL!")
    return
end

while true do
    local chunk = handle.read(4 * 1024) -- zmniejszony rozmiar
    if not chunk then break end

    local buffer = decoder(chunk)

    local play_tasks = {}
    for _, speaker in pairs(speakers) do
        table.insert(play_tasks, function()
            while not speaker.playAudio(buffer) do
                os.pullEvent("speaker_audio_empty")
            end
        end)
    end

    parallel.waitForAll(table.unpack(play_tasks))
end

handle.close()
