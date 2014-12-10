#!/usr/bin/perl -w

#
# OfficialHolidays.pl
# Developed by Dharma  <dharma@exceleron.com>

use strict;
use Parse::CSV;
use DBI;

my $simple = Parse::CSV->new(
	file => $ARGV[0],
);

my $dsn = $dsnvalue;
my $username = $usernamevalue;
my $password = $passwordvalue;

my  $dbh = DBI->connect( $dsn, $username, $password, { RaiseError => 1 } );
my $query=q!delete from "OfficialHolidays"!;
   $dbh->do("$query");
while ( my $array_ref = $simple->fetch ) 
{
	$query=q!insert into "OfficialHolidays" values('!.$array_ref->[0].q!','!.$array_ref->[1].q!','System',current_date,'System',current_date)!;
	$dbh->do("$query");
}

print "Holiday table is updated\n";
1;
