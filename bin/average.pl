#!/usr/bin/perl

package SP;

use strict;

#parse a raw data file with a bunch of perfex outputs and average the TSC
#and calculate stdev for a sense of how noisy..
#looks for TSC lines unless --event option is present.
#die "\$#ARGV=<$#ARGV>\n";

#command line options in like --min
use Getopt::Long;

my $fieldOpt = 1; #one origin fields (like awk) 
my $minOpt = 0;
my $fieldSepOpt = '\s+';

$SP::USAGE="Usage: $0 [--min] [--field=n] files..\n";

#crazy frigging language.
my %optctl = ( 
			  field => \$fieldOpt,
			  min => \$minOpt,
			  fieldSep => \$fieldSepOpt
			 );

&GetOptions(\%optctl, "field=i", "fieldSep=s", "min" );
if ( $#ARGV < 0 ) { die $SP::USAGE; }

$fieldOpt--; #perl likes zero origin, unix 1.

$SP::FIELDSEP=$fieldSepOpt;

sub doit;

printf "%-48s %2s %9s %9s  %9s %9s %9s%\n",
	"data_file_name_and_run_id",
    "N", "min", "mean", "geomMean",
    "stdev",
    "d/m";

for(my $i=0; $i<= $#ARGV; $i++){
  $SP::N=0;
  $SP::mean=0.0;
  $SP::geomMean = 0.0;

  # deviations..
  $SP::dev=0.0;

  my $fni = $ARGV[$i];

  &doit( $fni, $fieldOpt );

  #report Mean or min? That is the question..
  my $num = $minOpt ? $SP::min : $SP::mean;

  my $F="%#9.3g";

  printf "%-48s  %2i $F $F $F $F $F%%\n",
	      $fni,
		  $SP::N, 
		  $SP::min, $SP::mean, $SP::geomMean,
		  $SP::dev,
		  ($SP::dev/$SP::mean) * 100;

}

########################################
#average/stdev of the values in a column of the file

sub doit {
  my ($fn, $field) = @_;

  open(PERFEXFILE,"<$fn") || die "cannot open file $fn\n";

  my ($n) = 0;
  my ($min) = 1.0e38; #i dunno what the max float is in perl. 3 times this in ieee
  my ($tsc2) = 0.0; #2 connotes tsc squared.
  my $logProd = 0.0;

  while ( <PERFEXFILE>) {
	my $data;
	my $event;
	my @line = split /$SP::FIELDSEP/ ;
	$field > $#line  && die "hey, is no field number $field in: ", $_ ;
	my $dat = $line[$field] + 0.0;
    print "\$($field+1)=$dat\n";
	$SP::mean += $dat;
	$logProd += log( $dat );
	$tsc2 +=  ($dat * $dat);
	if ($dat < $min ) {
	  $min = $dat;
	}
	$n++;
  }
  $SP::N = $n;
  #means..
  $n > 0 || die "hey, no data in $fn???";
  $tsc2 >0 || die "hey, no squared data in $fn??";
  $SP::mean /= $n;
  $SP::min = $min;
  $SP::geomMean = exp( $logProd / $n );

#  print "tsc2 =$tsc2\n";  my ($rm2 );  $rm2 =  $SP::mean * $SP::mean; print "mean squared $rm2\n";

  #deviations..
  my $var = ($tsc2 - $n * $SP::mean * $SP::mean)/($n - 1) ;

  if ( $var > 0 ) {
	$SP::dev= sqrt ( $var );
  }else{
	#bah whose idea was it to program this myself, anyway.
	if ( ($var / $SP::min) < 0.01 ) {
#	  printf stderr "dev negative but negligible. likely underflow\n";
	  $SP::dev= 0.0;
	} else {
	  print "n=$n\n";
	  print "tsc2=$tsc2\n";
	  printf '$SP::mean * $SP::mean=%e'."\n", $SP::mean * $SP::mean;
	  printf '$n * $SP::mean * $SP::mean)=%e'."\n", $n * $SP::mean * $SP::mean;
	  die "var is negative, can't take sqrt? in file $fn."
	}
  }

}#doit

########################################

