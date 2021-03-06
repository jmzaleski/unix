#!/bin/bash

DEST=/media/src/old-workspace
SRC=/media/src/workspace-art-optimizer

if test ! -d "$1"
then
	workspace=$SRC
else
	workspace=$1
fi

d=`basename $workspace`

destdir=`date +$DEST/$d-%h%d`

#stupid bloody trailing / (or would make a directory called $SRC-backup/$SRC

VERB="--progress -v"

RSYNC_EXCLUDE="--exclude=$SRC/.metadata/.plugins/org.eclipse.cdt.core"

RSYNC_CMD1="rsync $RSYNC_EXCLUDE  -a --delete $VERB $SRC/ $SRC-backup"

######################### always run local incremental backup #############

echo continue without prompt for the copy to $SRC-backup..
echo '---------------------------------'
echo running $RSYNC_CMD1
eval $RSYNC_CMD1
echo returned $?
echo '---------------------------------'

echo; 

du -s $workspace
du -s $SRC-backup

echo

######################### optionally run (remote?) incremental backup #############

if true
then
   skip_remote="y"	
else
	echo setting skip remote..

# echo 'Hit s to skip, or  return to continue with remote backup:'

# echo $REMOTE_RSYNC_CMD
# read -p ' > ' junk

# case "$junk" in
# [sS]*)
#   echo skipping remote backup..
#   skip_remote="y"
#   ;;
# *)
# echo '(if you have not logged in there for a while ssh will prompt for password..)'
#   echo running $REMOTE_RSYNC_CMD .....
#   eval $REMOTE_RSYNC_CMD
#   skip_remote=""
# esac
fi

###################### local full ################################3

if test -d $destdir
then
	for i in a b c d e f g h i j k l m n o p q r s t u v w x y z
	do
		if test ! -d $destdir.$i
		then
			destdir=$destdir.$i
			#remote_destdir=$remote_destdir.$i
			break
		else
			echo $destdir.$i exists already, moving on..
		fi
	done
fi

#assertion, more or less..
if test -f $destdir
then
    echo $0: Oh no, bug in script $destdir already exists. exit without copy
    exit 2
fi



RSYNC_CMD="rsync $RSYNC_EXCLUDE -a $VERB $workspace/ $destdir"

#RSYNC_CMD="rsync -a -v --progress $workspace $destdir"
#echo copy $workspace to $destdir. Hit return to continue

# echo '(nb. slash on end of source dir causes its contents to be copied to dest'
# echo ' hence, missing / on end of $workspace would create $destdir/$d'
# echo ' two // are okay)'

######################### optionally run local full  backup #############

cmd="$RSYNC_CMD $RSYNC_EXCLUDE_SAVE_SPACE"

echo about to run: $cmd
echo return to continue..

read  -t 30 -p '> ' junk ############# block on read ##########
echo running..
eval $cmd

du -sh $workspace
du -sh $destdir

echo -n dest look right? 
echo nb rsync may have excluded objdirs or something like that..

if test ! -z "$skip_remote"
then
	echo 'NB: remote backup skipped..'
else
	echo 'NB: command (*already*) run above to rsync to gsa account **was** :'
	echo $REMOTE_RSYNC_CMD
fi

echo
echo Hit return to close this window..
read junk

read -p 'waiting 60, just in case hit return too many times' -t 60 junk

exit 0
