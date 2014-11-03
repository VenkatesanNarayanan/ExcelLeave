#!/usr/bin/perl -w

#
# csvreader.pl
# Developed by Dharma  <dharma@exceleron.com>

use strict;
use Parse::CSV;
use Data::Dumper;

my $simple = Parse::CSV->new(
	file => 'SystemData.csv',
);

while ( my $array_ref = $simple->fetch ) {

	print "@{$array_ref}\n";
}

1;
