#!/bin/sh

h=`hostname -s`
files=`ls -d .* | grep -v '^\.FBCIndex$\|^\.Trash$\|^\.$\|^\.\.$'`

m0rolltar.sh $files dots.$h/dots.$h

