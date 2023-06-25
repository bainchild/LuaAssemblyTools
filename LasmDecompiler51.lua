require'LAT'

if #arg == 0 then
    error("No input file specified!")
end
file = LAT.Lua51.Disassemble((arg[1]=="-" and io.stdin or assert(io.open(arg[1], "rb"))):read"*a")
print("; Decompiled to lasm by LASM Decompiler v1.0")
print""
print(LAT.Lua51.Decompile.LASM(file))
