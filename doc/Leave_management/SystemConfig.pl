#!/usr/bin/perl -w

#
# SystemConfig.pl
# Developed by Dharma  <dharma@exceleron.com>

use strict;
use DBI;
use Session::Token;
use Data::Dumper;
use Digest::MD5;
use Parse::CSV;
use Email::MIME;
use Email::Sender::Simple qw(sendmail);
use excelleave_databasesetup;

my $dsn = $dsnvalue;
my $username = $usernamevalue;
my $password = $passwordvalue;

my  $dbh = DBI->connect( $dsn, $username, $password, { RaiseError => 1 } );

my  $query = q!drop table if exists "OfficialHolidays" !;	
	$dbh->do("$query");

	print "Table is OfficialHolidays dropped \n";
 	$query= q! CREATE TABLE "OfficialHolidays" (
		"HolidayDate" date  NOT NULL,
		"HolidayOccasion" varchar(150)  NOT NULL,
		"CreatedBy" varchar(20)  NOT NULL,
		"CreatedOn" date  NOT NULL,
		"UpdatedBy" varchar(20) NULL,
		"UpdatedOn" date  NULL) !;

	$dbh->do("$query");
	print "New table OfficialHolidays Created\n";

	$query=q!drop table if exists "Role" cascade!;
	$dbh->do("$query");
	
	print "Table is Role dropped \n";
	$query=q!CREATE TABLE "Role" (
		"RoleId" SERIAL PRIMARY KEY,
		"RoleName" varchar(20)  NOT NULL,
		"CreatedBy" varchar(20)  NOT NULL,
		"CreatedOn" date  NOT NULL,
		"UpdatedBy" varchar(20) NULL,
		"UpdatedOn" date NULL
		)!;
	$dbh->do("$query");
	print "New table Role Created\n";

	$query=q!drop TYPE if exists "EmployeeStatus" cascade!;
	$dbh->do("$query");

	$query=q!CREATE TYPE "EmployeeStatus" AS ENUM ('Active','Inactive','Disabled')!;
	$dbh->do("$query");

	$query=q!drop table if exists "Employee" cascade!;
	$dbh->do("$query");
	
	print "Table is Employee dropped \n";
	$query=q!CREATE TABLE "Employee" (
		"EmployeeId" SERIAL PRIMARY KEY,
		"FirstName" varchar(30)  NOT NULL,
		"LastName" varchar(30)  NOT NULL,
		"DateOfJoining" date  NOT NULL,
		"Email" varchar(100)  NOT NULL,
		"Password" varchar(100)  NOT NULL,
		"RoleId" int references "Role"("RoleId"),
		"Token" varchar(100)  NULL,
		"Status" "EmployeeStatus" default 'Inactive',
		"CreatedBy" varchar(20)  NOT NULL,
		"CreatedOn" date  NOT NULL,
		"UpdatedBy" varchar(20)  NULL,
		"UpdatedOn" date  NULL
		)!;
	$dbh->do("$query");
	print "New table Employee Created\n";

	$query=q!drop table if exists "EmployeeManager"!;
	$dbh->do("$query");

	print "Table is EmployeeManager dropped \n";
	$query=q!CREATE TABLE "EmployeeManager" (
		"EmployeeId" int  references "Employee"("EmployeeId"),
		"ManagerEmployeeId" int  references "Employee"("EmployeeId"),
		"CreatedBy" varchar(20)  NOT NULL,
		"CreatedOn" date  NOT NULL,
		"UpdatedBy" varchar(20) NULL,
		"UpdatedOn" date NULL
		)!;
	$dbh->do("$query");

	print "New table EmployeeManager Created\n";
	
	$query=q!drop table if exists "EmployeeLeave"!;
	$dbh->do("$query");
	
	print "Table is EmployeeLeave dropped \n";

	$query=q!CREATE TABLE "EmployeeLeave" (
		"EmployeeId" int  references "Employee"("EmployeeId"),
		"AvailablePersonalLeaves" int  NOT NULL,
		"CreatedBy" varchar(20)  NOT NULL,
		"CreatedOn" date  NOT NULL,
		"UpdatedBy" varchar(20) NULL,
		"UpdatedOn" date NULL
		)!;
	$dbh->do("$query");
	
	print "New table EmployeeLeave Created\n";

	$query=q!drop table if exists "LeaveRequestBatch" cascade!;
	$dbh->do("$query");
	
	print "Table is LeaveRequestBatch dropped \n";

	$query=q!CREATE TABLE "LeaveRequestBatch" (
		"BatchId" varchar(20)  PRIMARY KEY,
		"FromDate" date  NOT NULL,
		"ToDate" date  NOT NULL,
		"Message" varchar(100)  NOT NULL,
		"CreatedBy" varchar(20)  NOT NULL,
		"CreatedOn" date  NOT NULL,
		"UpdatedBy" varchar(20) NULL,
		"UpdatedOn" date NULL
		)!;
	$dbh->do("$query");
	
	print "New table LeaveRequestBatch Created\n";

	$query=q!drop TYPE if exists "LeaveStatus" cascade!;
	$dbh->do("$query");
	
	$query=q!CREATE TYPE "LeaveStatus" AS ENUM ('Pending','Denied','Approved','Cancelled')!;
	$dbh->do("$query");
	
	$query=q!drop table if exists "LeaveRequest"!;
	$dbh->do("$query");
	
	print "Table is LeaveRequest dropped \n";
	$query=q!CREATE TABLE "LeaveRequest" (
		"LeaveId"  SERIAL PRIMARY KEY,
		"EmployeeId" int  references "Employee"("EmployeeId"),
		"BatchId" varchar(20)  references "LeaveRequestBatch"("BatchId"),
		"LeaveDate" date  NOT NULL,
		"LeaveStatus" "LeaveStatus" default 'Pending',
		"CreatedBy" varchar(20)  NOT NULL,
		"CreatedOn" date  NOT NULL,
		"UpdatedBy" varchar(20) NULL,
		"UpdatedOn" date NULL)!;
	$dbh->do("$query");
	print "New table LeaveRequest Created\n";
	
	$query=q!drop Table if exists "SystemConfig" !;
	$dbh->do("$query");
	
	$query=q!CREATE Table "SystemConfig"(
	"ConfigKey" varchar(50),
	"ConfigValue" varchar(10)
	)!;
	$dbh->do("$query");

	my $simple = Parse::CSV->new(
		    file => $ARGV[0],
		);
	$query=q!insert into "Role"("RoleName","CreatedBy","CreatedOn","UpdatedBy","UpdatedOn") values('Adminstrator','System',current_date,'System',current_date)!;
	$dbh->do("$query");

		my $count=1;

		while ( my $array_ref = $simple->fetch ) 
		{

				if($array_ref->[0] eq "Role")
				{
					$query=q!insert into "Role"("RoleName","CreatedBy","CreatedOn","UpdatedBy","UpdatedOn") values('!.$array_ref->[1].q!','System',current_date,'System',current_date)!;
					$dbh->do("$query");
				}
				elsif($array_ref->[0] eq "SystemConfig")
				{
					$query=q!insert into "SystemConfig" values('!.$array_ref->[1].q!','!.$array_ref->[2].q!')!;
					$dbh->do("$query");
				}
				else
				{
					my $data=$array_ref->[4];
					my $ctx = Digest::MD5->new;
					$ctx->add($data);
					my $password = $ctx->hexdigest;


					$query=q!insert into "Employee"("FirstName","LastName","DateOfJoining","RoleId","Email","Password","CreatedBy","CreatedOn")values('!.$array_ref->[1].q!','!.$array_ref->[2].q!','!.$array_ref->[3].q!','1','!.$array_ref->[4].q!','!.$password.q!','System',current_date)!;
					$dbh->do($query);
					 $query=q!insert into "EmployeeLeave"("EmployeeId","AvailablePersonalLeaves","CreatedBy","CreatedOn")values('!.$count.q!','18','!.$count.q!',current_date)!;
					$dbh->do($query);
					 $query=q!insert into "EmployeeManager"("EmployeeId","ManagerEmployeeId","CreatedBy","CreatedOn")values('!.$count.q!','!.$count.q!,'!.$count.q!',current_date)!;

					 print $query,"\n\n";
					$dbh->do($query);
					 $count++;
					my $token = Session::Token->new->get;
					$query=q!update "Employee" set "Token"='!.$token.q!' where "Email"='!.$array_ref->[4].q!'!;
					$dbh->do($query);

					my $content="Hi ".$array_ref->[1]." ,\n For your account activation click on this link \n /login/".$token."\nRegards\nExceleron India\n";
					my $message = Email::MIME->create(
						header_str => [
							From    => 'ExcelLeave@exceleron.com',
							To      => $array_ref->[4],
							Subject => 'Message from System',
						],
						attributes => {
							encoding => 'quoted-printable',
							charset  => 'ISO-8859-1',
						},
						body_str => $content,
					);
					
					sendmail($message);

				}
		}
		print "==================Completed the setup=============\n";
1;
