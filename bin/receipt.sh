#!/bin/bash

CUPS=~/junk/cups-pdf
REC=~/p/online-receipts
BILLS=~/p/online-bills

cd $CUPS

ls -ltr | tail -5

newest=`ls -tr *.pdf | tail -1`

echo cp $newest to:
dest=''

while test -z "$dest"
do
	echo --------
	echo b for $BILLS
	echo r for $REC
	echo --------

	dest=''

	read -p '> ' resp

	case $resp in
		[bB]*)
			dest=$BILLS
			;;
		[rR]*)
			dest=$REC
			;;

		*)
			dest=''
	esac
done

echo will to copy file: \"$newest\" to directory: \"$dest\"

echo NB. lastest files in destination are:
( cd $dest&& ls -ltr | tail -7 )

#read -e -p 'enter destination file name: ' fn

#echo hit return to execute: cp $newest $dest/fn

basenamepdf=`basename $newest`
basename=`basename $basenamepdf .pdf`
#echo $basename

proposed=`date +$dest/$basename-%h-%d-%y.pdf`

echo
echo hit return to execute the following command, or copy/paste and exec it yourself.
echo
echo cp    $CUPS/$newest        $proposed
echo

read -p '> '
/bin/cp    $CUPS/$newest        $proposed

ls -l $proposed


