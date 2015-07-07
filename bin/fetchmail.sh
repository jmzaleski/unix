#!/bin/sh

#every couple of minutes fetch mail from home. See crontab also

#(
	echo -n `date +%r `
	fetchmail -f ~/mzaleski/dots/dot.fetchmailrc.izaleski-sympatico
#) >> ~matz/maillog 2>&1 
