#!/bin/bash

addr=`ifconfig utun0 | tail -1 | cut -d' ' -f 2 `
port=5900
url="vnc://$addr:$port"
echo $url
echo testing...
set -x
telnet $addr 5901 < /dev/null

echo $url
