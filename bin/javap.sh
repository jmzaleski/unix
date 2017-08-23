#!/bin/sh

#javap a class file.

fnargs=$*
clargs=""

for fn in $fnargs
do
	if test ! -f $fni
	then
		echo cannot open file $fn
		exit 2
	fi
	dir=`dirname $fn`
	cfn=`basename $fn`
	c=`echo $cfn | sed s/.class//`
	if test "$dir" = "."
	then
		pack=""
	else
		pack=`echo $dir | tr / .`"."
	fi
	cl=$pack$c
    # -c disassemble..
	javap -private -c -cp . -s $cl
done

#  	echo 'dirname='$dir
#  	echo 'cfn='$cfn
#  	echo 'c='$c
#  	echo 'pack='$pack
#  	echo 'cl='$cl
