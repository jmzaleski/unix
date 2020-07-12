#!/bin/bash

NET=192.168.1
GATEWAY=$NET.254
TESTHOST=www.ibm.com
READ="read -t 15"
CLEAR=clear

ifconfig | grep -C 3 $NET
echo '***********************************'
$READ -p 'ifconfig looks okay?' junk
$CLEAR

netstat -rn -f inet

echo '*********** prod chateau telus ISP ******************'
$READ -p 'netstat looks okay?' junk
$CLEAR

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
$READ -p 'ping looks okay?' junk
$CLEAR

if dig +time=1 $TESTHOST
then
	echo dns returns for $TESTHOST
else
	echo dns DOES NOT return for $TESTHOST. trying again with longer timeout..
	dig +time=10 $TESTHOST
	exit 1
fi

echo '***********************************'
$READ -p 'dns looks okay?' junk
$CLEAR

echo get / | telnet $TESTHOST 80

