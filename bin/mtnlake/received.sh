#!/bin/sh

REC=`date +received.%h%d.%Y`

if test ! -f received
then
		echo $0: sorry, received file must exist
		exit 2
fi

echo compress:
ls -l received
echo to: $REC.Z

mv received $REC
compress $REC
ls -l $REC.Z
