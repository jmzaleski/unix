#!/bin/sh

#makefile.list is a list of all makefiles

for i in `cat makefile.list`
do
    if test -f j9build.save/$i
    then
	if diff --ignore-matching-lines=Timestamp: j9build.save/$i j9build/$i > /dev/null
	then
	    echo $i same > /dev/null
	else
	    echo $i
	fi
    fi
done
