#!/usr/bin/perl -w

#
# datecomapre.pl
# Developed by Dharma  <dharma@exceleron.com>

use strict;
use DateTime;
use Data::Dumper;

my $dt1=DateTime->new(year=>2014,month=>12,day=>03);
my $dt2=DateTime->today();

my $cmp=DateTime->compare($dt1,$dt2);

print $cmp,"\n";
1;
