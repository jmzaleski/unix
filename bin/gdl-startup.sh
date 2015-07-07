#!/bin/bash

# matz starting the crawl immediately after login clogs disks up on laptop and slows down startup too much.
#
echo gdl-startup.sh begin >> /tmp/gdl-startup.log
echo who knows where this stdout goes..
echo who knows where this stdout goes.. >> /tmp/gdl-startup.log

date >> /tmp/gdl-startup.log
echo about to sleep..
sleep 600 
date >> /tmp/gdl-startup.log
echo awake from sleep. now start crawler. >> /tmp/gdl-startup.log

/opt/google/desktop/bin/gdlinux start ) &

date >> /tmp/gdl-startup.log
echo crawler has started.. >> /tmp/gdl-startup.log

echo gdl-startup.sh end >> /tmp/gdl-startup.log
echo ........................ >> /tmp/gdl-startup.log
