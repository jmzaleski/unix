#!/bin/sh

if test -z "$1"
then 
	echo "must give  destination nt or bsd"
	exit
fi

dest=$HOME/ph/alias/$1

if test ! -d  $dest
then
	echo sorry, $dest does not exist
	exit
fi

for i in *
do
	echo --- $i ---
	pixtoppm $i | cjpeg > $dest/$i.jpeg
done
