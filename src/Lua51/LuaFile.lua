local Chunk = LAT.Lua51.Chunk
local DumpBinary = LAT.Lua51.DumpBinary
local PlatformTypes = LAT.Lua51.PlatformTypes
local running_standard = PlatformTypes["x86-s"]
local tried_dump = false

local LuaFile = {
    -- Default to x86 standard
    new = function(self,standard)
        if not tried_dump then
            tried_dump=true
            if ('').dump then
                local n = {}
                for i,v in pairs(LAT.Lua51.Disassemble(('').dump(function()end))) do
                    if i=="Identifier" or i=="Version" or i=="Format" or i=="BigEndian"
                    or i=="IntegerSize" or i=="SizeT" or i=="InstructionSize" or i=="NumberSize" or i=="IsFloatingPoint" then
                        n[i]=v
                    end
                end
                running_standard=n
            end           
        end
        if standard==nil then standard = running_standard end
        return setmetatable({
            Identifier = "\027Lua",
            Version = 0x51,
            Format = "Official",
            BigEndian = false,
            IntegerSize = 4,
            SizeT = 4,
            InstructionSize = 4,
            NumberSize = 8,
            IsFloatingPoint = true,
            Main = Chunk:new(),
        }, { __index = self }):ChangePlatform(standard)
    end,

    ChangePlatform = function(self,platform)
        if type(platform)=="table" then return self:ApplyProfile(platform) end
        assert(PlatformTypes[platform]~=nil,"Unknown platform '"..platform.."'")
        return self:ApplyProfile(PlatformTypes[platform])
    end,

    ApplyProfile = function(self,profile)
        for i,v in pairs(profile) do
            if i~="Main" and self[i]~=nil then
                self[i]=v
            end
        end
        return self
    end,
    
    Compile = function(self, verify)
        local c = ""
        c = c .. self.Identifier
        c = c .. DumpBinary.Int8(self.Version) -- Should be 0x51 (Q)
        c = c .. DumpBinary.Int8(self.Format == "Official" and 0 or 1)
        c = c .. DumpBinary.Int8(self.BigEndian and 0 or 1)
        c = c .. DumpBinary.Int8(self.IntegerSize)
        c = c .. DumpBinary.Int8(self.SizeT)
        c = c .. DumpBinary.Int8(self.InstructionSize)
        c = c .. DumpBinary.Int8(self.NumberSize)
        c = c .. DumpBinary.Int8(self.IsFloatingPoint and 0 or 1)
        -- Main function
        c = c .. self.Main:Compile(self, verify)
        return c
    end,
    
    CompileToFunction = function(self)
        return loadstring(self:Compile())
    end,
    
    StripDebugInfo = function(self)
        self.Main:StripDebugInfo()
    end,
    
    Verify = function(self)
        self.Main:Verify()
    end
}

return LuaFile
