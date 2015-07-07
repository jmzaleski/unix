#!/bin/ksh 

#exec /bin/ksh -c "cd $HOME; . $HOME/.profile; \
#

#exec xterm -ls $XTERM_FLAGS -iconic -title gmacs \
#	-geometry 90x55+0+30 \#-0+0\
#	-e ~/bin/gmacs \
#	-load init-tag.el
#


#xterm -ls -title epoch $XTERM_FLAGS -iconic -geometry 90x55+0+30 \#-0+0 \
#	-e ~/epoch/epoch -load init-tag.el

cd /h/mzaleski

. ./.profile

/usr/gnu/lucid/bin/emacs -q -l ~/dot.emacs -geometry 90x54+0+30 -load ~/my-gmacs/init-tag.el
