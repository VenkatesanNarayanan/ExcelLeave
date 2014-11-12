#!/usr/bin/perl -w

#
# daterange.pl
# Developed by Dharma  <dharma@exceleron.com>

use strict;

use DateTime;   

my $start = DateTime->new(day=>06,month=>11,year=>2014); # create two DateTime objects
my $end   = DateTime->new(day=>11,month=>11,year=>2014);


while ($start <= $end) {
	    print $start->day_of_week, "\n";
		    $start->add(days => 1);
		}
1;
