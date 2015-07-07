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
	print "new child about to read from socket\n";
	$line = "";
	$f="/usr/matz/public_html/auto.html";
	$flg = 0;

	until( $line =~ /^ <from> / ){

		print "forkedToServe about to read from socket\n";
		$line =  <NS>;
		print "forkedToServe read from socket: $line\n";

		if ( $line =~ /\<HTML\>/ ){
			print "opening $f TO WRITE\n";
			open(HTMLFILE, ">$f");
			$flg++;
		}

		if ( $flg != 0 ){
			print "forkedToServe writes to $f: $line\n";
			print HTMLFILE $line;
		}

		if ($flg && ($line =~ /\<\/HTML\>/ ) ){
			close HTMLFILE;
			$flg =0;
		}
	}
	close HTMLFILE;
	close NS;
	return
}


