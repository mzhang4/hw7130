#! /usr/bin/perl
use strict;
use warnings;

# there should be two arguments in the command line
my $num_args = $#ARGV + 1;

if ($num_args != 2) {
	print("Usage: hw1.pl inputFile outputFile\n");
	exit;
}
elsif($ARGV[0]eq$ARGV[1])
{
# if inputFile and outPutFile are the same, do nothing
	exit;
}

open (INPUTFILE,$ARGV[0])||die "Could not open the file $ARGV[0]";
open (OUTPUTFILE,">$ARGV[1]")||die "Could not open the file $ARGV[1]";

while(<INPUTFILE>)
{
	print OUTPUTFILE "$_";
}

close(INPUTFILE);
close(OUTPUTFILE);
