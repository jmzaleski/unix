#!/bin/bash

DBG="test -n $DBG"
J9=~/j9

cont(){
	echo $*
	echo -n hit return to continue..
	read junk
}

#unzip into somewhere
#clean up?
#cvs import..

if $DBG; then cont before cvs co j9build; fi
#cvs co j9build

cd j9build

#clean out the mess in here. build leaves DLL's and other stuff lying around.

winfn=\"`cygpath --windows "$J9/j9build/makefile"`\"

if $DBG; then cont before nmake -f $winfn clean; fi

/bin/pwd

if nmake -f "$winfn" clean
then
	echo make clean exits okay
else
	echo make exits failure
	exit 7
fi

if $DBG; then cont before diff; fi

#diff files in the directories for reference..
echo diff $newDropDir..
# -I '\* \$Revision.*$\|\* \$Date: 2005-01-11 15:54:16 $'
echo no good because of revisions diff -x CVS -I Revision: -r --brief $J9/j9build $newDropDir > $J9/diff.$vertag


