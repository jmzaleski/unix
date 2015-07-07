#!/bin/bash

# convert all .png files listed on command line to .jpeg files
# if there isn't one already

files="*.png"

for f in $files
do
  base=`basename "$f" .png`
  pfile="$base".png
  if test ! -f  "$pfile"
  then
	  echo oh oh no file "$base".png giving up
	  exit 2
  fi
done


for f in $files
do
  base=`basename "$f" .png`
  pfile="$base".png
  jfile="$base".jpg
  if test ! -f "$jfile"
  then
	  echo converting $pfile to $jfile
	  pngtopnm "$pfile" | pnmtojpeg > "$jfile"

  else
	  echo skip converting $pfile because $jfile already exists..
  fi
done
