#!/bin/sh 

#see .ssh/config file

case `hostname` in
	*portable*)
		DEST_en0=deskside
	;;
	*deskside*)
		DEST_en0=laptop
		;;
	*)
		echo 'where are we??'
		exit 2
		;;
esac

DEST=$DEST_en0

#when in a hurry use firewire
#DEST=`ssh $DEST_en0 ifconfig fw0 | grep "inet[^6]" | cut -d " " -f 2`
echo $DEST
#exit

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
# --progress

CMD="rsync           \
 -v        \
 --archive --update  \
 --compress --backup \
 --exclude '*~' \
 -e ssh"

echo enter destination host. Default is $DEST
echo '(will proceed in 5 sec..)'
if read -p '>' -t 5 junk
then
	if test -z "$junk"
	then
		dest=$DEST
	else
		dest=$junk
	fi
else
	dest=$DEST
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
#read -p'>' -t 10 junk
eval $CMD $DEBUG $push

echo
echo PULL DRY RUN $CMD $DEBUG $pull
#read junk
eval $CMD $DEBUG $pull

echo enter '[yY]  to **really** execute rsync commands..'

read  -p 'yes or no > ' junk

case $junk in
[yY]*)
		set -x
		eval $CMD --progress $push
		eval $CMD --progress $pull
		;;
*)
	echo no rsync done
	exit 1
	;;
esac
	
