#!/bin/sh

if test ! -d vm
then
	echo are you in the right place? No vm dir.
	exit 2
fi

nmake clean
rm -f */*.pdb *.pdb lib/*.exp
