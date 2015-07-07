#!/bin/bash

#print sources

for i in $*
do
	if test ! -f $i
	then
		echo $0: cannot open $i
		exit 2
	fi
done

WIDTH=90

#enscript -2 sets double col
# -r rotates.
#this can be problematic to print, as you have to specify landscape as well

for i in $*
do
	/usr/bin/expand -4 $i | cat -n | fold -w $WIDTH | pr -F -e'	4' -w $WIDTH -h "$i"
done | /usr/bin/enscript -2 -r -p /tmp/mylpr$$.ps

echo lpr -S 192.168.0.7 -P 192_168_0_7 -o l "c:\cygwin\tmp"\\mylpr$$.ps 

lpr -S 192.168.0.7 -P 192_168_0_7 -o l "c:\cygwin\tmp"\\mylpr$$.ps 

#can also use ps2pdf and look with acrobat..

rm -f /tmp/mylpr$$.ps
