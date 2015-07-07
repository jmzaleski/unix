
#this script should be "dotted" in from an alias, say j9vc6env
J9=e:\matz\j9

#VC6 installs differently than vc7. Most of environment poured in.
#will have to be carefull if trying to run both at same time.

# add ddk to path (for assembler)

PATH=$PATH:$J9%/j9Tools/98ddk/bin/win98

# add Windbg to include search path. Learn how to do this in Makefiles.

INCLUDE=$INCLUDE";\
C:\Program Files\Debugging Tools for Windows\sdk\inc"
