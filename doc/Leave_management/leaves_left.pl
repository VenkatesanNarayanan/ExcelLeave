#!/usr/bin/perl -w

#
# leaves_left.pl
# Developed by Dharma  <dharma@exceleron.com>

use strict;
use MyApp::Schema;
use Data::Dumper;

my $schema=MyApp::Schema->connect("dbi:Pg:database=work","dharma","dharmu");
my @collected=$schema->resultset('"Employee"')->all;

foreach (@collected)
{
	print Dumper $_->{_column_data};
}
1;
