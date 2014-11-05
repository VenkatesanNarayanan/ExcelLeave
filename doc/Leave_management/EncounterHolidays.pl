#!/usr/bin/perl -w
# EncounterHolidays.pl
#
# Developed by Girish Walvekar <girish@exceleron.com>
# Copyright (c) 2014 Exceleron Inc

use Moose;
use namespace::autoclean;
use Data::Dumper;



my $from_date = '2014-10-17';
my $to_date = '2014-10-27';

my @spl_holidays =['2014-10-03','2014-10-19','2014-10-20','2014-10-21'];

my ($frm_yy,$frm_mm,$frm_dd) = $from_date =~ m{^([0-9]{4})-([0-9]{2})/([0-9]{2})\z};

my ($to_yy,$to_mm,$to_dd) = $to_date =~ m{^([0-9]{4})-([0-9]{2})/([0-9]{2})\z};


