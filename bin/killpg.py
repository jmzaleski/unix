#!/usr/bin/python

import os, sys

if len( sys.argv ) != 2 :
    print "usage: sys.argv[0] pgid #sends signal 9 to process group pgid"
    exit(0)

os.killpg( int(sys.argv[1]), 9 )
