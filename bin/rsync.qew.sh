#!/bin/sh

#rsync schoolwork related stuff to CSLAB machine.

DEST=qew.cs.toronto.edu:\~/

echo rsync schoolwork directories to $DEST

if test ! -d  "$HOME"
then
	echo $0: cannot find dir $HOME
	exit 2
fi

#if we rsycnc from there it will cream the CVS directory

case `hostname` in
l0*)
	echo from l0 we rsync CVS..
	DIRS="./skule ./CVS"
	;;
*)
	echo 'from machines other than l0 we do not rsync CVS'
	DIRS="./skule"
	;;
esac


if test -z "$*"
then
	dirs=$DIRS
else
	dirs=$*
fi

for d in $dirs
do
	if test ! -d $d
	then
		echo $d not a directory
		exit 2
	 else
		ls -ld $d
	fi
done
echo will be rsync\'d to $DEST


# rsync -a archive. Recursive. Recreate links, special files.
# --backup. changed and deleted target files written to named dir 
# --update DO NOT overwrite files that are newer on target
# --delete rm files on target that don't exist on source (copy to backup)
# --exclude directories that you don't want to copy from source 
#           or DEL on target
#

#	--backup --backup-dir=/usr/matz/rsync.backups \

#want -a but..
#it attempts to reset group ownership which we cannot do on
#cslab and eecg hosts.
#-rlvpt is equivalent to -a less preserve owner and group, which runs afoul
#of cslab (and eecg) group set up.
#-bwlimit tells rsync to attempt to limit the bandwidth it uses to 100K
#this stays clear of DSL up bandwidth throttling.

env RSYNC_RSH=ssh \
	/usr/local/bin/rsync -v --progress $dbgopt \
	--rsync-path=/h/33/matz/bin/sparc/rsync \
	--bwlimit=100 \
   -z \
	-rltp    \
	--update --delete  \
	$EXCLUDES \
	$dirs $DEST


echo rsync done `date`

