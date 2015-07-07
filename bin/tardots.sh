#!/bin/sh

dotfiles=''

cd
for i in .*
do
	if test -d $i
	then
		continue
	fi
	if test ! -s $i
	then
		continue
	fi
	case $i in
	.save* )
		;;
	*~)
		;;
	*)
		dotfiles=$dotfiles" "$i
		;;
	esac
done

#echo will back up: $dotfiles

tarfile=`date +dots.%h%d`

if test ! -f $tarfile.tar
then
	tarfile=$tarfile."tar"
else
	for i in a b c d e f g h i j k l m n o p q r s t u v w x y z
	do
		if test ! -f $tarfile.$i.tar
		then
			tarfile=$tarfile.$i.tar
			break
		else
			echo $tarfile.$i.tar exists already, moving on..
		fi
	done
fi

if test -f $tarfile
then
		echo $0: Oh no, bug in script $tarfile already exists. exit without copy
		exit 2
fi

echo about to execute: tar -cvf $tarfile $dotfiles
tar -cvf $tarfile $dotfiles
tar -tvf $tarfile > $tarfile.list
ls -l $tarfile $tarfile.list
