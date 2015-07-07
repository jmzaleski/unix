#!/bin/bash

if test -z "$SSH_AUTH_SOCK"
then
    echo need to have an authentication agent, eh?;
    echo try:
	echo eval `ssh-agent`
	exit 2
fi

#I didn't expect it to work like this. I thought the 
#command below would make a tunnel only from sb-sys to kreider.

#could take this from arguments, even.

DEST_PORT=5901
TUN_PORT=5942

echo -n hit ret for tunnel from qew:$TUN_PORT to kreider:$DEST_PORT
read junk
ssh -A -f qew "ssh -A -f -L $TUN_PORT:kreider:$DEST_PORT sb-sys sleep 360000" 

# hence I thought I'd have to do this also
# echo -n hit ret for tunnel from qew to sb-sys/cowher:
# read junk
# ssh -A -f -L $TUN_PORT:sb-sys:$TUN_PORT qew sleep 360001

echo -n hit return for tunnel from here:$TUN_PORT to qew:$TUN_PORT
read junk
ssh -A -f -L $TUN_PORT:localhost:$TUN_PORT qew sleep 360002

lsof -l | grep ^ssh | grep TCP | grep $TUN_PORT

echo okay, go nuts against $TUN_PORT


