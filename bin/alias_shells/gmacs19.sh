#!/bin/ksh 

cd /h/mzaleski

. ./.profile

##better to move the load of the  init tag thing past the 
##the load of the .emacs files and then set the loadpath correctly
##and use require functions.
##

/usr/local/gnu-emacs19/bin/emacs \
                        -font -adobe-courier-medium-r-normal-*-17-* \
                        -geometry 90x54+0+30 \
			-load ~/my-gmacs/lisp/matz/init-tag.el \
                        -load ~/.emacs      \
                        $*

