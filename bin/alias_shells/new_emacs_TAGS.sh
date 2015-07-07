#!/bin/sh

cd /h/mzaleski

#read in development environment which the following hacky scripts depend on.

SHELL=/bin/sh
. ./.profile

cd /h/mzaleski/my-gmacs/c++-browse/

./buildSP_tags.sh

