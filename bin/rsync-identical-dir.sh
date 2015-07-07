#!/bin/sh -e

#see .ssh/config file
#DEST=laptop-fw
#DEST=laptop-wifi
DEST_fw0=169.254.142.155

set -x
#DEST=`ssh $DEST_en0 ifconfig fw0 | grep "inet[^6]" | cut -d " " -f 2`
DEST=$DEST_fw0
set -

#rsync the current directory or ONE named directory.
# rsynch.sh with no args rsync's the current directory to the same one relative
# to your home on DEST.
# (rsync.sh dir cd's to the arg and does the same thing.)

#local_dir=/Users/mzaleski
#local_dir=/tmp/mzaleski
local_dir=$PWD

if test -d "$local_dir"
then
	cd $local_dir
else
	echo cannot find dir $local_dir
	exit 2
fi

/bin/pwd -P

DEBUG=--dry-run

# --cvs-exclude 
# --progress
# --compress --backup
# --update # skip files newer on receiver
# -e ssh"

CMD="rsync           \
 -v --progress       \
 --archive --update --partial \
 --delete "

echo enter destination host. Default is $DEST
echo '(will proceed with default in 15 sec..)'
read -p '>' -t 15 junk

if test -z "$junk" 
then
	dest=$DEST
else
	dest=$junk
fi

#set -ex
#have to escape
echo about to run ssh to check that $local_dir exists on remote. may hang if $dest not right..

if ssh $dest  test -d $local_dir
then
	ssh  $dest  ls -ld $local_dir
else
	echo no dir $local_dir on $DEST
	exit 42
fi

cmd="$CMD . $dest:$local_dir"

/bin/pwd -P

echo enter '[yY]  to **really** execute rsync commands..'
echo  $cmd
read  -p '> ' junk

case $junk in
[yY]*)
		set -x
		eval $cmd
		;;
*)
	echo no rsync done
	exit 1
	;;
esac
	
