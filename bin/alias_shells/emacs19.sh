#!/bin/ksh 

cd /h/mzaleski

. ./.profile

/h/mzaleski/emacs19/emacs19 -q -l ~/dot.emacs19 -geometry 90x54+0+30 \
							-load ~/my-gmacs/lisp/matz/init-tag.el
