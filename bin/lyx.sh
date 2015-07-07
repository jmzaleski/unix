#!/bin/sh
#
#trap "echo hello; exit" 2
#nohup lyx -geometry 600x940-50+20 > ~/lyx.log 2>&1 & 
#echo tail ~/lyx.log
#tail -f ~/lyx.log
#

xterm  -geometry 80x24-500+630 -e lyx -geometry 850x980-15+5 &
