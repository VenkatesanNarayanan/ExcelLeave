#!/usr/bin/perl -w
# EncounterHolidays.pl
#
# Developed by Girish Walvekar <girish@exceleron.com>
# Copyright (c) 2014 Exceleron Inc

use Moose;
use namespace::autoclean;
use Data::Dumper;
use Date::Simple('date', 'today');
use DateTime;


my $from_date = '2014-12-28';
my $to_date = '2015-01-02';

my @spl_holidays =['2014-12-03','2014-10-19','2014-10-20','2015-01-01'];

my ($frm_yy,$frm_mm,$frm_dd) = split('-',$from_date);

my ($to_yy,$to_mm,$to_dd) = split('-',$to_date);


print my $diff = date('2014-10-27') - date('2014-09-29')."\n";

if(date('2014-10-27') > date('2014-09-29')) {
	print "yes\n";
}
else {
	print "no\n";
}

my $start = DateTime->new(
	day   => $frm_dd,
	month => $frm_mm,
	year  => $frm_yy,
);

my $stop = DateTime->new(
	day   => $to_dd,
	month => $to_mm,
	year  => $to_yy,
);


while ( $start->add(days => 1) <= $stop ) {
	printf "Date: %s\n", $start->ymd('-');
}

