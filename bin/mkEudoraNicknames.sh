#!/bin/sh

# passwd file $1 is login id on locon
# $5 is full name

#
grep :14: /etc/passwd | grep -v ^P | grep -v ^S | \
 awk -F : \
 '{printf "alias \"%s\" %s@mtnlake.com\nnote \"%s\" <name: %s>\n" ,$5, $1, $5, $5}' \
> mtnlake.txt

grep :24: /etc/passwd | grep -v ^P | grep -v ^S | \
 awk -F : \
 '{printf "alias \"%s\" %s@mtnlake.com\nnote \"%s\" <name: %s>\n" ,$5, $1, $5, $5}' \
> mtnmisc.txt

grep :26: /etc/passwd | grep -v ^P | grep -v ^S | \
 awk -F : \
 '{printf "alias \"%s\" %s@mtnlake.com\nnote \"%s\" <name: %s>\n" ,$5, $1, $5, $5}' \
> office.txt
