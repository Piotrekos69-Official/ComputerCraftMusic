-- Audioplayer by GroupXyz v2.1
local iface="sounds/"
if not fs.exists(iface) then fs.makeDir(iface) end
local function lf(p)local l={}for _,f in ipairs(fs.list(p))do if not fs.isDir(p.."/"..f)then l[#l+1]=f end end return l end
local function disp(l,s,e) term.clear() term.setCursorPos(1,1) for i=s,e do if l[i]then print(i..": "..l[i]) end end end
local function play(p,file,lp)
  local path=p.."/"..file
  if not fs.exists(path) or fs.isDir(path)then print("File not found.")return end
  local sp=peripheral.find("speaker")
  if not sp then print("Speaker not found.")return end
  local d=require("cc.audio.dfpwm").make_decoder()
  local function pb(b) while not sp.playAudio(b)do os.pullEvent("speaker_audio_empty") end end
  if lp then while true do for c in io.lines(path,16*1024) do pb(d(c)) sleep(0.05) end end
  else for c in io.lines(path,16*1024) do pb(d(c)) sleep(0.05) end end
  print("Playback finished.")
end
local queue={}
local function addQ(f)table.insert(queue,f) print(f.." added to queue.")end
local function playQ() while #queue>0 do play(iface,table.remove(queue,1),false) end end
local function skip() if #queue>0 then table.remove(queue,1); print("Skipped.") else print("Queue empty.") end end
local files=lf(iface) local s=1 local e=math.min(10,#files)
while true do
  disp(files,s,e)
  local c=read()
  if c=="0" then break
  elseif c=="repeat" then print("Repeat file number:") local num=tonumber(read()); if files[num]then play(iface,files[num],true)else print("Invalid.") end
  elseif c=="queue" then print("Queue file number:") local num=tonumber(read()); if files[num]then addQ(files[num])else print("Invalid.") end
  elseif c=="playqueue" then playQ()
  elseif c=="skip" then skip()
  elseif c=="w" and s>1 then s=s-10; e=e-10
  elseif c=="s" and e<#files then s=s+10; e=e+10
  elseif tonumber(c) and files[tonumber(c)] then play(iface,files[tonumber(c)],false)
  else print("Invalid selection.") end
end
