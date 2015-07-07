#!/bin/sh

DEST=ll0

#copy argument from host DEST with the same path relative to the HOME directory.

if test $# -gt 1
then
	echo "$0: sorry, just one file or glob for now"
	exit 1
fi

#assume that the file is qualified from .

relpath="$1"

#so what is this relative to home?

abspath=`/bin/pwd`/$relpath

relHomePath=`echo "$abspath" | sed -n -e 's;'$HOME/';;p'`

cmd="scp $DEST:\~/$relHomePath ."

echo hit enter to execute: $cmd

read junk

echo scp working...
$cmd



