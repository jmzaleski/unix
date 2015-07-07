#!/bin/bash


DEST=./sent


if test -z "$1"
then
	echo usage: $0 file '# copies to sent/file.datesuffix'
	exit 2
fi

if test ! -d sent
then
	echo $0: no sent directory.. are you in the right place?
	exit 4
fi

if test ! -f $1
then
	echo $0: cannot open file $1
	exit 3
fi

file=$1



dest=`date +$DEST/%h%d-$file`


if test -f $dest
then
	for i in a b c d e f g h i j k l m n o p q r s t u v w x y z
	do
		if test ! -f $dest.$i
		then
			dest="$dest.$i"
			break
		else
			echo $dest.$i exists already, moving on..
		fi
	done
fi

echo cp $file $dest

cp $file $dest
