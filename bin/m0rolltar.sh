#!/bin/sh

#back up all the files in a directory into a tar file, reusing tar files
#in a cycle.

EXT=tarz

#tar create archive options
TAR_COPT=-czf

#tar table (list) archive options
TAR_TOPT=-tvzf

#tar diff archive options
TAR_DOPT=-dzf

verbmsg(){
	if test ! -z "$DEBUG"
	then
		echo $*
	fi
}

die(){
   #how do I get that echo onto stderr??
	echo $0: '******' $* 
	exit 3
	# should list subsequent backups!
}

case $# in
    0)
    echo 'usage: $0 dir [tarfileBaseName]'
    exit 2
	;;
    1)
	files=$1
    fnStem=`basename $1`
	verbmsg use basename of first arg as archive name '<'$fnStem'>'
    ;;

    *)
	#look for last argument
	j=$1
	shift
	for i in $*
	do
		files="$files $j"
		j=$i
	done
	fnStem=$j
	echo files=$files
	echo fnStem=$fnStem
    ;;
esac

latest=$fnStem.latest

ffiles=""
for i in $files
do
	if test ! -L $i
	then
		ffiles=$ffiles" $i"
	fi
done

echo ffiles=$ffiles
files=$ffiles

for i in $files
do
	if test ! -r $i
	then
		echo "$i does not exist. Exit with no backup"
		exit 2
	fi
done

echo files=$files

#look for a safe tar file name

fileToUse=''
	
### make fnStem a function??

## k l m n o q r s t u v w x y z 

for i in a b c d e f g h i j 
do
	testfile=$fnStem.$i.$EXT 
	if test ! -f $testfile
	then
		fileToUse=$testfile
		break
#	else
		verbmsg $testfile exists already, moving on..
	fi
done

#
#catch pretty well everything and print out a message and exit.
#the goal here is that the mail/log message is telling.
#
#should really break this up into phases and clean up appropriately for
#each phase. i.e. blow away the tarfile and the list file, etc
#
TRAP_SIGS="2 3 4 6 8 11 13 14 15"
TRAP_CMD='echo '$0': signal caught. rolltar aborted writing '$fileToUse'; exit 1' 
trap "$TRAP_CMD" $TRAP_SIGS


##here fileToUse is either first filename in the sequence that
#is as yet unused or else zero length in which case we roll the oldest

#okay, so all the names have been used. We have to find the oldest one..
if test -z $fileToUse
then
	verbmsg all file names exist so will have to find oldest of:
#	ls -ltr $fnStem.[a-z].$EXT 
    #sort oldest first and take first hit..
    oldest=`ls -tr $fnStem.[a-z].$EXT | sed 1q`
	verbmsg oldest file name matching pattern $fnStem.'[a-z]'.$EXT is: $oldest
	##assertion that this is a file..
	if test ! -f "$oldest"
	then
		die '<' $oldest '>' is not a file, something wrong..
	fi
	tarfile=$oldest
	verbmsg echo roll to $tarfile as all other files of form $tarfile.'[a-z]'.$EXT in use
	verbmsg roll to $tarfile
else
	tarfile=$fileToUse
	verbmsg echo all files of sequence as yet unused. create $tarfile
fi

#how come not tar -cvzf $tarfile $files > $tarfile.list ??

if test -L $latest
then
	verbmsg check for new files
	NEW_FILES=`find $files -newer $latest -print`
	if test -z "$NEW_FILES"
	then
		verbmsg no new files, so:
		verbmsg check if filesystem is same as latest backup..
		verbmsg tar $TAR_DOPT $latest $files
		if tar $TAR_DOPT $latest $files > /dev/null
		then
			echo '*****' NO TAR because no new files AND dir $files same as `file $latest`
			verbmsg '*****' exit 0 from rolltar pretending the backup was done..
			exit 0
		else
			verbmsg file system differs from $latest so continue with tar
		fi
	else
		echo new files exist in $files..
		verbmsg find -newer $latest finds:
		verbmsg $NEW_FILES
	fi
fi
	
verbmsg "about to execute tar $TAR_COPT $tarfile $files"
if tar $TAR_COPT $tarfile $files
then
	ls -l $tarfile > /dev/null
else
	die returns failure: tar $TAR_COPT $tarfile $files
fi

if tar $TAR_TOPT $tarfile > $tarfile.list
then
	ls -l $tarfile.list > /dev/null
else
	die '****** ' returns failure:  tar $TAR_TOPT $tarfile 
fi

if test -f $tarfile && test -f $tarfile.list
then
	echo $tarfile '(and .list)' written without error
else
	echo '*****' cannot find $tarfile or $tarfile.list
	exit 4
fi

if test -L "$latest"
then
	rm $latest
fi

verbmsg create latest link..
ln -s $tarfile $latest
verbmsg `ls -l $latest`

exit 0
