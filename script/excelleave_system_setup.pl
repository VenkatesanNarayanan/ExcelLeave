#!/usr/bin/perl -w

use strict;
use DBI;
use Session::Token;
use Data::Dumper;
use Digest::MD5;
use Parse::CSV;
use Email::MIME;
use Email::Sender::Simple qw(sendmail);
use File::Spec::Functions;
use Config::Any;
use FindBin;

my $project_dir = exists($ENV{EXCELLEAVE_ROOT}) ? $ENV{EXCELLEAVE_ROOT} : "$FindBin::Bin/../";
my $file = catfile($project_dir, 'excelleave.pl');
my $sql_file = catfile($project_dir, 'sql', 'ExcelLeave.sql');

my $config = Config::Any->load_files(
    {
        files   => [$file],
        use_ext => 1,
    }
);
my $db = $config->[0]{$file}->{'Model::Leave'}->{'connect_info'};

my ($database, $host);
if ($db->{dsn} =~ m!dbi:Pg:database=(.*);host=(.*)!) {
    $database = $1;
    $host     = $2;
}

my $psql_command = "psql -h " . $host . " " . $database . " " . $db->{'user'};
$ENV{'PGPASSWORD'} = $db->{'password'};
$psql_command .= " -f $sql_file";
system($psql_command);

my $dsn      = $db->{'dsn'};
my $username = $db->{'user'};
my $password = $db->{'password'};

my $dbh = DBI->connect($dsn, $username, $password, {RaiseError => 1});

my $simple = Parse::CSV->new(file => $ARGV[0],);
my $count = 1;
my $query;

while (my $array_ref = $simple->fetch) {
	my $RoleId;
    if ($array_ref->[0] eq "Admin") {
		$RoleId = 1;
    } else {
		$RoleId = 2;
	}
	#my $data = $array_ref->[4];
	#my $ctx  = Digest::MD5->new;
	#$ctx->add($data);
	#my $password = $ctx->hexdigest;
	my $password = '5f4dcc3b5aa765d61d8327deb882cf99';

	$query = 'INSERT INTO "Employee" ("FirstName","LastName","DateOfJoining","RoleId","Email","Password","CreatedBy","CreatedOn", "Status") '
	. 'VALUES ('
	. $dbh->quote($array_ref->[1]) . ', '
	. $dbh->quote($array_ref->[2]) . ', '
	. $dbh->quote($array_ref->[3]) . ', '
	. $RoleId.', '
	. $dbh->quote($array_ref->[4]) . ', '
	. $dbh->quote($password) . ', '
	. "'System', current_date, 'Active')";

	$dbh->do($query);

	my $employee_id = $dbh->last_insert_id(undef, undef, undef, undef, {sequence => '"Employee_EmployeeId_seq"'});

	$query = 'INSERT INTO "EmployeeLeave" ("EmployeeId","AvailablePersonalLeaves","CreatedBy","CreatedOn") VALUES ('
	. $employee_id. ', '
	. '18' . ', '
	. '\'System\', '
	. 'current_date)';
	$dbh->do($query);

	$query = 'INSERT INTO "EmployeeManager" ("EmployeeId","ManagerEmployeeId","CreatedBy","CreatedOn") VALUES ('
	. $employee_id. ', '
	. '1, '
	. '\'System\', '
	. 'current_date)';
	$dbh->do($query);

	$count++;
}
print "==================Completed the setup=============\n";
1;
