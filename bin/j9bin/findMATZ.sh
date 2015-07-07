#!/bin/bash

#create the lists of files changed by matz:
#matzmakefiles.txt
#matzsrclist.txt

#we are in changed 

/bin/find . -name '*.[ch]pp' -exec 'grep' -q //MATZ: '{}' \; -print
/bin/find . -name '*.[ch]' -exec 'grep' -q MATZ: '{}' \; -print

#might help to cross check against brute force newer files:
# /bin/find . -type f -and -newer makefile.~3~ -print

#copy version to be upgraded into j9build.save
#take a fresh ilgen into j9build
#import into CVS
#copy matzlist.txt files overtop of j9build version

#run diff makefile.sh to find diddled makefiles
#edit out bogus ~ files, etc to create matzmakefilelist.txt

#copy these over also.

#main makefile a mess.
# just run j9-hack-makefile.sh

#copy include\j9.ico over
cp ../j9build.save/include/j9.ico j9build/include
#build works?

#oh oh how come have to cp matzDLL/Debug/matzDll.dll j9build ??

works.
