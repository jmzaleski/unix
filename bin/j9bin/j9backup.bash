#!/bin/bash

j9backup_nonobj(){
	if test -z $*
	then
		dir=.
	else
		dir=$1
	fi
	fn=~/`date +j9backup.%h%d.tar.gpg`

	echo hit return to backup $dir to $fn. 
	read junk

	case $junk in
	[nN]*)
		exit 2
		;;
	esac

	/bin/find $dir \
		-type f \
		-not -path './98ddk/*' \
		-not -path './j9.devenv/*' \
		-not -path './j9_home/*' \
		-not -path './Tools/*' \
		-not -path './Envy/*' \
		-not -path './98ddk/*' \
		-not -name *.exp \
		-not -name *.obj \
		-not -name *.lib \
		-not -name *.pdb \
		-not -name *.dumpbin \
		-not -name *.pch \
		-not -name *.map \
		-not -name *TAGS* \
		-not -name *.dll  | \
	tar -cvf - --files-from - | gpg -e --recipient matz -o $fn
	echo backup done
	ls -l $fn
}

cd ~/j9
j9backup_nonobj
