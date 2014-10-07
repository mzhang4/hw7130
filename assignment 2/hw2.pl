#! /usr/bin/perl
use strict;
use warnings;

use WWW::Mechanize;
use LWP::Simple;
use HTML::Parser;
use CAM::PDF;

#count, hash table to store the words and the frequency
my %count; 
#countFile, for each word, count how many files it has this word
my %countFile;
#sum, # of words
my $sum=0;
#my %hashWord;
my $url = "http://www.cs.memphis.edu/~vrus/teaching/ir-websearch/";
parser_html($url);

# parse the links in the home page
my $mech = WWW::Mechanize->new();
$mech->get($url);

#go through each link and parse the html or the pdf
my @links = $mech->links();
for my $link ( @links ) {
	my $linkType = $link->text; 
	if($linkType eq 'Recommended' || $linkType eq 'Assignment 1' || $linkType eq 'Assignment 02' || $linkType eq 'Assignment 03')
	{
		parser_html($url.$link->url);
	}
	elsif($linkType eq "Vasile Rus"||$link->url eq "http://tartarus.org/~martin/PorterStemmer/")
	{
		parser_html($link->url);
	}
	elsif(index($link->url,'pdf')!=-1)
	{
		my %hashWord = ();
		my $i;
		my $pdfContent;

		my $file = 'data.pdf'; 
		getstore($url.$link->url, $file);
		my $pdf = CAM::PDF->new($file) || die "$CAM::PDF::errstr\n";
		for ($i=1; $i <= $pdf->numPages();$i++) 
		{			
			$pdfContent =$pdfContent.$pdf->getPageText($i);
		}

		$pdfContent =~ s/<.*?>//gs;
		$pdfContent =~ s/&nbsp;//g;
		$pdfContent =~ s/&amp;//g;
		$pdfContent =~ s/&gt;//g;
		$pdfContent =~tr/[A-Z]/[a-z]/; 

		foreach my $word ($pdfContent =~ /[a-z]+/g)
		{
			$count{$word}++;
			if(not exists $hashWord{$word})
			{
				$hashWord{$word} = "1";
				$countFile{$word}++;
			}
			$sum++;
		}
	}
}

print("total number of words: $sum\n");
foreach my $word (sort keys %count)
{
	printf("%-20s %s %s\n",$word,$count{$word},$countFile{$word});
}

sub parser_html
{
	my ($text) = @_;
	my ($html) = get($text);
	my (%hashWord) = ();

	$html =~ s/<.*?>//gs;
	$html =~ s/&nbsp;//g;
	$html =~ s/&amp;//g;
	$html =~ s/&gt;//g;
	$html=~tr/[A-Z]/[a-z]/; 

	foreach my $word ($html =~ /[a-z]+/g)
	{
		$count{$word}++;
		if(not exists $hashWord{$word})
		{
			$hashWord{$word} = "1";
			$countFile{$word}++;
		}
		$sum++;
	}
}