#!/bin/sh

h=`hostname -s`
tarfile=`date +dots.$h/dot_%h%d_%H%M.tarz`

if test -f $tarfile
then
	echo $tarfile exists
	exit 2
fi

if tar -cvzf $tarfile \
	`ls -d .* | grep -v '^\.FBCIndex$\|^\.Trash$\|^\.$\|^\.\.$'`
then
	ls -l $tarfile
else
	echo tar to $tarfile failed
	exit 2
fi

