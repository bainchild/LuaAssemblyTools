return {  
    ["x86-s"] = {    
        Description = "x86 Standard (32-bit, little endian, double)",    
        BigEndian = false,             -- 1 = little endian    
        IntegerSize = 4,                -- (data type sizes in bytes)    
        SizeT = 4,    
        InstructionSize = 4,    
        NumberSize = 8,                 -- this & integral identifies the    
        IsFloatingPoint = true,        -- (0) type of lua_Number    
        NumberType = "double",         -- used for lookups  
    },  
    ["x64-be-i"] = {    
        Description = "(32-bit, big endian, int)",    
        BigEndian = true,
        IntegerSize = 4,
        SizeT = 4,
        InstructionSize = 4,
        NumberSize = 4,
        IsFloatingPoint = false,
        NumberType = "int",  
    },  
    ["amd64"] = {    
        Description = "AMD64 (64-bit, little endian, double)",    
        BigEndian = false, 
        IntegerSize = 4,    
        SizeT = 8,    
        InstructionSize = 4,    
        NumberSize = 8,    
        IsFloatingPoint = true,
        NumberType = "double",  
    },  
    -- you can add more platforms here
}
