#!/bin/bash

VPNCLIENT=/private/opt/cisco-vpnclient/bin/vpnclient

ldapPasswd=xxxxxxx

if test -z "$ldapPasswd"
then
	read -p "type the adobe LDAP password: " -s ldapPasswd
fi

read -p 'enter dongle token password:' donglePasswd

if test -z "$donglePasswd"
then
	echo try again. need the dongle password to do anything.
	exit 2
fi

passwd="$ldapPasswd$donglePasswd"
echo $passwd

#   sleep 1 > /dev/null

(
#	echo skip vpnclient dev..
set -x
 echo y | $VPNCLIENT connect sj user mzaleski pwd $passwd
set -
) &

echo  \"vpnclient disconnect\" to disconnect

#sleep 5
sleep 1; echo -n 5.. ;sleep 1; echo -n 4.. ;sleep 1; echo -n 3.. ;sleep 1; echo -n 2.. ;sleep 1; echo -n 1.. ;

echo wait a bit for vpn to work in background..

echo
echo '***********************************************'
$VPNCLIENT stat traffic
echo '***********************************************'
echo

read -t 5 -p "look at the vpn output.. if looks good hit return to go ahead with adobe ssh authn.." junk

	BASTION=eon 
	LP=8025
	SH=smtp.gmail.com
	CMD="while echo -n connected to $BASTION on' '; do date; sleep 5; done"
	#open https://waltham-ssh-out.corp.adobe.com/ 
	open https://sanjose-ssh-out.corp.adobe.com/
	read -t 10 -p "now ssh tunnel local port $LP to SH port 25 via bastion host $BASTION" junk 
	ssh -vv -X -A -L $LP:$SH:25 $BASTION $CMD

#http://curl.haxx.se/docs/manual.html
#doesn't work yet..
set -x
#URL='https://sanjose-ssh-out.corp.adobe.com/?target=&auth_id=&ap_name=' 

URL='https://sanjose-ssh-out.corp.adobe.com'

curl --trace-ascii /tmp/curl.trace -k -F "login=login" -F username=mzaleski -F password=$passwd $URL > /tmp/curl-ssh-$$.html

open /tmp/curl-ssh-$$.html
set -


echo smtp tunnel here..

echo leave shell running or vpnclient connection will die.
echo '(if the vpn connection was from the gvpndialer then okay to exit this process)'

read -p 'return to exit.. ' junk

echo sleeping 600 to see vpnclient errors and warnings after connections are dropped..
sleep 600



# curl -k https://sanjose-ssh-out.corp.adobe.com/ | findform.pl
# 
# --- FORM report. Uses POST to URL "/?target=&auth_id=&ap_name="
# Input: NAME="login" VALUE="login" (HIDDEN)
# Input: NAME="username" (INPUT)
# Input: NAME="password" (PASSWORD)
# Button: "Log In" (SUBMIT)
# --- end of FORM

# <html>
# <head>
# <title>User Authentication : Log In - Juniper Networks Web
# Authentication
# </title>
# </head>
# <form name="login" method="post"
#     action="https://sanjose-ssh-out.corp.adobe.com/?target=&auth_id=&ap_name="
#     id="login_form">
# <input type="hidden" name="login" value="login"/>
#   <table border="0" cellspacing="0" cellpadding="3" id="login_table">
# 	<tr>               <td class="bold" align="right">Username: </td>
# 	<td>                 <input class="small" type="input"
# 	name="username" size="10" id="username" value="mzaleski"/>               </td>
# 	</tr>             <tr>               <td class="bold"
# 	align="right">Password: </td>               <td>
# 	<input class="small" type="password" name="password" size="10"
# 	id="password"/>               </td>             </tr>
# 	<tr>               <td class="center">                 <input
# 	type="submit" value="Log In" id="login"/>               </td>
# 	<td class="center">                 <input type="reset"
# 	value="Reset" id="reset"/>               </td>             </tr>
# 	<tr>               <td colspan="2">                 <div
# 	class="red-foreground bold center"></div>               </td>
# 	</tr>
#   </table>
#   </body> </html>
