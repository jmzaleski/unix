#!/bin/sh

dir=`date +safe_%h%d_%H%M`

if test -d $dir
then
		echo $0: $dir already exists. exit without copy
		exit 2
fi

FILES="*.[cCh]* *akefile *.f *.java *.html *.doc *.ppt *.xls *.lyx *.cdd *.CDD *.ai *.tex *.s *.bib *,v *.dia *.svg *.py *.sh *.js" 

if mkdir $dir
then
	for i in $FILES
	do
			if test ! -f $i
			then
				echo skip $i
			else
				if cp $i $dir
				then
					test $dir/$i #this is noop
				else
					echo $i failed to copy. exit 2
					exit 2
				fi
			fi
	done
	echo $0 made copy of all files matched by '$FILES'
	echo "$FILES"
	ls -l $dir/*
else
	echo $0: could not create $dir. exit without copy
	exit 2
fi

exit 0
