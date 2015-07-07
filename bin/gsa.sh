#!/bin/bash 

passwd=$1

if test -z "$passwd"
then
	read -p "type the ibm GSA password: " -s passwd
fi

#read -p "hit return to gsa login to tirnanog.... " junk	
echo trying command: ssh -t tirnanog  gsa_login -v -p -c yktgsa zaleski
echo $passwd | ssh -t tirnanog  gsa_login -v -p -c yktgsa zaleski

#read -p "hit return to gsa login to rios11lnx.... " junk
echo trying command: ssh -t  rios11lnx gsa_login -v -p -c yktgsa zaleski
echo $passwd | ssh -t rios11lnx gsa_login -v -p -c yktgsa zaleski
