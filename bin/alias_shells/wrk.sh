#!/bin/ksh
cd $HOME

. ./.profile

xterm -ls -fn fixed	\
	-geometry 40x20-0-10 \#-0+600 \
	-title WRK \
	-e  $HOME/bin/gmacs \
	~/wrk/wrk.paint

###	-funcall split-window-vertically ~/wrk/wrk.render

