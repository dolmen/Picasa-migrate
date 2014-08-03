#!/usr/bin/env perl

use 5.010;
use strict;
use warnings;

use JSON::XS;

my @files = @ARGV;
if (! -t 0) {
    binmode(STDIN, ":utf8");
    push @files, <STDIN>;
    chomp @files;
}

say "[$_]" for @files;


my $section;
my %entries;

foreach my $file (@files) {
    open my $f, '<:crlf', $file or die "$file: $!";

    while (<$f>) {
	chomp;
	next unless length $_;
	if (/^\[(.*)\]/) {
	    $section = $1;
	    if ($section =~ /.(JPG|MOV)$/i) {
		$section = uc $1;
	    }
	    next;
	} else {
	    my ($name, $value) = /^(.*?)=(.*)/ or next;
	    #$entries{$section}{$name} //= { files => [] };
	    #push @{ $entries{$section}{$name}{files} }, $file;
	    $entries{$section}{$name}++;
	}
    }
    close $f;
}

say JSON::XS->new->ascii->canonical->pretty->encode(\%entries);

# vim:set et ts=8 sw=4 sts=4:
