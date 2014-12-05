#!/usr/bin/perl -w

#
# trail.pl
# Developed by Dharma  <dharma@exceleron.com>

use strict;

my $ref=[];

print ref($ref),"\n";

$ref=1;
if(ref($ref) eq '')
{
	print ref($ref),"\n";
}

1;
