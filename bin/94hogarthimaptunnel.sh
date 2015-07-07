#!/bin/sh

#echo tunnel imap to 8143
#echo tunnel smtp to 8025

ssh -L 8143:localhost:143 -L 8025:localhost:25 ll0
