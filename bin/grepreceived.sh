#!/bin/sh

cd ~/Mail/historicMail

out=/tmp/out.$$

#how to do this but swallow the banner if no match??
for i in *.Z
do
	echo --- $i ---- >> $out
	echo -n $i
	zcat $i | grep -i $* | tee -a $out 
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


