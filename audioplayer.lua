local url = "ttps://remote.craftos-pc.cc/music/content/s88IU8_Y.wav"
local request = http.get(url, nil, true)

if not request then
    print("Błąd połączenia!")
    return
end

local tmpFile = "tmp_downloaded.wav"
local f = fs.open(tmpFile, "wb")

while true do
    local chunk = request.read(4 * 1024)
    if not chunk then break end
    f.write(chunk)
end

f.close()
request.close()
