#!/bin/bash

#diff files in the directories for reference..
echo diff $newDropDir..
#-I skips the revision number and date CVS variables

diff -x '*.~*' -x '.#*' -I '\* \$Revision.*$\|\* \$Date: 2005-01-11 15:54:16 $' -r --brief $1 $2
