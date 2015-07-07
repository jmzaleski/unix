#!/bin/sh


if test ! -d $1
then
	echo "$1 not a directory. Exit with no backup"
	exit 2
fi

tarfile=`date +safe.%h%d`

if test ! -f $tarfile.tar
then
	tarfile=$tarfile."tar"
else
	for i in a b c d e f g h i j k l m n o p q r s t u v w x y z
	do
		if test ! -f $tarfile.$i.tar 
		then
			tarfile=$tarfile.$i.tar
			break
		else
			echo $tarfile.$i.tar exists already, moving on..
		fi
	done
fi


if test -f $tarfile
then
		echo $0: Oh no, bug in script $tarfile already exists. exit without copy
		exit 2
fi

echo "about to execute tar -cvf $tarfile $1"
tar -cf $tarfile $1

tar -tvf $tarfile > $tarfile.list
ls -l $tarfile*

echo "about to compress $tarfile"

compress -c $tarfile > $tarfile.Z

if test ! -f $tarfile.Z
then
	echo "error, cannot find $tarfile.Z"
	exit 2
fi

ls -l $tarfile.Z
scp $tarfile.Z 'matz@qew.cs.toronto.edu:'
