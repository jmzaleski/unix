#!/bin/sh

#back up the files names by parms by ci -l them into a local RCS archive

if test ! -d ./RCS
then
	read -p "no ./RCS file. Do you want to create one?" $junk
	mkdir RCS
fi

#set -x
ci -l -mbold.sh $*
