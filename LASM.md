LASM (Lua Assembly) is what all Lua scripts eventually compile into. It is much more difficult to
actually do anything in opposed to Lua, but you can do a lot more than in plain Lua. To learn
about the opcodes and basic LASM code structure, please read the
ANoFrillsIntroToLua51VMInstructions.pdf file by Kein-Hong man, available on -LuaForge- and in
the etc\docs folder.
# LAT (Lua Assembly Tools) LASM
LAT Lua Assembly is simple. There are three types of statements: Controls (beginning with a
dot), Opcodes, and Comments. Constants can be automatically managed for you, strings are the
same as in Lua, numbers can be in decimal, hexadecimal, binary, or octal, and can have
underscores in them.
Constants can either be a string (such as ‘print’), true, false, a number, or nil/null. The way to
use a constant is, if it’s not a number, to just put it in code. You can also use a function-call like
structure using “k”, “const”, or “constant”, e.g. k(7), or const’str’. To use a function by name,
use the “p” or “proto” function, like so: p’FuncName’ or proto(FunctionX).
Comments start with a semicolon ‘;’ and end with a newline.
The controls are as follows (an Ident is like a variable name):
[ ] = optional, < > = required
.const <Constant>
.name <String or Ident>
.options [Number upvalue count] [Number argument count] [Number vararg flag] [Number
MaxStackSize]
.local <Name or Ident>
.upval or .upvalue <Name or Ident>
.stacksize or .maxstacksize <Number>
.vararg <Number>
.params or .args or .argcount <Number>
.func or .function [String name] – begins a new function in the current one
.end – ends a function
## Opcode format:
<Opcode name> <Argument A> <Argument B> <Argument C>
<Opcode name> <Argument A> <Argument Bx>
<Opcode name> <Argument A> <Argument sBx>
Opcode names are not case sensitive. An argument can either be a Number, a Constant (see
above for the many ways to automanage them), a proto (see above for how to use them), or a
number that starts with ‘$’ or ‘R’ or ‘r’
You don’t need to explicitly define the RETURN opcode at the end of a function, the LAT parser
will automatically insert the default one if none is specified.
