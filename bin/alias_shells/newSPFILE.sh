#!/bin/sh

#create a new file containing where StudioPaint src files live.

> $HOME/SPFILE

find /usr/StudioPaint/src \
		\( -name *.[ch] -o -name *.style -o -name *.cpp -o -name *.bm \)\
		 -print \
> $HOME/SPFILE

