#!/bin/bash

if test -z "$1"
then
	echo assume port 2000 as none given on command line
	port=2000
else
	port=$1
fi
	

NETSTAT_LINE=`netstat  -l -n -p  | grep :$port` 2> /dev/null

echo '******** netstat output *********'
echo NETSTAT_LINE: $NETSTAT_LINE
echo '******** end netstat output *********'

PID=`echo $NETSTAT_LINE  | awk '{print $7 }' | sed -n 's;/java.$;;p'`

#PID=`netstat  -l -n -p 2> /dev/null | grep :$port  | awk '{print $7 }' | sed -n 's;/java.$;;p'`

if test -z "$PID"
then
	echo nobody waiting on port $port to kill..
	exit 0
fi

ps -aux 2>/dev/null | grep $PID | grep -v grep

echo -n hit return to kill: $PID :
read junk


for pid in $PID
do
  echo send -9 to kill $pid
  kill -9 $pid
done

