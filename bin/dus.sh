#!/bin/sh

#sort the du output

DU="du -msPx"

if test -z "$*"
then
	$DU * 
else
	$DU $*
fi | sort -n
