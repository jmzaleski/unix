#!/bin/bash

#ETAGS="/apps/XEmacs/XEmacs-21.4.11/i586-pc-win32/etags.exe"
ETAGS="/usr/bin/etags.exe --extra=+fq"

###cd ~/j9/j9build

#etags checks env var TMPDIR. (guessing from strings etags.exe)
export TMPDIR=$TMP

#should change this to find . -path ./*_ppc -prune etc to remove ppc and amd trees.
#which just slow down tagging and confuse things when looking for ia32..
#or, just do the ia32 things first?

$ETAGS *_ia32/*.hpp
$ETAGS *_ia32/*.h
$ETAGS *_ia32/*.cpp
$ETAGS *_ia32/*.c

echo .hpp
$ETAGS */*.hpp

echo .h
$ETAGS -a */*.h

echo .cpp
$ETAGS -a */*.cpp

echo .c
$ETAGS -a */*.c

echo .asm
$ETAGS -a */*.asm

echo c++
$ETAGS -a ../ffsd/*.[ch]pp
$ETAGS -a ../ffsd/*.[ch]pp

# $ETAGS -a ../vm/*.[ch]
# $ETAGS -a ../matzDLL/*.c*
# $ETAGS -a ../matzDLL/*.h*


