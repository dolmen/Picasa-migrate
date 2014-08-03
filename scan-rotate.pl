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

#say "[$_]" for @files;


my $section;

foreach my $file (@files) {
    open my $f, '<:crlf', $file or die "$file: $!";

    while (<$f>) {
	chomp;
	next unless length $_;
	if (/^\[(.*)\]/) {
	    $section = $1;
	    next;
	} else {
	    my ($name, $value) = /^(.*?)=(.*)/ or next;
	    if ($name eq 'rotate' && $section =~ /\.JPG$/i) {
		$value =~ /\((.*)\)$/ or die "unexpected rotate value '$value'";
		my $angle = (360 + $1 * 90) % 360;
		say "$angle $section";
	    } 
	}
    }
    close $f;
}


# vim:set et ts=8 sw=4 sts=4:
