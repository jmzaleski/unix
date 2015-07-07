#!/bin/bash

TMPFILE=/tmp/cvslog_raw.txt
TMPFILEa=/tmp/cvslog_raw_fn.txt
TMPFILEb=/tmp/cvslog_raw_num.txt
TMPFILEc=/tmp/cvslog_raw_c.txt
REV=1.2

#cvs log wants to list all the files and tell us the number of revisions that 
#are selected by the arguments (query) on the log command line.
#There must be an option that just prints the selected files but I don't know what it
#is. Hence, proceed by brute force.

#example of what comes out of log:

# RCS file: /e/matz/CVS.md/j9build/makefile,v
# Working file: makefile
# head: 1.2
# branch:
# locks: strict
# access list:
# symbolic names:
# 	R22_j9_win_x86-32_20040120_0102: 1.1.1.1
# 	TRJIT: 1.1.1
# keyword substitution: kv
# total revisions: 3;	selected revisions: 1
# description:
# ----------------------------

#so we have to find all the stanzas that have more than one selected revision
#I guess I could have sed'd the input to make each stanza into a line or something also.

echo cvs log -r$REV: into $TMPFILE

cvs log -r$REV: > $TMPFILE

echo RCS files into $TMPFILEa
echo selected revisions into $TMPFILEb

grep "^RCS file:" $TMPFILE > $TMPFILEa
grep "selected revisions:" $TMPFILE > $TMPFILEb

echo pr $TMPFILEa $TMPFILEb and grep only those with selected revisions: not equal to 0

echo $TMPFILE $TMPFILEa $TMPFILEb  $TMPFILEc

pr --join-lines --merge --omit-pagination $TMPFILEa $TMPFILEb > $TMPFILEc

grep -v "selected revisions: 0" $TMPFILEc


ls -l $TMPFILE $TMPFILEa $TMPFILEb  $TMPFILEc
rm -i $TMPFILE $TMPFILEa $TMPFILEb   $TMPFILEc
