#!/usr/bin/perl

use strict;
use warnings;

# Reads in TMX files.
my $input_directory = "sample-files";
my $input_file      = "1en-1fr.tmx";

my $output_directory = "output-files";
my $output_file      = "out.pdf";

open IN, "<$input_directory/$input_file" or die "Failed to open IN: $!\n";

while ( <IN> )
{
    next unless ( $_ =~ /<tuv/ );
    
    my $current_line = $_;
    $current_line =~ s/\R//g;
    my $language = $current_line;
    $language =~ s/ *?<tuv xml:lang="([A-Z]{2})".*$/$1/; # Remove everything around language code.
    # print $language . "\n";
    
    # Change quotation marks to TeX standard.
    $current_line =~ s/“/``/;
    $current_line =~ s/”/''/;
    
    # Strip excess.
    $current_line =~ s/.*<seg>(.*)<\/seg>.*/$1/;
    
    if ( $language eq "EN" )
    {
        print $current_line . "\n";
    }
}

close IN;
