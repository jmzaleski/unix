#!/usr/bin/perl

$success = 0;

while (<>) {
        if (/rewind/) { next; }
        ($junk,$junk,$junk,$junk,$junk,$junk,$junk,$host,$cksum,$size) = split (/\s+/, $_); 
        if (/backup/) {
                $data{$host} = "$cksum $size";
        } elsif (/verify/) {
                if ($data{$host} eq "$cksum $size") {
                        $success++ unless ("$cksum $size" eq "1104454823 10240");
                }
        }
}

if ($success < scalar(values(%data))) {
        print "FAILURE\n";
} else {
        print "SUCCESS\n";
}
