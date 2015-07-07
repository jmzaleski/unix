@echo set several environment variables looked for by the J9 makefiles.
@rem set several environment variables looked for by the J9 makefiles.
@echo the result is to build objects with debug tables.

@rem j9dbgbuildenv.bat sets vmdebug, etc, to ensure j9 makefile build for debug

set vmdebug=/Zi /Odi -DDEBUG
set vmasmdebug=/Zi -DDEBUG
REM set vmlink=/debug /debugtype:both
set vmlink=/debug /debug:full /debugtype:cv
set gnudebug=-g
