#!/usr/bin/perl -w

#
# OfficialHolidays.pl
# Developed by Dharma  <dharma@exceleron.com>

use strict;
use Parse::CSV;
use DBI;
use File::Spec::Functions;
use Config::Any;
use FindBin;

my $project_dir = exists($ENV{EXCELLEAVE_ROOT}) ? $ENV{EXCELLEAVE_ROOT} : "$FindBin::Bin/../";
my $file = catfile($project_dir, 'excelleave.pl');

my $config = Config::Any->load_files(
	{
		files   => [$file],
		use_ext => 1,
	}
);
my $config_data = $config->[0]{$file};

my $dsn = $config_data->{'Model::Leave'}->{'connect_info'}->{'dsn'};
my $username = $config_data->{'Model::Leave'}->{'connect_info'}->{'user'};
my $password = $config_data->{'Model::Leave'}->{'connect_info'}->{'password'};

my $simple = Parse::CSV->new(
	file => $ARGV[0],
);

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
