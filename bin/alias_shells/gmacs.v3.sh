#!/bin/ksh 

#exec /bin/ksh -c "cd $HOME; . $HOME/.profile; \


#exec xterm -ls $XTERM_FLAGS -iconic -title gmacs \
#	-geometry 90x55+0+30 \#-0+0\
#	-e ~/bin/gmacs \
#	-load init-tag.el
#

xterm -ls -title gmacsV3 $XTERM_FLAGS -iconic -geometry 90x55+0+30 \#-0+0 \
	-e gmacs -load init-tag-v3.el
