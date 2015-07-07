#!/bin/sh

#rsynch * in home directory and skule directory
#idea is that stuff that we don't want to rsync in home should be a symlink
#rsync doesn't clobber symlinks in destination

if test -z "$*"
then
	DEST=ll0
else
	DEST=$1
fi

echo DEST= $DEST

#copy the home directory on the laptop to DEST. carefully.

#BIG TODO: resource forks not backed up!!
#not a worry for the unix like files, but might ruin illustrator and other files.

#set to empty string to run production.
#DEBUG=true
DEBUG=""

#exclude stuff that we don't want to copy  from home directory
#AND ALSO THAT WE DON'T WANT TO DELETE ON TARGET!!

EXCLUDES="\
	--exclude junk/ \
	--exclude skule/ \
	--exclude img/ \
	--exclude CVS/ \
	--exclude Documents/iTunes/ \
	--exclude Shared/ \
	--exclude Mail/ \
	--exclude Library/Caches/ \
	--exclude Applications/ \
	--exclude pgp/ \
	--exclude public_html/"

#check sanity..

if test ! -d  $HOME
then
	echo $0: cannot find dir $HOME
	exit 2
fi


#do it this way to preserve the dot files in dest from being clobbered
#how to anchor the exclusions at the top of the path.

#
########## home ################
#
cd $HOME

#guard against eventuality that the target (or anything else) is actually 
#mounted on l0 directory. This is a sloppy goof that has been made..

if test -f l0/bin
then
	echo oh oh  is home dir smb mounted??
	mount | grep l0
	exit 2
fi

if test ! -z "$DEBUG"
then
	dbgopt="--dry-run --progress"
else
	dbgopt=""
fi

# rsync -a archive. Recursive. Recreate links, special files.
# --backup. changed and deleted target files written to named dir 
# --update DO NOT overwrite files that are newer on target
# --delete rm files on target that don't exist on source (copy to backup)
# --exclude directories that you don't want to copy from source 
#           or DEL on target
# --cvs-exclude exclude all and sundry CVS files.

rsync $dbgopt \
	-av   \
	--progress \
	--backup --backup-dir=/usr/matz/rsync.backups \
	--update \
	--delete  \
	--cvs-exclude \
	$EXCLUDES \
	* \
	$DEST:. | tee /tmp/rsync.log

#
########## /usr/matz/skule ################
#
cd /usr/matz/skule

rsync $dbgopt \
	-av   \
	--update \
	--delete  \
	--cvs-exclude \
	* \
	$DEST:skule | tee /tmp/skulersync.log

#
########## /usr/matz/instruct ################
#
cd /usr/matz/instruct

rsync $dbgopt \
	-av   \
	--update \
	--delete  \
	--cvs-exclude \
	* \
	$DEST:instruct | tee /tmp/instructrsync.log

echo note: resource forks were not backed up

