#! /usr/bin/perl
use strict;
use warnings;

# there should be two arguments in the command line
my $num_args = $#ARGV + 1;

if ($num_args != 1) {
	print("Usage: hw2.pl inputFile\n");
	exit;
}

my %count;
my $sum=0;

open (INPUTFILE,$ARGV[0])||die "Could not open the file $ARGV[0]";

# traverse each line of the input file and calculate the number of words
while(<INPUTFILE>)
{
	chomp;
	$_ =~ tr/[A-Z]/[a-z]/; 
	foreach my $word ($_ =~ /[a-z]+/g)
	{
		$count{$word}++;
		$sum++;
	}
}

close(INPUTFILE);
print("total number of words: $sum\n");

foreach my $word (sort keys %count)
{
	printf("%-20s %s\n",$word,$count{$word});
}