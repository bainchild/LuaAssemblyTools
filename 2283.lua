-- Decompiled to lua by LuaAssemblyTools.
local top_index=0;
local function f0()
   local top_index=0;
   local function f0_f0(f0_f0_l0,f0_f0_l1)
      local top_index=0;
      local f0_f0_l2=pairs;
      local f0_f0_l3=f0_f0_l0;
      local f0_f0_l4;
      f0_f0_l2,f0_f0_l3,f0_f0_l4=f0_f0_l2(f0_f0_l3);
      local f0_f0_l5;
      local f0_f0_l7;
      -- for f0_f0_l5,f0_f0_l7 in f0_f0_l2,f0_f0_l3 do
      -- JMP 0 10
      local f0_f0_l6;
      f0_f0_l7=f0_f0_l6['index'];
      -- if f0_f0_l1<=f0_f0_l7 then
      -- JMP 0 7
      f0_f0_l7=f0_f0_l6['store'];
      local f0_f0_l8=f0_f0_l6['index'];
      f0_f0_l7=f0_f0_l7[f0_f0_l8];
      f0_f0_l6['value']=f0_f0_l7;
      f0_f0_l6['store']=f0_f0_l6;
      f0_f0_l6['index']='value';
      f0_f0_l0[f0_f0_l5]=nil;
      -- else/elseif/end
      -- TFORLOOP 2 2 0
      -- JMP 0 -12
      -- RETURN 0 0 0
   end
   local f0_l1=f0_f0
   local f0_l2=f0_f0
   local f0_l3=f0_f0
   local f0_l4=f0_f0
   local f0_l0;
   --f0_l0=f0_l1; -- overwritten MOVE
   --f0_l0=f0_l3; -- overwritten MOVE
   f0_l0=f0_l2;
   --f0_l0=f0_l0; -- useless MOVE
   local f0_l5=nil;
   local f0_l6={};
   local f0_l11;
   local f0_l8;
   local f0_l9;
   local f0_l10;
   -- for f0_l11=f0_l8,f0_l9,f0_l10 do
   -- if f0_l11~=34 then
   -- JMP 0 10
   -- if f0_l11~=92 then
   -- JMP 0 8
   local f0_l12=string;
   f0_l12=f0_l12['char'];
   local f0_l13=f0_l11;
   f0_l12=f0_l12(f0_l13);
   local f0_l7;
   f0_l13=f0_l7;
   f0_l6[f0_l7]=f0_l12;
   f0_l6[f0_l12]=f0_l13;
   f0_l7=f0_l7+1;
   -- else/elseif/end
   -- end -- FORLOOP
   f0_l8={};
   -- for f0_l12=f0_l9,f0_l10,f0_l11 do
   f0_l13={};
   local f0_l14;
   local f0_l15;
   local f0_l16;
   f0_l13[1],f0_l13[2],f0_l13[3]=f0_l14,f0_l15,f0_l16;
   f0_l14=f0_l12-31;
   f0_l13=f0_l13[f0_l14];
   -- TESTSET 12 13 1
   -- JMP 0 0
   -- else/elseif/end
   f0_l13=string;
   f0_l13=f0_l13['char'];
   f0_l14=f0_l12;
   f0_l13=f0_l13(f0_l14);
   f0_l14=string;
   f0_l14=f0_l14['char'];
   f0_l15=f0_l12+31;
   f0_l14=f0_l14(f0_l15);
   f0_l15=f0_l14;
   f0_l8[f0_l14]=f0_l13;
   f0_l8[f0_l13]=f0_l15;
   -- end -- FORLOOP
   f0_l9=f0_f0
   f0_l0=f0_l8;
   f0_l10=f0_f0
   f0_l0=f0_l8;
   f0_l11=f0_f0
   f0_l12=f0_f0
   f0_l0=f0_l6;
   f0_l13=f0_f0
   f0_l0=f0_l6;
   local f0_l5=f0_f0
   --f0_l0=f0_l11; -- overwritten MOVE
   --f0_l0=f0_l6; -- overwritten MOVE
   --f0_l0=f0_l13; -- overwritten MOVE
   f0_l0=f0_l10;
   -- CLOSE 6 0 0
   f0_l6=f0_l5;
   f0_l6=f0_l6(f0_l7);
   f0_l7,f0_l6=f0_l6,f0_l6['gsub'];
   f0_l9=f0_f0
   f0_l6=f0_l6(f0_l7,f0_l8,f0_l9);
   f0_l7=f0_f0
   f0_l0=f0_l6;
   f0_l0=f0_f0
   --f0_l0=f0_l5; -- overwritten MOVE
   --f0_l0=f0_l3; -- overwritten MOVE
   f0_l0=f0_l4;
   f0_l8=f0_l0;
   f0_l9={};
   f0_l12={};
   f0_l13={};
   f0_l16={};
   local f0_l18={};
   f0_l18['a']=33;
   local f0_l19=f0_l7;
   local f0_l20;
   local f0_l21;
   f0_l19=f0_l19(f0_l20,f0_l21);
   f0_l18['c']=f0_l19;
   f0_l18['b']=260;
   f0_l19=f0_l7;
   f0_l19=f0_l19(f0_l20,f0_l21);
   f0_l18['e']=f0_l19;
   f0_l18['d']=21;
   f0_l18['g']=12;
   f0_l18['f']=262;
   f0_l18['i']=11;
   f0_l18['h']=15;
   f0_l18['k']=16;
   f0_l18['j']=13;
   f0_l19=f0_l7;
   f0_l19=f0_l19(f0_l20,f0_l21);
   f0_l18['m']=f0_l19;
   f0_l18['l']=26;
   f0_l18['o']=27;
   f0_l19=f0_l7;
   f0_l19=f0_l19(f0_l20,f0_l21);
   f0_l18['n']=f0_l19;
   f0_l18['q']=36;
   f0_l18['p']=264;
   f0_l18['s']=265;
   f0_l18['r']=32;
   f0_l18['u']=18;
   f0_l18['t']=17;
   f0_l18['w']=266;
   f0_l19=f0_l7;
   f0_l19=f0_l19(f0_l20,f0_l21);
   f0_l18['v']=f0_l19;
   f0_l19=f0_l7;
   f0_l19=f0_l19(f0_l20,f0_l21);
   f0_l18['y']=f0_l19;
   f0_l18['x']=-31;
   f0_l19=f0_l7;
   f0_l19=f0_l19(f0_l20,f0_l21);
   f0_l18['z']=f0_l19;
   f0_l18['E']=22;
   f0_l18['D']=3;
   f0_l18['G']=1;
   f0_l18['F']=9;
   f0_l18['I']=0;
   f0_l18['H']=8;
   f0_l18['K']=34;
   f0_l18['J']=6;
   f0_l18['M']=true;
   f0_l18['L']=10;
   f0_l19=f0_l7;
   f0_l19=f0_l19(f0_l20,f0_l21);
   f0_l18['O']=f0_l19;
   f0_l18['N']=256;
   f0_l18['Q']=2;
   f0_l18['P']=31;
   f0_l18['S']=14;
   f0_l18['R']=257;
   f0_l18['U']=7;
   f0_l18['T']=4;
   f0_l19=f0_l7;
   f0_l19=f0_l19(f0_l20,f0_l21);
   f0_l18['W']=f0_l19;
   f0_l18['V']=5;
   f0_l18['Y']=30;
   f0_l18['X']=259;
   f0_l18['Z']=258;
   local f0_l17;
   f0_l13[1],f0_l13[2],f0_l13[3],f0_l13[4],f0_l13[5]=f0_l14,f0_l15,f0_l16,f0_l17,f0_l18;
   f0_l12[1]=f0_l13;
   f0_l14={};
   f0_l14['a']=33;
   f0_l15=f0_l7;
   f0_l15=f0_l15(f0_l16,f0_l17);
   f0_l14['c']=f0_l15;
   f0_l14['b']=260;
   f0_l15=f0_l7;
   f0_l15=f0_l15(f0_l16,f0_l17);
   f0_l14['e']=f0_l15;
   f0_l14['d']=21;
   f0_l14['g']=12;
   f0_l14['f']=262;
   f0_l14['i']=11;
   f0_l14['h']=15;
   f0_l14['k']=16;
   f0_l14['j']=13;
   f0_l15=f0_l7;
   f0_l15=f0_l15(f0_l16,f0_l17);
   f0_l14['m']=f0_l15;
   f0_l14['l']=26;
   f0_l14['o']=27;
   f0_l15=f0_l7;
   f0_l15=f0_l15(f0_l16,f0_l17);
   f0_l14['n']=f0_l15;
   f0_l14['q']=36;
   f0_l14['p']=264;
   f0_l14['s']=265;
   f0_l14['r']=32;
   f0_l14['u']=18;
   f0_l14['t']=17;
   f0_l14['w']=266;
   f0_l15=f0_l7;
   f0_l15=f0_l15(f0_l16,f0_l17);
   f0_l14['v']=f0_l15;
   f0_l15=f0_l7;
   f0_l15=f0_l15(f0_l16,f0_l17);
   f0_l14['y']=f0_l15;
   f0_l14['x']=-31;
   f0_l15=f0_l7;
   f0_l15=f0_l15(f0_l16,f0_l17);
   f0_l14['z']=f0_l15;
   f0_l14['E']=22;
   f0_l14['D']=3;
   f0_l14['G']=1;
   f0_l14['F']=9;
   f0_l14['I']=0;
   f0_l14['H']=8;
   f0_l14['K']=34;
   f0_l14['J']=6;
   f0_l14['M']=true;
   f0_l14['L']=10;
   f0_l15=f0_l7;
   f0_l15=f0_l15(f0_l16,f0_l17);
   f0_l14['O']=f0_l15;
   f0_l14['N']=256;
   f0_l14['Q']=2;
   f0_l14['P']=31;
   f0_l14['S']=14;
   f0_l14['R']=257;
   f0_l14['U']=7;
   f0_l14['T']=4;
   f0_l15=f0_l7;
   f0_l15=f0_l15(f0_l16,f0_l17);
   f0_l14['W']=f0_l15;
   f0_l14['V']=5;
   f0_l14['Y']=30;
   f0_l14['X']=259;
   f0_l14['Z']=258;
   f0_l9[1],f0_l9[2],f0_l9[3],f0_l9[4],f0_l9[5]=f0_l10,f0_l11,f0_l12,f0_l13,f0_l14;
   f0_l10=getfenv;
   -- this function has C as 0, please correct this after processing
   f0_l10();
   f0_l8=f0_l8(unpack({f0_l0,f0_l1,f0_l2,f0_l3,f0_l4,f0_l5,f0_l6,f0_l7,f0_l8,f0_l9,f0_l10,f0_l11,f0_l12,f0_l13,f0_l14,f0_l15,f0_l16,f0_l17,f0_l18,f0_l19,f0_l20,f0_l21},9,top_index));
   do return f0_l8(); end;
   -- RETURN 8 0 0
   -- RETURN 0 0 0
end
local l0=f0
l0();
local l1=f0
local l2=f0
local l3=pcall;
local l4=f0
l0=l1;
local l5=f0
--l0=l3; -- overwritten MOVE
--l0=l4; -- overwritten MOVE
l0=l2;
local l6=getfenv;
local l7=string;
local l8=math;
local l9=pcall;
local l10={};
local l11=math;
l11=l11['floor'];
local l12;
l11=l11(l12);
l12=tostring;
local l13=tonumber;
local l15=newproxy;
local l16=getmetatable;
local l17=game;
local l18=setmetatable;
local l19=setfenv;
local l20,l21,l22,l23,l24,l25=nil,nil,nil,nil,nil,nil;
local l26=string;
l26=l26['sub'];
local l27=debug;
l27=l27['info'];
local l28=typeof;
local l29=task;
l29=l29['spawn'];
local l30=pcall;
local l31=require;
local l32=l11;
l29(l30,l31,l32);
l29=task;
l29=l29['spawn'];
l30=pcall;
l31=require;
l29(l30,l31,l32);
l29=l9;
l30=f0
--l0=l19; -- overwritten MOVE
--l0=l27; -- overwritten MOVE
l0=l9;
l29=l29(l30);
-- if l29==nil then
-- JMP 0 3
l29=l5;
l29();
-- JMP 0 16
-- else/elseif/end
l29=l9;
l30=f0
l0=l27;
l29=l29(l30);
-- if l29~=nil then
-- JMP 0 2
l29=l5;
l29();
-- else/elseif/end
l29=l9;
l30=f0
l0=l27;
l29=l29(l30);
-- if l29==nil then
-- JMP 0 2
l29=l5;
l29();
-- else/elseif/end
l29=l9;
l30=f0
--l0=l27; -- overwritten MOVE
--l0=l5; -- overwritten MOVE
--l0=l26; -- overwritten MOVE
--l0=l19; -- overwritten MOVE
--l0=l3; -- overwritten MOVE
--l0=l9; -- overwritten MOVE
l0=l28;
l29=l29(l30);
-- if l29~=nil then
-- JMP 0 2
l29=l5;
l29();
-- else/elseif/end
l29=l28;
l30=script;
l29=l29(l30);
-- if l29~='Instance' then
-- JMP 0 2
l29=l5;
l29();
-- else/elseif/end
l29=script;
l29=l29['Name'];
-- if l29~='MainModule' then
-- JMP 0 2
l29=l5;
l29();
-- else/elseif/end
l29=l9;
l30=l9;
l29=l29(l30);
-- if l29==nil then
-- JMP 0 2
l29=l5;
l29();
-- else/elseif/end
l29=l9;
l30=error;
l29=l29(l30);
-- if l29==nil then
-- JMP 0 2
l29=l5;
l29();
-- else/elseif/end
l29=l9;
l30=f0
l0=l10;
l29(l30);
l29=l9;
l30=f0
l0=l5;
l29(l30);
l29=l9;
l30=f0
l0=l10;
l29(l30);
l29=#l10;
-- if l29<2 then
-- JMP 0 2
l29=l2;
l29();
-- else/elseif/end
l29=l9;
l30=f0
l0=l5;
l29(l30);
l29=l9;
l30=f0
--l0=l6; -- overwritten MOVE
l0=l5;
l29(l30);
l29=l9;
l30=f0
--l0=l12; -- overwritten MOVE
l0=l5;
l29(l30);
l29=l9;
l30=f0
l0=l5;
l29(l30);
l29=l9;
l30=f0
l0=l5;
l29(l30);
l29=l9;
l30=f0
l0=l5;
l29(l30);
l29=l9;
l30=f0
l0=l5;
l29(l30);
l29=l9;
l30=f0
l0=l5;
l29(l30);
l29=l9;
l30=f0
--l0=l18; -- overwritten MOVE
l0=l5;
l29(l30);
l29=l9;
l30=f0
local l14;
l0=l14;
l29=l29(l30);
-- if l29~=nil then
-- JMP 0 2
l29=l5;
l29();
-- else/elseif/end
l29=l9;
l30=f0
l29=l29(l30);
-- if l29~=nil then
-- JMP 0 2
l29=l5;
l29();
-- else/elseif/end
l29=l9;
l30=f0
local l21;
--l0=l21; -- overwritten MOVE
local l23;
--l0=l23; -- overwritten MOVE
--l0=l17; -- overwritten MOVE
local l24;
l0=l24;
l29=l29(l30);
-- if l29~=nil then
-- JMP 0 2
l29=l5;
l29();
-- else/elseif/end
l29=l9;
l30=f0
--l0=l6; -- overwritten MOVE
l0=l5;
l29=l29(l30);
-- if l29~=nil then
-- JMP 0 2
l29=l5;
l29();
-- else/elseif/end
l29=l9;
l30=f0
l0=l5;
l29=l29(l30);
-- if l29~=nil then
-- JMP 0 2
l29=l5;
l29();
-- else/elseif/end
l29=l9;
l30=l9;
l31=require;
-- this function has C as 0, please correct this after processing
l30(l31,l32);
local l20;
local l22;
local l25;
l29=l29(unpack({l0,l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,l12,l13,l14,l15,l16,l17,l18,l19,l20,l21,l22,l23,l24,l25,l26,l27,l28,l29,l30,l31,l32,...},30,top_index));
-- if l29==nil then
-- JMP 0 2
l29=l5;
l29();
-- else/elseif/end
l29=false; -- C: 0
l30=l9;
l31=loadstring;
l30=l30(l31,l32);
-- if l30~=nil then
-- JMP 0 11
l30=task;
l30=l30['spawn'];
l31=pcall;
l32=require;
local l33;
l30(l31,l32,l33);
l30=require;
l30=l30(l31);
l29=true; -- C: 0
l30=task;
l30=l30['spawn'];
l31=pcall;
-- else/elseif/end
l32=require;
l30(l31,l32,l33);
l30=l9;
l31=require;
l30=l30(l31,l32);
-- if l30==nil then
-- JMP 0 2
l30=l5;
l30();
-- else/elseif/end
l30=loadstring;
l31=qz;
l32=nil;
l32=l31;
l33=require;
local l34;
l33=l33(l34);
l34=nil;
local l35=Instance;
l35=l35['new'];
local l36;
l35=l35(l36);
local l37=l14[13];
local l38=l14[2];
local l39=l14[1];
local l40=l14[1];
local l42=l14[22];
local l43=l14[5];
local l44=l14[18];
local l45=l14[3];
local l46=l14[5];
local l47=l14[12];
local l41;
local l48;
l36=l36..l37..l38..l39..l40..l41..l42..l43..l44..l45..l46..l47..l48;
l37=l15;
l38=true; -- C: 0
l37=l37(l38);
l38=l16;
l39=l37;
l38=l38(l39);
l39=assert;
l40=Instance;
l41=error;
l42=coroutine;
l43=warn;
l44=rawset;
l45=rawget;
l46=script;
l47=newproxy;
l48=tostring;
local l49=pcall;
local l50=game;
local l51=task;
local l52=setfenv;
local l53=getfenv;
local l54=setmetatable;
local l55=getmetatable;
local l56;
local l57;
l57,l56=l56,l50['GetService'];
local l58;
l56=l56(l57,l58);
l57=l46['LS'];
l58,l57=l57,l57['Clone'];
l57=l57(l58);
l58={};
local l59=l52;
local l61={};
local l60;
l59(l60,l61);
l59=l52;
l61={};
l59(l60,l61);
l59=l49;
l60=l56['GetAsync'];
l61=l56;
local l62;
l59,l60=l59(l60,l61,l62);
l62,l61=l61,l60['find'];
local l63;
l61=l61(l62,l63);
-- if l61==nil then
-- JMP 0 2
l34=false; -- C: 0
-- JMP 0 1
-- else/elseif/end
l34=true; -- C: 0
-- else/elseif/end
l61=f0
--l0=l48; -- overwritten MOVE
--l0=l15; -- overwritten MOVE
l0=l16;
l62=l35['Event'];
l63,l62=l62,l62['Connect'];
local l64=f0
--l0=l49; -- overwritten MOVE
--l0=l32; -- overwritten MOVE
--l0=l23; -- overwritten MOVE
--l0=l24; -- overwritten MOVE
--l0=l36; -- overwritten MOVE
--l0=l14; -- overwritten MOVE
--l0=l39; -- overwritten MOVE
--l0=l41; -- overwritten MOVE
--l0=l51; -- overwritten MOVE
--l0=l48; -- overwritten MOVE
--l0=l56; -- overwritten MOVE
--l0=l33; -- overwritten MOVE
--l0=l40; -- overwritten MOVE
--l0=l57; -- overwritten MOVE
--l0=l61; -- overwritten MOVE
--l0=l29; -- overwritten MOVE
--l0=l30; -- overwritten MOVE
--l0=l43; -- overwritten MOVE
--l0=l58; -- overwritten MOVE
--l0=l44; -- overwritten MOVE
--l0=l45; -- overwritten MOVE
--l0=l18; -- overwritten MOVE
l0=l19;
l62(l63,l64);
l62=f0
l0=l35;
l38['__call']=l62;
l38['__metatable']='';
l63,l62=l62,l46['Destroy'];
l62(l63);
-- if l34==nil then
-- JMP 0 2
-- TESTSET 62 37 1
-- JMP 0 3
-- else/elseif/end
l62=l47;
l63=true; -- C: 0
l62=l62(l63);
-- else/elseif/end
-- RETURN 62 1 0
-- RETURN 0 0 0

