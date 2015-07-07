#!/bin/bash

cd ~/j9

#just a buch of stuff to build j9 once C has bee spat out

./j9-hack-makefile.sh

cp j9.ico j9build

. ./j9vc7env.sh

cd j9build

nmake

