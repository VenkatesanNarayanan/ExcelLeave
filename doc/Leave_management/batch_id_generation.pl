#!/usr/bin/perl -w

#
# batch_id_generation.pl
# Developed by Dharma  <dharma@exceleron.com>

use strict;
use MyApp::Schema;
use Data::Dumper;

my $schema=MyApp::Schema->connect("dbi:Pg:database=work","dharma","dharmu");
my @collected=$schema->resultset('Login')->all;

my $name="pavan";

my @arr=qw/a b c d e f g h i j k l m n o p q r s t u v w x y z/;

#print Dumper \@arr;

while()
{
	my $val="";
	for my $var(0 .. 16)
	{
		$val .= $arr[int rand(25)];
	}
	print $val,"\n";
	foreach my $var(@collected)
	{
		if($var->{_column_data}->{user_name} eq $name)
		{
			print "found name quit \n";
			exit;
		}
	}
}

1;
