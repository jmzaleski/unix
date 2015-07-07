#!/bin/bash

# Function for toggling Spotlight indexing
spotlight_switch()
{
  /usr/bin/mdutil -i $1 /
  /usr/bin/mdutil -i $1 /Volumes/m1_osxhfs_back
}


#/usr/bin/rsync -avE --delete $EXCLUDES /Users /Volumes/Backup


# cribbed from http://www.labf.org/~egon/mac_backup/

  # --eahfs enables HFS+ mode
  # nope, now it's -E or --extended-attributes
  # -a turns on archive mode (recursive copy + retain attributes)
  # --showtogo shows the number of files left to process
  # --delete deletes any files that have been deleted locally
  # --exclude-from backup_excludes.txt (names file list excluding stuff)
  #  --hfs-mode=appledouble  cribbed from synch.sh http://www.afp548.com/article.php?story=20050219192044818

#only thing I added is --hard-links to preserve hard links 

DEST=/Volumes/m1_osxhfs_back

if test ! -d $DEST
then
	echo $DEST not mounted
	exit 2
fi

if test `id -u` -ne 0
then
	echo must run backup of / as root
	exit 1
fi

if rsync --version | grep HFS 
then 
	echo okay, rsync in path includes HFS support. continuing.
else
	echo rsync in path does not appear to have HFS support
	if rsync --help | grep extended-attributes
	then
		echo well maybe. continuing
	else
		echo you better be running on 10.4..
		exit 2
	fi
fi

echo about to run rsync from / to $DEST 

EXCLUDES="\
 --exclude '/dev/*' \
 --exclude '/afs/*' \
 --exclude '/private/tmp/*' \
 --exclude '/Network/*' \
 --exclude '/Volumes/*' \
 --exclude '/automount/*' \
 --exclude '/private/var/run/*' \
"

echo running rsync with stderr to /var/log/rsync.log

#  A trailing slash on the source changes this behavior to avoid  creating
#  an  additional  directory level at the destination.  You can think of a
#  trailing / on a source as meaning "copy the contents of this directory"
#  as  opposed  to  "copy  the  directory  by name", but in both cases the
#  attributes of the containing directory are transferred to the  contain-
#  ing  directory on the destination.  In other words, each of the follow-
#  ing commands copies the files in the same way, including their  setting
#  of the attributes of /dest/foo:

spotlight_switch off

#		 --hfs-mode=appledouble \

if time rsync                \
		 --extended-attributes \
		 --archive           \
		 --hard-links        \
		 --delete            \
		 --one-file-system   \
		 $EXCLUDES           \
		/ $DEST/ 2>&1 | tee /var/log/rsync.log
then
	echo rsync exits with succesful exit code
else
	echo rsync exits with failing exit code
	echo hence destination has NOT been blessed to boot off..
	echo see:
	ls -l /var/log/rsync.log
	spotlight_switch on
	exit 3
fi

# make the backup bootable
# I think this more less means copy a boot loader into the right place.

if bless -folder $DEST/System/Library/CoreServices \
          -bootinfo /usr/standalone/ppc/bootx.bootinfo
then
	echo bless returns with successful exit code. $DEST is bootable.
	bless -info $DEST/System/Library/CoreServices
else
	echo bless returns with failing exit code.
	spotlight_switch on
	exit 4
fi

spotlight_switch on

