#!/bin/sh

smbmount "\\\matzhm0\MATZHM0-C" \
	9202340 -U matz -I 192.168.0.2 \
	-c 'mount /home/matz/smb -u 500 -g500'


