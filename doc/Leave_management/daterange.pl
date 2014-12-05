#!/usr/bin/perl -w

#
# daterange.pl
# Developed by Dharma  <dharma@exceleron.com>

use strict;
use DateTime;   
use Date::Simple;
use Data::Dumper;

=podmy $start = DateTime->new(day=>06,month=>11,year=>2014); # create two DateTime objects
my $end   = DateTime->new(day=>11,month=>11,year=>2014);


while ($start <= $end) {
	    print $start->day_of_week, "\n";
		    $start->add(days => 1);
		}
=cut
my $date=Date::Simple->new('2014-12-01');

$date++;

$date=DateTime->new(day=>01,year=>2014,month=>12);
$date->add(days => 1);


print Dumper $date->ymd;


1;
