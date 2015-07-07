#!/bin/ksh 

cd /h/mzaleski

. ./.profile

export EDITOR=emacsclient

xterm -geometry 80x50-200+30 \#-0+500 -title nnnnnnnnnn -ls -e nn &
