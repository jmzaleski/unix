#!/bin/bash

#strategic directories on small disk

LIST="/ /System /Applications /Developer /Documents ~matz"

dodus(){
	
	echo ------- usage for directories in $PWD
	for i in *;
	do
		cd "$i"
		if test -d "$i"
		then
			echo '===' $i
			dus.sh "$i"
		fi
		cd ..
	done
}

#directories in / that use up significant space.

DIRS="
/Users/matz \
/bin \
/opt \
/Developer \
/private \
/usr \
/Library \
/Users \
/System \
/Applications \
"

LOG=/tmp/ddus.`date +$2%h%d_%y`.log

echo log to $LOG
for i in $DIRS
do
	if test ! -d "$i"
	then
		echo $i not a directory...
		exit 2
	else
		ls -ld $i
	fi
done

dusit(){
	echo \"$1\"
	cd "$1"
	echo '=======' $PWD
	ls -ld "$1"
	du -ks .
	du -ksPx * | sort -n | tail -50
}

for i in $DIRS
do
	dusit "$i"
done | tee -a $LOG

dusit "/System Folder" | tee -a $LOG
dusit "/Applications (Mac OS 9)" | tee -a $LOG

