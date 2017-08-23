#!/usr/bin/python
# -*- Mode: python; tab-width: 4; indent-tabs-mode: nil; py-indent-offset: 4 -*-

# kill off process named by arg

import os,re,sys

#print sys.argv
if len(sys.argv) != 2 :
    print "usage: " + sys.argv[0] + " string to search for amongst ps output"
    sys.exit(2)

ps_cmd   = "ps -Af"    
grep_cmd = "grep -e " + sys.argv[1]

print grep_cmd

child = os.popen(ps_cmd + " | " + grep_cmd )

map = {}
i = 0

for line in child.readlines():
    if re.search('kill.py', line) or re.search(grep_cmd, line):
        continue;
    map[int(i)] = line
    print "line=", map[i]
    i += 1

err = child.close()
if err:
	raise RuntimeError, '%s failed w/ exit code %d' % (command, err)

if i == 0 :
    print "nothing to kill because no interesting processes match", sys.argv[1]
    sys.exit(0)

n = i

if i == 1 :
    selection = 0
else:
    #print "menu"
    for ix in range(0,n):
        print "%3d. %s" % (ix,map[ix] )
    selection = raw_input("\nprocess to kill: ")

selected_line = map[int(selection)]
    
        
#print "selected line", selected_line

m = re.search('\s(?P<PID>\d+)\s.*$', selected_line)
if m :
     pid = m.group('PID')
     print "kill:", selected_line
     cmd = "kill -9 " + pid
     print pid, cmd
     junk = raw_input(cmd + ": ")
     os.system(cmd)
     

