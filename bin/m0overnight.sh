#!/bin/sh

#TODO
#rewrite in perl with table of directories
#write df disk space remaining procedure.
#write error messages proc onto stderr (die in perl)

BACKUPS=/home/backups/overnight

PROG=/home/matz/bin/rolltar.sh
LOW=250000

#
#catch pretty well everything and print out a message and exit.
#the goal here is that the mail/log message is telling.
#
#should really break this up into phases and clean up appropriately for
#each phase. i.e. blow away the tarfile and the list file, etc
#

TRAP_SIGS="2 3 4 6 8 11 13 14 15"
TRAP_CMD='echo '$0': signal caught. backups aborted ; exit 1' 
trap "$TRAP_CMD" $TRAP_SIGS

#how do i get this to go to stderr??
die(){
	echo $0: '******' $*
	echo $0: '************ error code returned, a backup failed.'
	echo $0: '************ subsequent backups were NOT performed.'
	exit 3
	# should list subsequent backups!
}

verbmsg(){
	if test ! -z "$DEBUG"
	then
		echo $*
	fi
}

set `df $BACKUPS | grep /home`
AVAIL=$4

if test $AVAIL -lt $LOW
then
	echo $0: '******************************************'
	echo $0: '*' less than $LOW left in /home
	echo $0: '******************************************'
fi

#directory directory  tarfilename
#************************************************************************
TABLE="
/home/matz/p              ZaleskM                palmBack  \
/home/matz/p     		  quicken  			     quicken   \
/home/matz/p     		  quickenShare		     quickenShare   \
/home/matz       		  myRCS    			     matzRCS   \
/home/matz       		  MyPilot  			     MyPilot   \
/home/matz       		  .gnome   			     dot.gnome \
/home            		   hfe     			     hfemail"
#************************************************************************

#likely want line for current working dir like:
#/home/matz/skule 		   csc2502 			     csc2502   \


#slightly weird stuff in this shift/set business. There always is a blank
#left on the end of the string, hence rather than shift failing we parse $1
#to be an empty string on the last run through the loop

#
# check the table without doing anything dangerous
#

echo $0
echo '---------------------------------------------'
set junkArg1 $TABLE

while shift && test ! -z "$1"
do
	cddir=$1;	bdir=$2;	tfn=$3; shift; shift
	echo $cddir/$bdir to file $BACKUPS/$tfn.tarz
	if cd $cddir
	then
		verbmsg `pwd`
	else
		die "cannot cd to $cddir"
	fi
	if test ! -d $bdir
	then
		die "no directory $bdir"
	fi
done
echo '---------------------------------------------'
echo

verbmsg the directories listed in the backup table appear to exist.

set junkArg1 $TABLE
while shift && test ! -z "$1"
do
	cddir=$1;	bdir=$2;	tfn=$3; shift; shift
	echo '---------------------------------------------'
	echo $cddir /  $bdir to $tfn
	if cd $cddir
	then 
		verbmsg  backup `pwd` 
	else 
		die "cannot cd to $cddir"
	fi
	################# doit ###############################
	if $PROG $bdir $BACKUPS/$tfn
	then
		verbmsg '================================================='
		verbmsg  $0: $PROG $bdir $BACKUPS/$tfn returns okay
#		verbmsg '================================================='
	else
		#is this right? Why not press on and attempt further backups?
		#what if /backup is full?
		die returns non-zero $PROG $bdir $BACKUPS/$tfn
	fi		
done

df -H $BACKUPS





