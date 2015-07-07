#!/bin/sh

#back up all the files in a directory into a tar file

EXT=tarz
TAR_COPT=-cvzf
TAR_TOPT=-tvzf

case $# in
    1)
    tarfile=`date +backup.%h%d`
    ;;
    2)
    tarfile=`date +$2.%h%d`
    ;;
    *)
    echo 'usage: dir [tarfileBaseName]'
    exit 2
    ;;
esac


if test ! -d $1
then
	echo "$1 not a directory. Exit with no backup"
	exit 2
fi

#look for a safe tar file name

if test ! -f $tarfile.$EXT
then
	tarfile=$tarfile.$EXT
else
	for i in a b c d e f g h i j k l m n o p q r s t u v w x y z
	do
		if test ! -f $tarfile.$i.$EXT 
		then
			tarfile=$tarfile.$i.$EXT
			break
		else
			echo $tarfile.$i.$EXT exists already, moving on..
		fi
	done
fi


#assertion, more or less..
if test -f $tarfile
then
    echo $0: Oh no, bug in script $tarfile already exists. exit without copy
    exit 2
fi

#how come not tar -cvzf $tarfile $1 > $tarfile.list ??

echo "about to execute tar $TAR_COPT $tarfile $1"
if tar $TAR_COPT $tarfile $1
then
	ls -l $tarfile
else
	echo returns failure: tar $TAR_COPT $tarfile $1
	echo no backup done!
	exit 2
fi

if tar $TAR_TOPT $tarfile > $tarfile.list
then
	ls -l $tarfile.list
else
	echo returns failure:  tar $TAR_TOPT $tarfile 
	echo no list of backup done
	exit 3
fi

exit 0
