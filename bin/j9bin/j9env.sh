J9="/cygdrive/c/Documents and Settings/matz/j9"

# add ddk to path (for assembler)

PATH=$PATH:"$J9/98ddk/bin/win98:/cygdrive/c/Program Files/Microsoft Visual Studio .NET 2003/Vc7/bin"

# add Windbg to include search path. Learn how to do this in Makefiles.
export INCLUDE=$INCLUDE';\
C:\Program Files\Debugging Tools for Windows\sdk\inc;\
c:\Program Files\Microsoft Visual Studio .NET 2003\Vc7\PlatformSDK\Include\
'
