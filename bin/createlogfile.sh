#!/bin/bash

FN=`logfilename.sh $1`
touch $FN
ls -ld $FN

