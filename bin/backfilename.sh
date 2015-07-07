#!/bin/sh

#concoct a file file name for a backup file..

EXT=back

case $# in
    0)
    tarfile=`date +backup.%h%d_%y`
    ;;
    1)
    tarfile=`date +$1.%h%d_%y`
    ;;
    *)
    echo 'usage: $0 [tarfileBaseName]'
    exit 2
    ;;
esac

#look for a safe tar file name

if test ! -f $tarfile
then
	tarfile=$tarfile
else
	for i in a b c d e f g h i j k l m n o p q r s t u v w x y z
	do
		if test ! -f $tarfile.$i
		then
			tarfile=$tarfile.$i
			break
		else
			echo $tarfile.$i exists already, moving on.. > /dev/null
		fi
	done
fi


#assertion, more or less..
if test -f $tarfile
then
    echo $0: Oh no, bug in script $tarfile already exists. exit without copy
    exit 2
fi

echo $tarfile
exit 0
