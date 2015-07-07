#!/bin/sh

if test $# -le 2
then
	echo usage: $0 token-old token-new files
	exit 42
fi

token=$1
token2=$2
shift
shift

echo replace $token with $token2

for i in $*
do
	if test ! -f $i
	then
		echo $0 cannot find $i skip
	fi
	TERM=dumb ex $i <<!
%s/\<$token\>/$token2/gp
w
q
!
done
