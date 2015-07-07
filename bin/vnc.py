#!/usr/bin/python
# -*- Mode: python; tab-width: 4; indent-tabs-mode: nil; py-indent-offset: 4 -*-

# present a cheesy text menu of hosts from map in this file
# and vnc to the one selected

# need to know two things about each destination
# 1) hostname
# 2) destination port number
# 3) any special vnc options

# be nice to extend this to do it securely, namely create an ssh tunnel to
# the destination host as well.

list = [
    ("zaleski@tirnanog",   "tirnanog.watson.ibm.com",     "5902", "-shared" , "foobar" ),
    ("zaleski@rios11",     "rios11lnx.watson.ibm.com",    "5902", "" ,       "foobar" ),
    ("zaleski@xp",         "zaleski-xp.local.zaleski.ca", "5900", "" ,       "foobar" ),
    ("zaleski@cb45",       "cb45.watson.ibm.com",         "5901", "" ,       "foobar" ),
    ("alex@douala",        "9.2.211.65",                  "5901", "-shared" ,"foobar" ), #foobar
    ("kevin@tirnanog",     "tirnanog.watson.ibm.com",     "5901", "-shared" ,"iseult" ), #iseult
    ("SEZ",                "sez.local.zaleski.ca",        "5900", ""        ,"foobar" ),
    ("JEZ",                "jez.local.zaleski.ca",        "5900", ""        ,"foobar" ),
    ("zehra@asterix",      "asterix.watson.ibm.com",      "5901", "-shared" ,"passw0rd" ),
    ]

map = { }

ix = 0
for l in list :
    map[ix] = l
    ix += 1

import os,re,sys

print sys.argv

n=-1

if len(sys.argv) > 1 :
    print sys.argv[1]
    n = int(sys.argv[1])
    print n
else:
    print "no args.. prompt"

N=10


#print map        

print

for ix in map.keys() :
    print "%3d) %-20s %-40s %-5s %s %s" % (ix, map[ix][0], map[ix][1], map[ix][2], map[ix][3], map[ix][4] )

#for ix in map.keys() :
#    print ix, map[ix]


#for ix in range(1,N+1):
#    print "%3d. %s" % (ix,map[ix] )

if n < 0 :
    selection = raw_input("\nselect a host:port to vnc to: ")
else :
    selection = n
    
print selection

selected_host = map[int(selection)][1]
port = map[int(selection)][2]
vnc_options = map[int(selection)][3]
print "vnc to", selected_host, 'with vnc options', vnc_options, 'at port', port

vnc_cmd = "vncviewer " + vnc_options + " " + selected_host + ":" + port
print "vnc.py about to os.system command:", vnc_cmd

os.system(vnc_cmd)

