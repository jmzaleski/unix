#!/bin/sh

#check in all the files and then check them out again

if test -z "$1"
then
	echo "usage: $0 directory"
	exit 2
else
	dir=$1
fi

if test ! -d $dir
then
	echo $0: $dir is not a directory
	exit 3
fi


cd $dir

echo oh darn this will get .o files as well.

if test -f Makefile
then
	ls -l Makefile
	echo Makefile exists, so making ciall
	make ciall
else
	for i in RCS/*,v
	do
		ci -l '-movernight checkin' '-t-NoDescritiveText' $i
	done
fi

#chmod g+w *.*

ls -l *.*
