#!/bin/bash

NET=192.168.1
GATEWAY=$NET.254
TESTHOST=www.ibm.com
READ="read -t 15"
CLEAR=clear

#echo '*********** prod chateau telus ISP ******************'

echo '******** ifconfig | grep ' $NET '***************************'
ifconfig | grep -C 3 $NET
$READ -p 'ifconfig looks okay?' junk
$CLEAR

echo '*********** netstat.. ******************'
netstat -rn -f inet

$READ -p 'netstat looks okay?' junk
$CLEAR

echo '************ ping ' $GATEWAY '# (telus router) ***********************'
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

$READ -p 'ping looks okay?' junk
$CLEAR

echo '*********** dig' $TESTHOST '************************'
if dig +time=1 $TESTHOST
then
	echo dns returns for $TESTHOST
else
	echo dns DOES NOT return for $TESTHOST. trying again with longer timeout..
	dig +time=10 $TESTHOST
	exit 1
fi
$READ -p 'dns looks okay?' junk
$CLEAR

echo '*********** telnet 80' $TESTHOST '************************'
echo get / | telnet $TESTHOST 80

