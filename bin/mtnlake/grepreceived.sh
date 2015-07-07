#!/bin/sh

cd ~/Mail

out=/tmp/out.$$

for i in received.*.Z
do
	echo --- $i ---- | tee -a $out
	zcat $i | grep $* | tee -a $out 
done

echo
echo
echo -- now page through $out ---
echo
echo

more $out

echo
echo
echo -- remove the logfile\? --
echo
echo
rm -i $out
