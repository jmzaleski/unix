#!/bin/bash

# suppose kvm running on cdf workstation b3175-01.cdf.toronto.edu with port open on 5902
# DEST_HOST=b3175-01.cdf.toronto.edu
# DEST_PORT=5902
# LOCAL_TUNNEL_PORT=9002


# example
# locally:                                                 on cdf ws machine
# ssh -nNT -L 9002:localhost:9000 wolf.cdf.toronto.edu     ssh -nNT -R 9000:localhost:5900 cdf
#             ^^^^           ^^^^                                      ^^^^
#       this port listens    ^^^^                                       port listens on wolf
#       locally              ^^ 

# a bit simpler:

# need to make two ssh tunnels,
# 
# a-cdf-ws ----------------------> gateway (cdf/wolf) ------------------> my workstation

# locally:                                                 on wolf:
# ssh -nNT -L 9002:localhost:9000 wolf.cdf                      ssh -nNT -L 9000:localhost:5901 ws.cdf

# simplest concrete example
# ssh cdf "ssh -nNT -L 9000:localhost:5901 b3175-01.cdf.toronto.edu" #tunnel from wolf to ws
# ssh -nNT -L 9000:localhost:9000 wolf.cdf.toronto.edu               #tunnel from here to wolf

# drat, but chickenofthevnc forces me to choose local ports close in number to 5900
# ssh cdf "ssh -nNT -L 9999:localhost:5901 b3175-01.cdf.toronto.edu" #tunnel from wolf to ws
# ssh -nNT -L 5942:localhost:9999 wolf.cdf.toronto.edu               #tunnel from here to wolf

# now vnc understand local tunnel as :42

echo '$#=' $#

if test $# -lt 2
then
	echo usage: $0 local-tunnel-port cdf-ws.cdf.toronto.edu '[cdf-ws-port]'
	echo e.g. $0 5942  b3175-01 5901
	exit 2
else
	TUN_PORT=$1
	DEST_HOST=$2
	DEST_PORT=$3
	XX_PORT=$4
fi	

if test -z "$XX_PORT"
then
	XX_PORT=9942
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

# -A      Enables forwarding of the authentication agent connection.
# -f      Requests ssh to go to background just before command execution. 
# -L tunnel

set -x
ssh -A -f -L $TUN_PORT:localhost:$TUN_PORT cdf \
   "ssh -A -f -L $TUN_PORT:$DEST_HOST:$DEST_PORT $DEST_HOST sleep 360000" 
set -

echo local lsof
set -x
lsof -l | grep ^ssh | grep TCP | grep $TUN_PORT
set -

echo remote lsof
set -x
ssh cdf "lsof -l | grep ^ssh | grep TCP | grep $TUN_PORT"
set -

echo "~." | telnet localhost  $TUN_PORT 

echo if looks weird, might need to clean up like: "lsof -l | grep ^ssh | grep TCP | grep :59 | awk '{print $1}'"

echo okay, go nuts against $TUN_PORT


