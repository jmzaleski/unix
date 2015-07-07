#!/bin/ksh 

if test -f $HOME/.RMAIL.LCK
then
		echo $HOME/.RMAIL.LCK exists so not starting rmail.
		echo remove the file and try $0 again
		exit 42
fi

date >  $HOME/.RMAIL.LCK

xterm -ls 				\
	-n RMAILRMAIL -title RMAILRMAIL $XTERM_FLAGS 	\
	-geometry 90x40+0+30 \#-100+400\
	-e ~/bin/gmacs -q -l ~/dot.gmacs -f rmail

/bin/rm -f  $HOME/.RMAIL.LCK

