#!/bin/bash

passwd=xxx

if test -z "$passwd"
then
	read -p "type the ibm password: " -s passwd
fi

echo $passwd

#   sleep 1 > /dev/null

(
	(
		sleep 2
		echo mzaleski@ca.ibm.com
		sleep 1
		echo  $passwd
		sleep 5
		echo y
	) | vpnclient connect TORVPN-mzaleski  
) &

echo wait a bit for vpn to work in background..
sleep 5
sleep 1; echo -n 5.. ;sleep 1; echo -n 4.. ;sleep 1; echo -n 3.. ;sleep 1; echo -n 2.. ;sleep 1; echo -n 1.. ;

echo  \"vpnclient disconnect\" to disconnect

echo
echo '***********************************************'
vpnclient stat traffic
echo '***********************************************'
echo

read -t 10 -p "look at the vpn output.. if looks good hit return to go ahead with gsa_login.." junk

echo trying command: ssh -t tirnanog  gsa_login -v -p -c yktgsa zaleski

echo $passwd | ssh -t tirnanog  gsa_login -v -p -c yktgsa zaleski

#read -p "hit return to gsa login to rios11lnx.... " junk
#echo trying command: ssh -t  rios11lnx gsa_login -v -p -c yktgsa zaleski
#echo $passwd | ssh -t rios11lnx gsa_login -v -p -c yktgsa zaleski

echo '***********************************************'
vpnclient stat traffic
echo '***********************************************'

echo $passwd | gsa_login -v -p -c yktgsa zaleski
echo $passwd | gsa_login -l -p 


read -p "hit return to startday" junk
~/bin/startday.sh

echo leave shell running or vpnclient connection will die.
echo '(if the vpn connection was from the gvpndialer then okay to exit this process)'

read -p 'return to exit.. ' junk

echo sleeping 600 to see vpnclient errors and warnings after connections are dropped..
sleep 600
