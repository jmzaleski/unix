#!/bin/bash

#do cvs stuff to psa website.
#args are cvs commands which will be executed with pwd as root of psa site

DIR=public_html/psa
CMD="cvs $*"

if cd $DIR
then
	echo $0: current working dir is: `/bin/pwd`
	echo $0: execute $CMD
else
	echo $0: '<error>' could not cd to $DIR
	exit 2
fi

if exec $CMD
then
	echo $0: exit code good from $CMD
else
	echo $0: '<error>' bad exit code from $CMD
	exit 2
fi

