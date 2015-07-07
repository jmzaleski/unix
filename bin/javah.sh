#!/bin/sh

#javah a class file.


fn=$*


	if test ! -f $fn
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
	echo javah  $cl
	javah -verbose $cl


#  	echo 'dirname='$dir
#  	echo 'cfn='$cfn
#  	echo 'c='$c
#  	echo 'pack='$pack
#  	echo 'cl='$cl
