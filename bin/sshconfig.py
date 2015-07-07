#!/usr/bin/python
# -*- Mode: python; tab-width: 4; indent-tabs-mode: nil; py-indent-offset: 4 -*-

# present a cheesy text menu of hosts from my ~/.ssh/config file
# and ssh to the one selected.

import os,re,sys

print sys.argv

n=-1

if len(sys.argv) > 1 :
    print sys.argv[1]
    n = int(sys.argv[1])
    print n
else:
    print "no args.. prompt"

N=12

child = os.popen("grep -i ^host ~/.ssh/config | tail -" + str(N) )

map = {}

#could spiff this up to record the username and hostname also.

min = N+1
i = N
for line in child.readlines():
    #print "line=", line
    m = re.search('^Host\s*(?P<HOST>\S+)$', line)
    if m :
        hostname = m.group('HOST')
        map[i] = hostname
        min = i
        #print i, map[i]
        i -= 1
#print 'min=',min

err = child.close()
if err:
	raise RuntimeError, '%s failed w/ exit code %d' % (command, err)

#print map        

print
for ix in range(min,N+1):
    print "%3d. %s" % (ix,map[ix] )

if n < 0 :
    selection = raw_input("\nselect a host to ssh to: ")
else :
    selection = n
    
print selection

selected_host = map[int(selection)]
print "ssh to", selected_host

ssh_cmd = "ssh " + selected_host
#print "about to execute", ssh_cmd

os.system(ssh_cmd)

