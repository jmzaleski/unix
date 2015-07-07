#!/bin/bash

# start matz X up from command line.

#xmodmap ~/.xmodmap-linux

echo '*********** start **************' >> startday.log 2>&1
date  >> startday.log 2>&1
echo '********************************' >> startday.log 2>&1

echo starting emacs.sh 
nohup emacs.sh >> startday.log 2>&1 &

echo sleep 10 then start sametime..
sleep 10

echo sametime
nohup sametime  >> startday.log 2>&1 &

echo sleep 60 then start thunderbird
sleep 60

echo thunderbird >> startday.log 2>&1 &
echo started thunderbird

nohup ~/build/thunderbird/thunderbird  >> startday.log 2>&1 &

echo sleep 15 then start firefox..
sleep 15

echo firefox
nohup firefox -P matz0  >> startday.log 2>&1 &

echo sleep 30 thens tart notes
sleep 30

echo ibm-notes8
nohup ibm-notes8  >> startday.log 2>&1 &


echo '************* end **************' >> startday.log 2>&1
date  >> startday.log 2>&1
echo '********************************' >> startday.log 2>&1

tail -30 startday.log
echo see:
ls -l `/bin/pwd`/startday.log 
echo for details.

