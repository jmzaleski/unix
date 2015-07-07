#!/bin/sh

dir=`date +safe.%h%d.%T`

if test -d $dir
then
		echo $0: $dir already exists. exit without copy
		exit 2
fi

if mkdir $dir
then
   		cp *.c *.h *.style Imakefile Makefile $dir
		echo $0 made copy:
		ls -l $dir/*
else
		echo $0: could not create $dir. exit without copy
		exit 2
fi

exit 0
