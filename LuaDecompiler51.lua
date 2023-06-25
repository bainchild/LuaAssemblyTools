require("LAT")
local args = {...}
local i,raw,recog=1,false,false
while true do
  local v = args[i]
  if v==nil then break end
  if v=="-j" then recog=true;table.remove(args,i);i=i-1 end
  if v=="-r" then raw=true;table.remove(args,i);i=i-1 end
  i=i+1
end
local content
if args[1]=="-" then
  content=io.stdin:read("*a")
else
  content=assert(io.open(args[1],"rb")):read("*a")
end
local file
if content:sub(1,4)=="\27Lua" then
  file=LAT.Lua51.Disassemble(content)
else
  local parser = LAT.Lua51.Parser:new()
  file=parser:Parse(content,"file")
end
print("-- Decompiled to lua by LuaAssemblyTools.")
print(LAT.Lua51.Decompile.Lua(file,raw,recog))