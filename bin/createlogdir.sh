#!/bin/bash

FN=`logfilename.sh $1`

if test -d "$FN"
then
	for i in a b c d e f g h i j k
	do
		if test ! -d "$FN"$i
	    then
			FN="$FN"$i
			break
		fi
	done
fi

mkdir $FN

echo $FN

