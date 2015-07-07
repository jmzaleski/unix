set J9=%HOMEDRIVE%%HOMEPATH%\j9

rem add Visual C version 7 include and lib files to paths
call "c:\Program Files\Microsoft Visual Studio .NET 2003\Common7\Tools\vsvars32.bat"

rem add win dbg include files to include path
call "%J9%"\bin\j9windbgenv.bat

rem inform the microsoft compiler and linker to build for debug. Equivalent to -g?
call "%J9%"\bin\j9dbgbuildenv.bat
set PATH=%PATH%;c:\cygwin\bin;

