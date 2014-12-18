#!/usr/bin/perl

use strict;
use warnings;

# CLI options:
# --input-file (required): the name of the input file
# --output-file: if specified, the output file will be named according to the option here; otherwise, the output file will be named the same as the input file.
# --left-lang (required): the two-letter code of the input language.
# --right-lang (required): the two-letter code of the output language.
# --help: this will display a help prompt. If the required fields are not entered, this will be displayed.

if ( $#ARGV < 2 and $ARGV[0] !~ /--help/ )
{
    print_error_and_exit("Syntax error: not enough arguments.\n\n");
}

my $DEBUG = 0;
my $input_file;
my $output_file;
my $no_output_file_specified = 1;
my $left_lang;
my $right_lang;

foreach my $arg (@ARGV)
{
    if ( $arg =~ /--input-file=/ )
    {
        $input_file = $';
        next;
    }
    elsif ( $arg =~ /--output-file=/ )
    {
        $output_file = $' . ".tex";
        $no_output_file_specified = 0;
        next;
    }
    elsif ( $arg =~ /--left-lang=/ )
    {
        $left_lang = uc($');
        print_error_and_exit("Syntax error: incorrect left-lang.\n\n") if ( length($left_lang) != 2 );
        next;
    }
    elsif ( $arg =~ /--right-lang=/ )
    {
        $right_lang = uc($');
        print_error_and_exit("Syntax error: incorrect right-lang.\n\n") if ( length($right_lang) != 2 );
        next;
    }
    else
    {
        print_help();
        exit;
    }
}

# Catches if there's no user-specified output file and defaults to "output-files/out-[name of input file].tex"
if ( $no_output_file_specified )
{
    my $input_file_prefix = $input_file;
    $input_file_prefix =~ s/([^.]+).+$/$1/;
    $input_file_prefix =~ s/[^\/]+\/(.+)/$1/;
    $output_file = "output-files/out-" . $input_file_prefix . ".tex";
}

# Sample files.
# $input_file = "sample-files/1en-1fr.tmx";
# $input_file = "sample-files/2en-2fr.tmx";

open IN, "<$input_file" or die "Failed to open IN: $!\n";
open OUT, ">$output_file" or die "Failed to open OUT: $!\n";

print_tex_header();

my $both_sides_printed = 0;

while ( <IN> )
{
    next unless ( $_ =~ /<tuv/ );
    
    my $current_line = $_;
    $current_line =~ s/\R//g;
    
    my $language = $current_line;
    $language =~ s/ *?<tuv xml:lang="([A-Z]{2})".*$/$1/; # Remove everything around language code.
    
    # Change quotation marks to TeX standard.
    unicode_to_tex($current_line);
    check_unicode_to_tex() if $DEBUG;
    
    # Strip excess.
    $current_line =~ s/.*<seg>(.*)<\/seg>.*/$1/;
    
    if ( $language eq $left_lang )
    {
        print OUT "    \\ParallelLText{$current_line}\n";
        $both_sides_printed++;
    }
    else
    {
        print OUT "    \\ParallelRText{$current_line}\n";
        $both_sides_printed++;
    }
    
    if ( $both_sides_printed == 2 )
    {
        print OUT "    \\ParallelPar\n";
        $both_sides_printed = 0;
    }
}

close IN;

print_tex_footer();

close OUT;

`pdflatex -halt-on-error -output-directory=output-files/ $output_file`;

# Change Unicode characters to TeX format.
sub unicode_to_tex
{
    $_[0] =~ s/“/``/g;
    $_[0] =~ s/”/''/g;
    $_[0] =~ s/’/'/g;
    $_[0] =~ s/â/\\^a/g;
    $_[0] =~ s/à/\\`a/g;
    $_[0] =~ s/é/\\'e/g;
    $_[0] =~ s/ç/\\,c/g;
    $_[0] =~ s/è/\\`e/g;
    $_[0] =~ s/ê/\\^e/g;
    $_[0] =~ s/ï/\\"i/g;
    $_[0] =~ s/î/\\^i/g;
    $_[0] =~ s/ô/\\^o/g;
    $_[0] =~ s/œ/\\oe\{\}/g;
    $_[0] =~ s/ù/\\`u/g;
    $_[0] =~ s/û/\\^u/g;
    $_[0] =~ s/«/\\og/g;
    $_[0] =~ s/»/\\fg\{\}/g;
    $_[0] =~ s/À/\\`A/g;
    $_[0] =~ s/É/\\'E/g;
    $_[0] =~ s/—/---/g;
    $_[0] =~ s/…/\\dots /g;
}

sub print_tex_header
{
    print OUT "\\documentclass{article}\n";
    print OUT "\\usepackage[margin=1in]{geometry}\n";
    print OUT "\n";
    print OUT "\\usepackage[frenchb]{babel}\n";
    print OUT "\\usepackage{parallel}\n";
    print OUT "\n";
    print OUT "\\begin{document}\n";
    print OUT "\n";
    print OUT "\\begin{Parallel}{0.48\\textwidth}{0.48\\textwidth}\n";
}

sub print_tex_footer
{
    print OUT "\\end{Parallel}\n";
    print OUT "\n";
    print OUT "\\end{document}\n";
}

sub print_help
{
    print "USAGE:\n";
    print "    --input-file (required): the relative or absolute path of the input file\n";
    print "    --output-file: if specified, the output file will be named according to the\n";
    print "      option here; otherwise, the output file will be named the same as the\n";
    print "      input file. Do not include a file extension. The file will automatically\n";
    print "      be saved in output-files so don't specify a different directory.\n";
    print "    --left-lang (required): the two-letter code of the input language.\n";
    print "    --right-lang (required): the two-letter code of the output language.\n";
    print "    --help: this will display a help prompt. If the required fields are not\n";
    print "      entered, this will be displayed.\n";
    print "\n";
    print "Example: wrapper.pl --input-file=sample-files/1en-1fr.tmx --left-lang=en --right-lang=fr\n";
    print "Example: wrapper.pl --input-file=sample-files/2en-2fr.tmx --left-lang=fr --right-lang=en --output-file=foo\n";
}

sub print_error_and_exit
{
    print $_[0];
    print_help();
    exit;
}

sub check_unicode_to_tex
{
    $current_line =~ s/[A-Za-z\\'`<>:= "-^\/\{\}]//g; # Removes all letters and escaped diacritical marks.
    print $current_line; # If nothing is printed, this worked. Remember to turn off DEBUG.
}
