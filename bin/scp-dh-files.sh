#!/bin/bash

# scp the args up to dreamhoster http://www.zaleski.files

f=$*
#
#should really basename each file here..
bn=""
for i in $f
do
	b=$(basename $i)
	bn="$bn $b"
done

set -x
scp $f dh:files/
set -

rf=""
for i in $bn
do
	rf="$rf files/$i"
done

set -x 
ssh dh chmod o+r $rf
ssh dh ls -l $rf
set -

echo ask collaborators to open browser to: http://www.zaleski.ca/files

open http://www.zaleski.ca/files &

echo $rf
read -p "if collaboarator is done, hit enter to remove files from files, o/w interrupt now to leave." junk

set -x 
ssh dh rm $rf
