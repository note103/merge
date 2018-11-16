#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';
use File::Slurp;
use File::Basename 'basename';

my $pwd = '.';
my $regex = qr/(txt|md)/;
my $no_title = 0;

if (@ARGV) {
    for (@ARGV) {
        if ($_ =~ /(txt|md)/) {
            $regex = $1;
        }
        elsif ($_ =~ /(-nt|--no-title)/) {
            $no_title = 1;
        }
    }
}

my @files = grep {/.+\.($regex)/} glob "$pwd/*";
for my $remove (@files) {
    if ($remove =~ /merged.txt$/) {
        @files = grep {$_ ne $remove} @files;
    }
}

my @merge;

if ($no_title == 0) {
    push @merge, "# merged:\n";
    push @merge, basename "$_\n" for @files;
    push @merge, "- - -\n";
}

for (@files) {
    push @merge, "\n# ".basename $_.":\n" if ($no_title == 0);
    push @merge, read_file($_);
}

write_file('merged.txt', @merge);
