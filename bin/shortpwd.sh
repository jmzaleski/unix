#!/bin/bash

pwd=`/bin/pwd -P`

echo $pwd

echo $pwd | sed -e 's;/Users/mzaleski/;~/;'


