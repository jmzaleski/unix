#!/bin/bash

cd ~/j9

#assumes that j9vc7env.sh or some-such has established environment.

#just a buch of stuff to build j9 once C has bee spat out

./j9-hack-makefile.sh

#echo go fer it?
#read junk

cp j9.ico j9build/include

pwd

cd ./j9build

pwd

nmake

ls -l j9.exe

