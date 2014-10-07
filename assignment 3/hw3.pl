#HW3 By Minsheng Zhang
#!/usr/bin/perl
# perl hw4.pl input_file_foldername stopwords_file
use warnings;
use strict;
use porter;

if ($#ARGV != 1) {
  die "Usage: $0 input files directory  $1 stop words file\n";
}

my (%h, $filename);
my $dirname = $ARGV[0];
my @stops;
#read all the stop words
open(STOPWORD,$ARGV[1])|| die "cannot open the stopword file\n";

while(<STOPWORD>)
{
  chomp;
  push @stops, $_;
}

my %stops = map{$_ => 1} @stops;
close STOPWORD;

#read each file under the folder dirname
opendir (DIR, "$dirname/")|| die "Error in opening dir $dirname\n";

my $outdir = "$dirname/result";
mkdir $outdir unless -d $outdir; # Check if dir exists. If not create it.

while (($filename=readdir(DIR))){
     
     if(index($filename,".txt")!=-1)
     {
        open (FILE, "$dirname/".$filename)|| die "can not open the file $filename\n";
        open (OUT, ">"."$dirname/"."result/$filename.bak")|| die "can not open the $filename.bak\n";

        #pre process line by line in each file.
        while (<FILE>){
            chomp;
            $_ =~ s/[[:punct:]]//g;
            my @words = grep { $_ } split /[0-9_>!|#:* (.,)%&~\n\t\/\-\[\]]/, $_;
            foreach my $word(@words){
                chomp $word;
                $word =~ tr/[A-Z]/[a-z]/; 
                $word = '' if exists $stops{$word};
                $word = '' if index($word, 'httpwww') != -1;
                $word = porter($word);
                $word = '' if exists $stops{$word};

                if($word ne ''){
                  print OUT $word;
                  print OUT ' ';
            }
          }

        }
     }
         
    close(FILE);
    close(OUT);
}