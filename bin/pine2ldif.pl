#!/usr/bin/perl

use Text::ParseWords;

#pine addressbook syntax:
#<nickname>TAB<fullname>TAB<address>TAB<fcc>TAB<comments>
#also, a space at the beginning of a line makes it a continuation line from above

#TODO
#pine lists not handled.
#continuation lines not handled (hacked by hand by editing away with emacs first)

#sample diagnostic output from below
#words[0]=<nickname>
#words[1]=<Surname GivenName>
#words[2]=<userid@internetdomain.xxx>

#  dn: mail=a1@domain.com
#  cn: A1 A2
#  mail: a1@domain.com

# beware, I don't really understand the implications of simpifying the
# directory to the point I have here. Consider that a full addressbook record is like:

#  dn: cn=Dan Astoorian,mail=djast@cs.toronto.edu
#  modifytimestamp: 20010208182924Z
#  cn: Dan Astoorian
#  mail: djast@cs.toronto.edu
#  xmozillausehtmlmail: FALSE
#  givenname: Dan
#  sn: Astoorian
#  xmozillauseconferenceserver: 0
#  objectclass: top
#  objectclass: person

# main problem here is that pine doesn't distinguish between given and sn so we either guess or skip it.
# the palmpilot does, of course, so some of these entries will be dumbed down by their
#passage through the pine addressbook.

#
# now read the data and convert to ldif
#
while( <STDIN> )
{
	$record = $_;
	chop $record; ##take newline out of last record (email address) ### won't happen when email not last field!
	@words = &parse_line("\t", 0, $record );

###	$i=0; foreach( @words ){ print "words[$i]=<$words[$i]>\n"; $i++; } ##diagnostic output..

	$name = $words[0] . " " . $words[1] . " " . $words[2]; #last name first (like in palm pilot)
	print "dn: cn=".$words[1].",mail=".$words[2]."\n";
	print "cn: ".$words[1]."\n";
	print "mail: ".$words[2]."\n";
	print "xmozillanickname: ".$words[0]."\n\n";

	if ( 0 )
	{
	$email = $words[3];
	$nick = "oops";
	$n = index $record, "@";
	if ( $email eq "" && $n >= 0 )
	{
		print "gak\n";
		print "name=<$name>\n";
		print "record=<$record>\n";
		print "email=<$email>\n";
		$i=0; foreach( @words ){ print "words[$i]=<$words[$i]>\n"; $i++; }
		die "oops, something wrong in parse";
	}
	if ( $email ){
		@emailAddress = &parse_line("@",0, $email );
		$user = $emailAddress[0];
		$host = $emailAddress[1];
		if ( ! $host ){
			print "no host for email address ", $email, "\n";
		} else {
#			print "nick=", $user, " name=", $name, " email=", $email, "\n";
			print "$user\t$name\t$email\n";
		}
	}
}
}
	

#now pipe this | tr \\t : | sort -f -t : +2 
