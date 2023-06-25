require("LAT")
local content
if (...)=="-" then
  content=io.stdin:read("*a")
else
  content=assert(io.open((...),"rb")):read("*a")
end
local file
if content:sub(1,4)=="\27Lua" then
  file=LAT.Lua51.Disassemble(content)
else
  local parser = LAT.Lua51.Parser:new()
  file=parser:Parse(content,"file")
end
print("-- Decompiled to lua by LuaAssemblyTools.")
print(LAT.Lua51.Decompile.Lua(file))