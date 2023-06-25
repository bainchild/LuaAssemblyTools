local content = ""
local indent = 0
local IBrokeIt = true
local function write(...)
   local s,args = "",{...}
   for i,v in pairs(args) do
      s=s..tostring(v)..(i~=1 and " " or "")
   end
   content=content..(" "):rep(indent)..s.."\n"
end
local function find(a,b)
   for i,v in pairs(a) do if v==b then return i end end
   return nil
end
local serialize
local function serialize_table(n,indent,stack)
   if stack~=nil and find(stack,n)~=nil then return serialize("CYCLIC TABLE",true) end
   if indent==nil then indent=0 end
   local s = "{\n"
   for i,v in pairs(n) do
      local val
      if type(v)=="table" then
         val=serialize_table(v,indent+3,{unpack(stack),n})
      else
         val=serialize(v,true)
      end
      s=s..(" "):rep(indent).."["..serialize(n,true).."] = "..val..";\n"
   end
   s=s.."}"
   return s
end
function serialize(cst,quote)
   local ty = type(cst)
   if ty=="number" or ty=="boolean" or ty=="nil" then
      return tostring(cst)
   elseif ty=="string" then
      if quote then
         return "'"..(cst:gsub("'","\\'")).."'"
      else
         return tostring(cst)
      end
   elseif ty=="table" then
      return serialize_table(cst)
   else
      return tostring(cst)
   end
end
local function decompile(chunk,variable_prefix,func_parent_gv)
   local defined_variables,proto_decompiled = {},{}
   local function get_variable(idx,raw,assign,override,upval)
      if upval and func_parent_gv then return func_parent_gv(idx,raw,assign,override,upval) end
      local variable_prefix=variable_prefix
      if override then variable_prefix=override end
      if raw then
         return variable_prefix.."l"..tostring(idx)
      end
      if defined_variables[idx]==nil then
         defined_variables[idx] = variable_prefix.."l"..tostring(idx)
         if assign then return "local "..defined_variables[idx] end
         write("local "..defined_variables[idx]..";")
      end
      return defined_variables[idx]
   end
   local function get_variable_list(a,b,raw,override,direction,broke_forloop)
      local n = ""
      for i=a,b,(direction or 1) do
         if broke_forloop and i==a and IBrokeIt then i=i-1 end
         n=n..get_variable(i,raw,false,override)..(i~=b and "," or "")
      end
      return n
   end
   local function RK(idx)
      if idx>255 then
         return serialize(chunk.Constants[idx-256].Value,true)
      end
      return get_variable(idx)
   end
   for i=1,chunk.ArgumentCount do
      get_variable(i-1,false,true)
   end
   write("local top_index=0;")
   local jmp_locations = {}
   local i=0
   while true do
      local v = chunk.Instructions[i]
      if v==nil then break end
      if v.Opcode=="CLOSURE" then
         local proto_idx = v.B
         local proto = chunk.Protos[proto_idx]
         local proto_str = variable_prefix.."f"..proto_idx
         if not proto_decompiled[proto_idx] then
            proto_decompiled[proto_idx]=true
            content=content..((" "):rep(indent).."local function "..proto_str.."(")
            content=content..get_variable_list(0,proto.ArgumentCount-1,true,proto_str.."_")
            if proto.Vararg==2 then
               content=content..",..."
            end
            content=content..")\n"
            indent=indent+3
            decompile(proto,proto_str.."_",get_variable)
            indent=indent-3
            write("end")
         end
         write(get_variable(v.A,false,true).."="..variable_prefix.."f"..proto_idx)
         for c=1,proto.UpvalueCount do
            i=i+1
         end
      elseif v.Opcode=="MOVE" then
         local pi = chunk.Instructions[i+1]
         if v.A~=v.B then
            if pi~=nil and pi.Opcode=="MOVE" and pi.A == v.A and pi.A~=pi.B then
               write("--"..get_variable(v.A).."="..get_variable(v.B).."; -- overwritten MOVE")
            else
               write(get_variable(v.A,false,true).."="..get_variable(v.B)..";")
            end
         else
            write("--"..get_variable(v.A).."="..get_variable(v.B).."; -- useless MOVE")
         end
      elseif v.Opcode=="LOADK" then
         write(get_variable(v.A,false,true).."="..serialize(chunk.Constants[v.Bx].Value,true)..";")
      elseif v.Opcode=="LOADNIL" then
         local define = true
         for i=v.A,v.B do
            if defined_variables[i] then
               define=false;break
            end
         end
         local nl = ""
         for i=v.A,v.B do
            nl=nl..(i~=v.A and "," or "").."nil"
         end
         write((define and "local " or "")..get_variable_list(v.A,v.B,true).."="..nl..";")
      elseif v.Opcode=="LOADBOOL" then
         write(get_variable(v.A,false,true).."="..serialize(v.B~=0).."; -- C: "..serialize(v.C))
      elseif v.Opcode=="NEWTABLE" then
         write(get_variable(v.A,false,true).."={};")
      elseif v.Opcode=="SETTABLE" then
         write(get_variable(v.A).."["..RK(v.B).."]".."="..RK(v.C)..";")
      elseif v.Opcode=="GETTABLE" then
         write(get_variable(v.A,false,true).."="..get_variable(v.B).."["..RK(v.C).."];")
      elseif v.Opcode=="SETGLOBAL" then
         write(chunk.Constants[v.Bx].Value.."="..get_variable(v.A));
      elseif v.Opcode=="GETGLOBAL" then
         write(get_variable(v.A,false,true).."="..chunk.Constants[v.Bx].Value..";");
      elseif v.Opcode=="SETUPVAL" then
         if func_parent_gv==nil then
            write("-- (no parent) SETUPVAL "..v.A.." "..v.B)
         else
            write(func_parent_gv(v.A,false,false,nil,true).."="..get_variable(v.B)..";")
         end
      elseif v.Opcode=="GETUPVAL" then
         if func_parent_gv==nil then
            write("-- (no parent) GETUPVAL "..v.A.." "..v.B)
         else
            write(get_variable(v.A,false,true).."="..func_parent_gv(v.B,false,nil,true)..";")
         end
      elseif v.Opcode=="SELF" then
         local a,b = get_variable(v.A),get_variable(v.B)
         write(get_variable(v.A+1)..","..a.."="..a..","..b.."["..RK(v.C).."];")
      elseif v.Opcode=="CALL" then
         if v.C<2 then
            if v.C==0 then
               write("-- this function has C as 0, please correct this after processing")
            end
            if v.B==0 then
               local top = 0
               for i,v in pairs(defined_variables) do
                  if i>top then top=i end
               end
               write(get_variable(v.A).."(unpack({"..get_variable_list(0,top)..(chunk.Vararg==2 and ",..." or "").."},"..serialize(v.A+1)..",top_index));")
            else
               write(get_variable(v.A).."("..get_variable_list(v.A+1,v.A+v.B-1)..");")
            end
         else
            if v.B==0 then
               local top = 0
               for i,v in pairs(defined_variables) do
                  if i>top then top=i end
               end
               write(get_variable_list(v.A,v.A+v.C-2).."="..get_variable(v.A).."(unpack({"..get_variable_list(0,top)..(chunk.Vararg==2 and ",..." or "").."},"..serialize(v.A+1)..",top_index));")
            else
               write(get_variable_list(v.A,v.A+v.C-2).."="..get_variable(v.A).."("..get_variable_list(v.A+1,v.A+v.B-1)..");")
            end
         end
      elseif v.Opcode=="TAILCALL" then
         if v.B==0 then
            local top = 0
            for i,v in pairs(defined_variables) do
               if i>top then top=i end
            end
            write("do return "..get_variable(v.A).."(unpack({"..get_variable_list(0,top)..(chunk.Vararg==2 and ",..." or "").."},"..serialize(v.A+1)..",top_index)); end;")
         else
            write("do return "..get_variable(v.A).."("..get_variable_list(v.A+1,v.A+v.B-1).."); end;")
         end
      elseif v.Opcode=="RETURN" and not IBrokeIt then
         if v.B==0 then
            local top = 0
            for i,v in pairs(defined_variables) do
               if i>top then top=i end
            end
            write("do return unpack({"..get_variable_list(v.A,top)..(chunk.Vararg==2 and ",..." or "").."},0,top_index) end;")
         elseif v.B~=1 then
            write("do return "..get_variable_list(v.A,v.A+v.B-2).." end;")
         else
            write("do return end;")
         end
      elseif v.Opcode=="SETLIST" then
         if v.B==0 then
            write("-- this is supposed to have assignments up to top_index")
            write("-- but top_index is a runtime thing, so please fix this")
         end
         if v.C==0 then
            write("-- TODO: make SETLIST.C==0 work")
         end
         local A = get_variable(v.A)
         local n = ""
         for i=1,v.B do
            n=n..A.."["..((v.C-1)*50+i).."],"
         end
         n=n:sub(1,-2)
         n=n.."="..get_variable_list(v.A+1,v.A+v.B)..";"
         write(n)
      elseif v.Opcode=="CONCAT" then
         local n = get_variable(v.A,false,true).."="
         for i=v.B,v.C do
            n=n..get_variable(i)..(i~=v.C and ".." or "")
         end
         n=n..";"
         write(n)
      elseif v.Opcode=="ADD" or v.Opcode=="SUB" or v.Opcode=="MUL" or v.Opcode=="DIV" or v.Opcode=="MOD" or v.Opcode=="POW" then
         local op
         if v.Opcode=="ADD" then
            op="+"
         elseif v.Opcode=="SUB" then
            op="-"
         elseif v.Opcode=="MUL" then
            op="*"
         elseif v.Opcode=="DIV" then
            op="/"
         elseif v.Opcode=="MOD" then
            op="%"
         elseif v.Opcode=="POW" then
            op="^"
         end
         write(get_variable(v.A,false,true).."="..RK(v.B)..op..RK(v.C)..";")
      elseif v.Opcode=="UNM" then
         write(get_variable(v.A,false,true).."=-"..get_variable(v.B)..";")
      elseif v.Opcode=="NOT" then
         write(get_variable(v.A,false,true).."=not "..get_variable(v.B)..";")
      elseif v.Opcode=="LEN" then
         write(get_variable(v.A,false,true).."=#"..get_variable(v.B)..";")
      elseif v.Opcode=="EQ" or v.Opcode=="LT" or v.Opcode=="LE" then
         local op
         if v.A==0 then
            if v.Opcode=="EQ" then
               op="=="
            elseif v.Opcode=="LT" then
               op="<"
            elseif v.Opcode=="LE" then
               op="<="
            end
         else
            if v.Opcode=="EQ" then
               op="~="
            elseif v.Opcode=="LT" then
               op=">"
            elseif v.Opcode=="LE" then
               op=">="
            end
         end
         write("-- if "..RK(v.B)..op..RK(v.C).." then")
      elseif v.Opcode=="FORPREP" then
         write("-- for "..get_variable(v.A+3).."="..get_variable_list(v.A,v.A+2).." do")
      elseif v.Opcode=="FORLOOP" then
         write("-- end; -- FORLOOP")
      elseif v.Opcode=="JMP" then
         jmp_locations[i+v.sBx] = true
         local previous = chunk.Instructions[i-1]
         local future = chunk.Instructions[i+v.sBx+1]
         if future then
            if future.Opcode=="TFORLOOP" and ((previous and previous.Opcode~="EQ" and previous.Opcode~="LT" and previous.Opcode~="LE" and previous.Opcode~="LOADBOOL" and previous.Opcode~="TESTSET" and previous.Opcode~="TEST") or previous==nil) then
               write("-- for "..get_variable_list(v.A+3+(IBrokeIt and 3 or 0),v.A+3+(IBrokeIt and 3 or 0)+v.C+1,false,nil,1,true).." in "..get_variable(v.A+(IBrokeIt and 2 or 0))..","..get_variable(v.A+(IBrokeIt and 2 or 0)+1).." do")
               jmp_locations[i+v.sBx] = true
            end
         end
         write("-- JMP "..v.A.." "..v.sBx)
      else
         if v.OpcodeType=="ABC" then
            write("-- "..tostring(v.Opcode).." "..tostring(v.A).." "..tostring(v.B).." "..tostring(v.C))
         elseif v.OpcodeType=="ABx" then
            write("-- "..tostring(v.Opcode).." "..tostring(v.A).." "..tostring(v.Bx))
         elseif v.OpcodeType=="AsBx" then
            write("-- "..tostring(v.Opcode).." "..tostring(v.A).." "..tostring(v.sBx))
         else
            write("-- "..tostring(v.Opcode).." type: ???")
         end
      end
      if jmp_locations[i] then
         write("-- else/elseif/end")
      end
      i=i+1
   end
end
return function(file)
   decompile(file.Main,"")
   return content
end
