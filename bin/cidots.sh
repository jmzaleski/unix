#!/bin/sh

cd
for i in .*
do
	if test -f $i
	then
		rcsdiff -q $i
	fi
done
