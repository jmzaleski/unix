#!/bin/sh

if test ! -f $1
then
	echo cannot open $1
	exit 2
else
	psfn=`basename $1 .ps`
fi

if test ! -f $psfn.ps
then
	echo oops, if prefix is $psfn should be able to stat $psfn.ps but cannot
	exit 3
fi

#-r reverses the pages and ps2pdf converts stdout to pdf..

psselect -r $psfn.ps | ps2pdf - $psfn
