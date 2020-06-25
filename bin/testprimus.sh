#!/bin/bash

GATEWAY=192.168.1.1
TESTHOST=www.ibm.com

ifconfig
echo '***********************************'
read -t 3 -p 'ifconfig looks okay?' junk

netstat -rn -f inet

echo '***********************************'
read -t 3 -p 'netstat looks okay?' junk

if ping -c 2 -W 10 $GATEWAY
then
	echo $GATEWAY is okay
else
	echo cannot ping $GATEWAY
	echo try: "sudo ifconfig en0 down && sudo ifconfig en0 up"
	cmd="sudo ifconfig en0 down && sudo ifconfig en0 up"
	read -p "hit return to execute: $cmd" junk
	$cmd
	exit 2
fi

echo '***********************************'
read -t 3 -p 'ping looks okay?' junk

if dig +time=1 $TESTHOST
then
	echo dns returns for $TESTHOST
else
	echo dns DOES NOT return for $TESTHOST. trying again with longer timeout..
	dig +time=10 $TESTHOST
	exit 1
fi

echo '***********************************'
read -t 3 -p 'dns looks okay?' junk

echo get / | telnet $TESTHOST 80

