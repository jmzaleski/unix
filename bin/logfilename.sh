#!/bin/bash


if test -z "$1"
then
	FN=/tmp/log
else
	FN=$1
fi

FN=`date +$FN-%h%d-%H%M`

for i in '' a b c d e f g h i j k l m n o p q r s t u v w x y z
do
	if test ! -d "$FN$i" -a  ! -f "$FN$i"
	then
		echo "$FN$i"
		exit 0
	fi
done

exit 42

