#!/bin/bash

echo '$#=' $#

if test $# -lt 2
then
	echo usage: $0 tunnelPort destHost destPort
	echo e.g. $0 5942 kreider 5901
	exit 2
else
	TUN_PORT=$1
#	DEST_HOST=192.168.70.37
	DEST_HOST=$2
	DEST_PORT=$3
fi	

echo tunnel local port $TUN_PORT to remote port $DEST_HOST:$DEST_PORT

if test -z "$SSH_AUTH_SOCK"
then
    echo need to have an authentication agent, eh?;
    echo try:
	echo eval `ssh-agent`
	exit 2
fi

#I didn't expect it to work like this. I thought the 
#command below would make a tunnel only from sb-sys to kreider.

#echo -n hit ret for tunnel from localhost:$TUN_PORT to $DEST_HOST:$DEST_PORT
#read junk
echo ssh tunnel from localhost:$TUN_PORT to $DEST_HOST:$DEST_PORT
echo don\'t worry too much if the second half of the tunnel is still up.
echo the kreider to qew portion often stays up.

set -x
ssh -A -f -L $TUN_PORT:localhost:$TUN_PORT qew \
   "ssh -A -f -L $TUN_PORT:$DEST_HOST:$DEST_PORT sb-sys sleep 360000" 
set -

# hence I thought I'd have to do this also
# echo -n hit ret for tunnel from qew to sb-sys/cowher:
# read junk
# ssh -A -f -L $TUN_PORT:sb-sys:$TUN_PORT qew sleep 360001

# echo -n hit return for tunnel from here:$TUN_PORT to qew:$TUN_PORT
# read junk
# set -x
# ssh -A -f -L $TUN_PORT:localhost:$TUN_PORT qew sleep 360002
# set -

lsof -l | grep ^ssh | grep TCP | grep $TUN_PORT

echo okay, go nuts against $TUN_PORT


