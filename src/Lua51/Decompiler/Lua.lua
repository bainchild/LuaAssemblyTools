local content = ""
local indent = 0
local indent_level = 3
local IBrokeIt = false--true
local jmp_recog = false
local one_to_one = false
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
      cst=(cst:gsub("[^\32-\126]",function(a)
         if a=="\a" then return "\\f"
         elseif a=="\b" then return "\\b"
         elseif a=="\n" then return "\\n"
         elseif a=="\r" then return "\\r"
         elseif a=="\t" then return "\\t"
         elseif a=="\v" then return "\\v" end
         return "\\"..a:byte()
      end))
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
local function get_cmp_operation(v)
   local op;
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
   return op
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
   write("local top_index=0; -- TODO")
   local chunk_isvararg = (IBrokeIt and chunk.Vararg==2) or (not IBrokeIt and chunk.Vararg==3)
   local jmp_locations,last_if = {},0
   local i=0
   local function gettable_continuation(A)
      if one_to_one then content=content..";\n" return end
      local cur = i+1
      while true do
         local inst = chunk.Instructions[cur]
         -- print(cur,inst.Opcode,inst.A,inst.B,v.A,v.B)
         if inst==nil or (inst.Opcode~="GETTABLE") then break end
         if inst.Opcode=="GETTABLE" and (inst.A~=A or inst.B~=A) then break end
         content=content.."["..RK(inst.C).."]"
         i=cur
         cur=cur+1
      end
      content=content..";\n"
   end
   local function newtable_continuation(A)
      if one_to_one then content=content.."{};\n" return end
      content=content.."{\n"
      local start = i+1;
      local cur = i+1
      while true do
         local inst = chunk.Instructions[cur]
         if inst==nil or (inst.Opcode~="SETTABLE") then break end
         if inst.Opcode=="SETTABLE" and inst.A~=A then break end
         content=content..(" "):rep(indent+indent_level).."["..RK(inst.B).."]="..RK(inst.C)..";\n"
         i=cur
         cur=cur+1
      end
      if cur==start then content=content:sub(1,-3).."{};\n"; return end
      content=content..(" "):rep(indent).."};\n"
   end
   while true do
      local v = chunk.Instructions[i]
      if v==nil then break end
      if v.Opcode=="CLOSURE" then
         local proto_idx = (IBrokeIt and v.B) or (not IBrokeIt and v.Bx)
         local proto = chunk.Protos[proto_idx]
         local proto_str = variable_prefix.."f"..proto_idx
         if not proto_decompiled[proto] then
            proto_decompiled[proto]=true
            content=content..((" "):rep(indent).."local function "..proto_str.."(")
            content=content..get_variable_list(0,proto.ArgumentCount-1,true,proto_str.."_")
            if (IBrokeIt and proto.Vararg==2) or (not IBrokeIt and proto.Vararg==3) then
               content=content..",..."
            end
            content=content..")\n"
            indent=indent+indent_level
            decompile(proto,proto_str.."_",get_variable)
            indent=indent-indent_level
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
         if jmp_recog and v.C==1 then jmp_locations[i+1]="loadbool" end
      elseif v.Opcode=="NEWTABLE" then
         content=content..(" "):rep(indent)..(get_variable(v.A,false,true).."=")
         newtable_continuation(v.A)
      elseif v.Opcode=="SETTABLE" then
         write(get_variable(v.A).."["..RK(v.B).."]".."="..RK(v.C)..";")
      elseif v.Opcode=="GETTABLE" then
         content=content..(" "):rep(indent)..(get_variable(v.A,false,true).."="..get_variable(v.B).."["..RK(v.C).."]")
         gettable_continuation(v.A)
      elseif v.Opcode=="SETGLOBAL" then
         write(chunk.Constants[v.Bx].Value.."="..get_variable(v.A));
      elseif v.Opcode=="GETGLOBAL" then
         content=content..(" "):rep(indent)..get_variable(v.A,false,true).."="..chunk.Constants[v.Bx].Value
         gettable_continuation(v.A)
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
            content=content..(" "):rep(indent)..(get_variable(v.A,false,true).."="..func_parent_gv(v.B,false,nil,true))
            gettable_continuation(v.A)
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
               write(get_variable(v.A).."(unpack({"..get_variable_list(v.A+1,top)..(chunk_isvararg and ",..." or "").."},"..serialize(v.A+1)..",top_index));")
            else
               write(get_variable(v.A).."("..get_variable_list(v.A+1,v.A+v.B-1)..");")
            end
         else
            if v.B==0 then
               local top = 0
               for i,v in pairs(defined_variables) do
                  if i>top then top=i end
               end
               write(get_variable_list(v.A,v.A+v.C-2).."="..get_variable(v.A).."(unpack({"..get_variable_list(v.A+1,top)..(chunk_isvararg and ",..." or "").."},"..serialize(v.A+1)..",top_index));")
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
            write("do return "..get_variable(v.A).."(unpack({"..get_variable_list(v.A+1,top)..(chunk_isvararg and ",..." or "").."},"..serialize(v.A+1)..",top_index)); end;")
         else
            write("do return "..get_variable(v.A).."("..get_variable_list(v.A+1,v.A+v.B-1).."); end;")
         end
      elseif v.Opcode=="RETURN" and not IBrokeIt then
         if v.B==0 then
            local top = 0
            for i,v in pairs(defined_variables) do
               if i>top then top=i end
            end
            write("do return unpack({"..get_variable_list(v.A+1,top)..(chunk_isvararg and ",..." or "").."},0,top_index) end;")
         elseif v.B~=1 then
            write("do return "..get_variable_list(v.A,v.A+v.B-2).." end;")
         else
            write("do return end;")
         end
      elseif v.Opcode=="VARARG" then
         if v.B==0 then
            write("-- VARARG: B is 0, please modify to accept any number of values")
            write("-- A: "..v.A)
         else
            write(get_variable_list(v.A,v.A+v.B-2).."=...;")
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
         local op = get_cmp_operation(v);
         if jmp_recog then
            if jmp_locations[i]==nil then
               write("if "..RK(v.B)..op..RK(v.C).." then")
               last_if=i
               indent=indent+indent_level
            end
         else
            write("-- if "..RK(v.B)..op..RK(v.C).." then")
         end
      elseif jmp_recog and v.Opcode=="TEST" then
         content=content..(" "):rep(indent)
         if not jmp_recog then content=content.."-- " else indent=indent+indent_level end
         content=content..("if "..(v.C==1 and "not " or "")..get_variable(v.A).." then\n")
         last_if=i
      elseif jmp_recog and v.Opcode=="TESTSET" then
         content=content..(" "):rep(indent)
         if not jmp_recog then content=content.."-- " else indent=indent+indent_level end
         content=content..("if "..(v.C==0 and "not " or "")..get_variable(v.B).." then "..get_variable(v.A).."="..get_variable(v.B).."\n")
         if jmp_recog then jmp_locations[i+2]="testset" end
         last_if=i
      elseif v.Opcode=="FORPREP" then
         content=content..(" "):rep(indent)
         if not jmp_recog then content=content.."-- " else indent=indent+indent_level end
         content=content.."for "..get_variable(v.A+3).."="..get_variable_list(v.A,v.A+2).." do\n"
      elseif v.Opcode=="FORLOOP" then
         content=content..(" "):rep(indent)
         if not jmp_recog then content=content.."-- " else indent=indent-indent_level end
         content=content..("end; -- FORLOOP\n")
      elseif v.Opcode=="JMP" then
         local previous = chunk.Instructions[i-1]
         if previous.Opcode ~= "TESTSET" and v.sBx~=0 then
            jmp_locations[i+v.sBx] = true
         end
         local future = chunk.Instructions[i+v.sBx+1]
         if future then
            if future.Opcode=="TFORLOOP" and ((previous and previous.Opcode~="EQ" and previous.Opcode~="LT" and previous.Opcode~="LE" and previous.Opcode~="LOADBOOL" and previous.Opcode~="TESTSET" and previous.Opcode~="TEST") or previous==nil) then
               content=content..(" "):rep(indent)
               if not jmp_recog then content=content.."-- " end
               content=content..("for "..get_variable_list(v.A+3+(IBrokeIt and 3 or 0),v.A+3+(IBrokeIt and 3 or 0)+v.C+1,false,nil,1,true).." in "..get_variable(v.A+(IBrokeIt and 2 or 0))..","..get_variable(v.A+(IBrokeIt and 2 or 0)+1).." do\n")
               jmp_locations[i+v.sBx] = "tforloop"
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
         if jmp_recog then
            local written_else = false
            if v.Opcode=="JMP" and v.sBx~=0 then
               local after = chunk.Instructions[i+1]
               if after.Opcode=="EQ" or after.Opcode=="LT" or after.Opcode=="LE" or after.Opcode=="TESTSET" or after.Opcode=="TEST" then
                  v=after
                  i=i+1
               else
                  indent=indent-indent_level
                  write("else --?")
                  indent=indent+indent_level
                  written_else=true
               end
            end
            if v.Opcode=="LOADBOOL" and v.C==1 then
               indent=indent-indent_level
               write("else")
               indent=indent+indent_level
            elseif v.Opcode=="EQ" or v.Opcode=="LT" or v.Opcode=="LE" then
               indent=indent-indent_level
               write("elseif "..RK(v.B)..get_cmp_operation(v)..RK(v.C).." then --?")
               indent=indent+indent_level
            elseif v.Opcode=="TEST" then
               indent=indent-indent_level
               write("elseif "..(v.C==1 and "not " or "")..get_variable(v.A).." then")
               indent=indent+indent_level
            elseif v.Opcode=="TESTSET" then
               indent=indent-indent_level
               write("elseif "..(v.C==0 and "not " or "")..get_variable(v.B).." then "..get_variable(v.A).."="..get_variable(v.B))
               indent=indent+indent_level
               jmp_locations[i+1]="TESTSET"
            elseif not written_else then
               indent=indent-indent_level
               write("end; --?")
            end
            for a=1,chunk.Instructions.Count do
               local nst = chunk.Instructions[a-1]
               if nst.Opcode=="JMP" then
                  local dest = (a-1)+nst.sBx
                  if dest>last_if and dest<=i and nst.sBx>1 and i-dest>0 then
                     write("-- TODO: copy from last_if to "..i-dest.." instruction(s) behind here")
                     write("-- to fix edge case(?) if statements. TEMP fix is to decrement")
                     write("-- indentation and add an 'end' here. Won't work correctly, though.")
                     indent=indent-indent_level
                     write("end;")
                  end
               end
            end
         else
            write("-- else/elseif/end")
         end
      end
      i=i+1
   end
end
local function split(a,b)
   local mat = {}
   for _,v in (a..b):gmatch("(.-)"..b) do
      table.insert(mat,v)
   end
   return mat
end
local function post_optimize(cont)
   if true then return cont end
   -- TODO: if variable is from a function call that isn't a function _we_
   -- defined, then cancel variable inlining
   -- TODO: variable tracing...
   local lines = split(cont,"\n")
   -- is variable assigned before being used after line
   local function ivabbual(variable,line)
      while true do
         line=line+1
         if lines[line]==nil then return false end
         local a,b = lines[line]:match("(.*)=(.*);");
         if a==variable or a:find(variable) then
            return false
         elseif b==variable or b:find(variable) then
            return true
         end
      end
   end
   local function get_val_at_line(variable,line)
      
   end
   cont=(cont:gsub("^(.*)(%(.*%);)$",function(assignfname,params)
      local spl = split(assignfname,"=")
      local fname = fname[#fname]
      local line_number = find(lines,assignfname..params)
      if not ivabbual(fname,line_number) then
         return (#spl==2 and spl[1] or "")..get_val_at_line(fname,line_number)..params
      end
   end))
   return cont
end
return function(file,raw,recog)
   jmp_recog = recog
   one_to_one = raw
   decompile(file.Main,"")
   if not one_to_one then
      content=post_optimize(content)
   end
   return content
end
