#!/usr/bin/perl

require 'sys/socket.ph';
$sockaddr = 'S n a4 x8';
chop($hostname = `hostname`);

($name, $aliases, $proto) = getprotobyname('tcp');
$port = 4242;					# must match number in Network3.java
$thisport = pack($sockaddr, &AF_INET, $port, "\0\0\0\0");

socket(S, &PF_INET, &SOCK_STREAM, $proto) || die "cannot create socket\n";

bind(S, $thisport) || die "cannot bind socket\n";

for (;;){
	print "listen for a client connection\n";
	listen(S,5) || die "cannot listen socket";
	accept(NS,S) || die "cannot accept socket";
	&forkedToServe;
	}

sub forkedToServe{
	if (fork){
		return;					# nothing more to do in parent thread
	}
	print "new child about to accept the socket\n";
	for ($i=0;$i<4;$i++){
		print "forkedToServe about to read from socket\n";
		$s =  <NS>;
		print "forkedToServe read from socket: $s\n";
		print "forkedToServe read from socket: $s\n";
		print NS "foo\n";
		print NS "foo\n";
		print "forked to Serve wrote \"foo\" to socket\n";
	}
	close NS;
	return
}


