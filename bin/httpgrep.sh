#!/bin/sh

#grep matz /var/log/httpd/access_log.1 | grep -v 66.11.164.17 > /tmp/jmz$$
#cat /var/log/httpd/access_log.1 | grep -v 66.11.164.17 > /tmp/jmz$$

awk '{print $1}' < /var/log/httpd/access_log.1 | sort | uniq 


