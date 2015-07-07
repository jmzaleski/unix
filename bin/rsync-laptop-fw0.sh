#!/bin/sh -e

#see .ssh/config file
DEST_en0=laptop
#DEST=laptop-wifi
#DEST=169.254.200.134

#set -x

DEST=`ssh $DEST_en0 ifconfig fw0 | grep "inet[^6]" | cut -d " " -f 2`

echo $DEST
echo early exit && exit 42

echo about to ssh $DEST hostname ..may hang
ssh $DEST hostname

#rsync the current directory or ONE named directory.
# rsynch.sh with no args rsync's the current directory to the same one relative
# to your home on DEST.
# (rsync.sh dir cd's to the arg and does the same thing.)

dir=garbage

if test $# -gt 1
then
	echo "$0: sorry, just one directory for now"
	exit 1
fi

if test $# -eq 1
then
	dir=$1
	if test ! -d $dir
	then
		echo $0: cannot find directory $dir
		exit 1
	fi
else
	dir=''
fi

if test ! -z "$dir"
then
	cd $dir
fi

pwd

rpwd=`pwd | sed -n -e 's;'$HOME/';;p'`

#what if rpwd has blanks in a file or dir name? parsing will fail?
#rpwd=\"$rpwd/\"

if test ! -d $HOME/$rpwd
then
	echo $0: error, cannot find directory $rpwd
	exit 1
fi

DEBUG=--dry-run

# --cvs-exclude 
# --delete 

CMD="rsync           \
 -v --progress       \
 --archive --update  \
 --compress --backup \
 -e ssh"

echo enter destination host. Default is $DEST
echo PUSH DRY RUN will be: $CMD $DEBUG $push
echo '(will proceed in 15 sec..)'
read -p '>' -t 15 junk

if test -z "$junk" 
then
	dest=$DEST
else
	dest=$junk
fi

#ssh 
#wow, is this awful or what? issue is that blanks in dir name have to be escaped
#somehow. and the ones passed to the other side need to be double escaped.
#
push=". $dest:\"$rpwd\""
pull="$dest:\"\\\"$rpwd\\\"\"/ ."

# check if dest exists. if not, create it.

#set -ex
if ssh  $dest  test -d "\"$rpwd\""
then
	ssh  $dest  ls -ld "\"$rpwd\""
else
	echo destination $rpwd does not exist on $dest.. hit enter to mkdir..
	read  -p '> ' junk
	ssh  $dest  mkdir "\"$rpwd\""
	ssh  $dest  ls -ld "\"$rpwd\""
fi

echo PUSH DRY RUN: $CMD $DEBUG $push
read -p'>' -t 10 junk
eval $CMD $DEBUG $push

echo
echo PULL DRY RUN $CMD $DEBUG $pull
read -p'>' -t 10 junk
eval $CMD $DEBUG $pull

echo enter '[yY]  to **really** execute rsync commands..'

read  -p '> ' junk

case $junk in
[yY]*)
		set -x
		eval $CMD $push
		eval $CMD $pull
		;;
*)
	echo no rsync done
	exit 1
	;;
esac
	
