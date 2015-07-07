#!/bin/sh

#echo tunnel imap to 8143
#echo tunnel smtp to 8025

ssh -f -L 8143:localhost:143 -L 8025:localhost:25 l0.zaleski.ca sleep 3600
echo imap tunnel on 8143 and smtp on 8025
