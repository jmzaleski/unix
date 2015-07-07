#!/bin/sh

#set to empty string to run production.
#DEBUG=true
DEBUG=""

echo skule/research to eecg

echo rsync does not copy resource forks -- these not backed up

EXCLUDES="\
	--exclude Mail/ \
	--exclude Library/Caches/ \
	--exclude Applications/ \
	--exclude pgp/ \
	--exclude public_html/"


if test ! -d  "$HOME"
then
	echo $0: cannot find dir $HOME
	exit 2
fi


#do it this way to preserve the dot files in dest from being clobbered
#how to anchor the exclusions at the top of the path.


# rsync -a archive. Recursive. Recreate links, special files.
# --backup. changed and deleted target files written to named dir 
# --update DO NOT overwrite files that are newer on target
# --delete rm files on target that don't exist on source (copy to backup)
# --exclude directories that you don't want to copy from source 
#           or DEL on target
#

#	--backup --backup-dir=/usr/matz/rsync.backups \
#want -a but it attempts to reset group ownership which we cannot do on cslab and eecg hosts.

#-rlvpt is equivalent to -a less preserve owner and group, which runs afoul
#of cslab (and eecg) group set up.

/usr/local/bin/rsync -v --progress $dbgopt \
    -z \
	-rltp    \
	--update --delete  \
	$EXCLUDES \
	./skule/research \
	isis.eecg.toronto.edu:/nfs/eecg/guest/guest/matz/skule

echo note: rsynch does not copy resource forks -- these not backed up

