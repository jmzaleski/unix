#!/bin/bash -e

# problem: iphoto represented albums as symlinks to files.
# LightRoom ignores the symlinks (perhaps because they are duplicates)
# two strategies I see:

# 1. if willing to lose all the file NOT in albums. (probably am)
# preserves album directory structure

# replace the symlinks with hard copies of the files in the album structure.
# then use exif to insert a keyword into each remaining image file naming the album
# then can remove the "original" pictures.

# 2 keep the originals, lose the duplicate album dir structure

# follow the symlinks, using test -L  and realink and drop keywords directly
# in image file that are targets of symlinks.
# then can remove the duplicate symlink tree structure.

# there's an awful lot of garbage photos there, and 
# losing facial recognition will make them pretty useless.
# though maybe one day lightroom will start to do facial sorting too.

date > ALBUMLIST

for album in $*
do
	if test ! -d "$album"
	then
		echo skip non dir $album
		continue
	fi
	(
	ls -ld "$album"
	cd "$album"
	for img in *.JPG
	do
		if test -L "$img"
		then
			img_file=`readlink "$img"`
		else
			img_file="$img"
		fi
		if test ! -f "$img_file"
		then
			echo skip $img_file
			continue
		fi
		cmd='exiftool -keywords+='$album" $img_file"
		echo $album >> ../ALBUMLIST
	    if eval $cmd
		then
			echo $cmd returns 0
		else
			echo $cmd returns non 0. kill
			kill $$
		fi
		exiftool -s -a -G1 "$img_file" > /tmp/exif$$
		if grep IPTC /tmp/exif$$ 
		then
			echo gotit
		else
			echo error did not find IPTC in metadata of $img_file
			kill $$
			break
			exit 2
		fi
	done
	)
done
