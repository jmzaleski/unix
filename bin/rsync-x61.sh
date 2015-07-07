#!/bin/sh

if test `id -u` != 0
then
	echo $0: must sudo or run as root..
	exit 2
fi

LOG=`date +/var/log/rsync-x61-%h%d`

# mount point of usb external. How to set this?

DEST=/media/X61_BACKUP

if test ! -d $DEST
then
	echo $0: cannot open $DEST. Is it mounted?
	exit 2
fi

# rsync -a archive. Recursive. Recreate links, special files.
# --backup. changed and deleted target files written to named dir 
# --update DO NOT overwrite files that are newer on target
# --delete rm files on target that don't exist on source (copy to backup)
# --exclude directories that you don't want to copy from source 
#           or DEL on target
# --cvs-exclude exclude all and sundry CVS files.

#	--update \
#	--delete  \
#	--exclude /proc    \

CMD='rsync $dbgopt  
	--archive  
	--verbose  
	--one-file-system  
	--exclude /tmp     
	--exclude /var/log 
	/ $DEST | tee -a $LOG'

echo $CMD
echo 
echo -n 'hit return to run above command > '
read junk
echo logging stdout to $LOG

echo start rsync X61 `date` >> $LOG

eval $CMD

echo finish rsync X61 `date` >> $LOG

