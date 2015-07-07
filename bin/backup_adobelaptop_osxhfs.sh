#!/bin/bash

# make sure weird perm on filesystem "ingore ownership on this volume" is NOT checked

# cribbed from http://www.labf.org/~egon/mac_backup/

  # --eahfs enables HFS+ mode
  # nope, now it's -E or --extended-attributes
  # -a turns on archive mode (recursive copy + retain attributes)
  # --showtogo shows the number of files left to process
  # --delete deletes any files that have been deleted locally
  # --exclude-from backup_excludes.txt (names file list excluding stuff)
  #  --hfs-mode=appledouble  cribbed from synch.sh http://www.afp548.com/article.php?story=20050219192044818

#only thing I added is --hard-links to preserve hard links 

DEST=/Volumes/adobelaptop_osxhfs_back

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

# Function for toggling Spotlight indexing
spotlight_switch()
{
	if test ! -x  /usr/bin/mdutil
	then
		echo no /usr/bin/mdutil
		exit 2
	fi

  /usr/bin/mdutil -i $1 /
  /usr/bin/mdutil -i $1 $DEST
}

echo about to run rsync from / to $DEST 

EXCLUDES="\
 --exclude '/dev/*' \
 --exclude '/afs/*' \
 --exclude '/private/tmp/*' \
 --exclude '/Network/*' \
 --exclude '/Volumes/*' \
 --exclude '/automount/*' \
 --exclude '/private/var/run/*' \
 --exclude '/private/var/folders/*' \
 --exclude '/private/var/vm/*' \
"
EXCLDFILE=/tmp/excludes

cat > $EXCLDFILE <<EOF
/.Spotlight-*
*/.Trash
*/Library/Caches/*
*/Library/Safari/Icons/*
/System/Library/Extensions.kextcache
/System/Library/Extensions.mkext
/System/Library/Caches/com.apple.kernelcaches
/private/var/db/NetworkInterfaces.xml
/private/var/vm/*
/private/var/launchd/*
/private/var/db/BootCache.playlist
/private/var/db/volinfo.database
/private/var/db/SystemConfiguration/com.apple.PowerManagement.xml
/private/var/tmp/*
/private/var/run/*
/private/var/imap/socket/*
/private/var/spool/postfix/private/*
/private/var/spool/postfix/public/*
/private/tmp/*
/tmp/*
/dev/*
/automount/*
/Network/*
/Volumes/*
/cores/*
*.TemporaryItems
*.log*.gz
*/ByHost 
EOF

ls -l $EXCLDFILE

EXCLUDES="--exclude-from=$EXCLDFILE"

echo running rsync with exclude file $EXCLDFILE #and stderr to /var/log/rsync.log

read -p ' make sure weird perm on filesystem "ingore ownership on this volume" is NOT checked' junk

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

# use the fink rsync (3.0.7). the default os/x 10.6.4 version (2.6.9) appears to be busted!
# it hangs on named pipes and other stupid stuff.
# 		 --extended-attributes \


CMD="/sw/bin/rsync             \
		 --archive             \
		 --hard-links          \
		 --delete              \
		 --one-file-system     \
		 $EXCLUDES             \
	     --progress            \
		/ $DEST/ " ####2>&1 | tee /var/log/rsync.log

read -p "hit return to run command: $CMD" JUNK


if eval $CMD
then
	echo rsync exits with succesful exit code
else
	echo rsync exits with failing exit code
	echo hence have NOT attempted to bless $DEST
	echo see:
	ls -l /var/log/rsync.log
	spotlight_switch on
	exit 3
fi

# make the backup bootable
# I think this more less means copy a boot loader into the right place.
# trying to grok man bless here..
# 
if bless -folder $DEST/System/Library/CoreServices --bootefi --bootinfo #/usr/standalone/ppc/bootx.bootinfo
then
	echo bless returns with successful exit code. $DEST is bootable.
	bless -info $DEST/System/Library/CoreServices
else
	echo bless returns with failing exit code.
	spotlight_switch on
	exit 4
fi

spotlight_switch on

