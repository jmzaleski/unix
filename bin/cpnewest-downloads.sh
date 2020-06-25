#!/bin/bash

if test -z "$1"
then
	dest="./"
else
	dest="$1"
fi

newest=$(ls -dtr /Users/mzaleski/Downloads/* | tail -1)

ls -l "$newest"

read -p "hit enter to cp $newest to $dest" junk

set -x 
/bin/cp -i "$newest" "$dest"
set -

#indot=$(basename "$newest")
#ls -l "$indot"

ls -l $dest

