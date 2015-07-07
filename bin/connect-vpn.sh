#!/bin/bash

echo unsetting the proxy env vars..

set -x
unset -v http_proxy  https_proxy ftp_proxy GIT_PROXY_COMMAND socks_proxy UBUNTU_MENUPROXY  no_proxy

#my .kenv seems to mess up the wrapper script
unset BASH_ENV

openconnect \
	-c ~mathewza/.cert/certificate.p12  \
	--script /etc/vpnc/vpnc-script  \
	--cafile ~mathewza/.cert/intel-certchain.crt \
	--key-password 36dab7442fa26bb6 \
	--user=mathew.zaleski@intel.com \
	vpn.intel.com


#	192.55.54.27 
