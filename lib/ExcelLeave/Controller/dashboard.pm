package ExcelLeave::Controller::dashboard;
use Moose;
use namespace::autoclean;
use Data::Dumper;
use DateTime;
use Digest::MD5;
use JSON;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

ExcelLeave::Controller::dashboard - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut
sub index :Path{
	my ( $self, $c ) = @_;
	#print $c->user->FirstName,"hello\n";
	my $username="Dharmu";
	$c->stash->{ProfileDetails}=$c->model('Leave::Employee')->search({FirstName=>$username});
	
#	my @collected=$c->model('Leave::Employee')->search({});
#	foreach my $var(@collected)
#	{
#		print Dumper $var->{_column_data};
#	}

	my $Role = "Adminstrator";
	my $emp;
	$emp->{foo2} = ['<li id="viewrequest" class="menubar"><a href="#"><span class="glyphicon glyphicon-eye-open"></span>&nbsp;View Request</a></li>'];
	$emp->{foo3} = ['<li id="viewrequest" class="menubar"><a href="#"><span class="glyphicon glyphicon-eye-open"></span>&nbsp;View Request</a></li>','<li id="updatedetails" class="menubar"><a href="#"><span class="glyphicon glyphicon-edit"></span>&nbsp;Update Details</a></li>'];

	if($Role eq "Manager") {
		$c->stash->{messages} = $emp->{foo2};
	}
	elsif($Role eq "Adminstrator")
   	{
		$c->stash->{messages} = $emp->{foo3};
	}	
	$c->stash->{uname}=$username;
	$c->forward('View::TT');

}

sub leaverequest :Local {
	my ($self,$c)=@_;
	$c->forward('View::TT');
}

sub leaverequesthandler:Local{

	print "First Line\n";

	my ($self,$c)=@_;
	print Dumper $c->req->params;
	my @fromdate=split('-',$c->req->params->{fromdate});
	my @todate=split('-',$c->req->params->{todate});
	my $start = DateTime->new(year=>$fromdate[0],month=>$fromdate[1],day=>$fromdate[2]);
	my $end   = DateTime->new(year=>$todate[0],month=>$todate[1],day=>$todate[2]);
	my %offcialsholidays;
	my $user="Dharmu";
	my $employeeid=1;
	my @collected=$c->model('Leave::OfficialHolidays')->search({});
	foreach my $var(@collected)
	{
		$offcialsholidays{$var->{_column_data}->{"HolidayDate"}}="";;
	}

	my @collected=$c->model('Leave::LeaveRequestBatch')->search({});

	my @arr=qw/a b c d e f g h i j k l m n o p q r s t u v w x y z/;

	my $flag=0;
	my $current_date = DateTime->now(time_zone => 'Asia/Kolkata');
	my $requestdate = $current_date->ymd();
	my $batchid;

	while($flag == 0)
	{
		 $batchid="";
		for my $var(0 .. 16)
		{
			$batchid .= $arr[int rand(25)];
		}

		foreach my $var(@collected)
		{
			if($var->{_column_data}->{BatachId} eq $batchid)
			{
				$flag=1;
				last;
			}
		}
		if($flag == 0)
		{
				$c->model('Leave::LeaveRequestBatch')->create(
				{
					BatchId=>$batchid,
					FromDate=>$c->req->params->{fromdate},
					ToDate=>$c->req->params->{todate},
					Message=>$c->req->params->{message},
					CreatedBy=>$user,
					UpdatedBy=>$user,
					CreatedOn=>$requestdate,
					UpdatedOn=>$requestdate,
				}
			);
			last;
		}
		else
		{
			$flag=0;
		}
	}
	
	print "Added a BatachId\n\n";
	while ($start <= $end) 
	{
		unless(exists $offcialsholidays{$start->ymd})
		{
			if($start->day_of_week <= 5)
			{
		  			$c->model('Leave::LeaveRequest')->create({
					EmployeeId=>$employeeid,
					BatchId=>$batchid,
					LeaveDate=>$start->ymd,
					CreatedBy=>$user,
					UpadatedBy=>$user,
					CreatedOn=>$requestdate,
					UpdatedOn=>$requestdate,
					});
				
				print $start->ymd,"\n";
	  		}
		}
				$start->add(days => 1);
	}
	$c->forward('View::JSON');
}

sub home :Local {
	my ($self,$c)=@_;

	$c->forward('View::TT');
}

sub changepassword:Local{

	my ($self,$c)=@_;
	my $name="Dharmu";
	my $user;
	if ($c->req->params->{status} eq "new")
	{
		$user=$c->model('Leave::Employee')->search({Token=>$c->req->params->{token}});
		$user->update({Status=>'Active'});
	}
	else
	{
		$user=$c->model('Leave::Employee')->search({FirstName=>$name});
	}
		my $data=$c->req->params->{newpassword};
		print $data,"\n";
		my $ctx = Digest::MD5->new;
		$ctx->add($data);
		my $mypassword = $ctx->hexdigest;

		my $tokencheck=$user->update({Password=>$mypassword});
		print Dumper $c->req->params;
}

sub updatedetails:Local
{

	my ($self,$c)=@_;

=pod	my @collected=$c->model('Leave::Role')->search({},{
			join => 'employees',   
			'+select' => ["employees.EmployeeId","employees.FirstName","employees.LastName","employees.DateOfJoing","employees.Email"],
			'+as' => ["EmployeeId","FirstName","LastName","DateOfJoing","Email"],
			#order_by => {-$dt_params->{"order[0][dir]"}=>$sort_column},
		});                         

	push( @{$c->stash->{details}},{
			EmployeeId => $_->get_column('EmployeeId'),
			FirstName => $_->get_column('FirstName'),
			LastName => $_->get_column('LastName'),
			RoleName => $_->RoleName,  
			DateOfJoining => $_->get_column('DateOfJoing'),
			Email => $_->get_column('Email'),
		}) foreach @collected;           
=cut

	my @collected=$c->model('Leave::Employee')->search({},{
			join => 'role',
			'+select' => ["role.RoleName"],
			'+as' => ["RoleName"],
		});


	print Dumper \@collected;

	push( @{$c->stash->{details}},{
			 EmployeeId => $_->EmployeeId,
			 FirstName => $_->FirstName,
			 LastName => $_->LastName,
			 RoleName => $_->get_column('RoleName'),
			 DateOfJoining => $_->DateOfJoing,
			 Email => $_->Email,
			}) foreach @collected;

	$c->forward('View::TT');

}

sub addemployee :Local {
	my ($self,$c)=@_;

	$c->forward('View::TT');

	#my $fname = $c->request->params->{'fname'};
	#my $lname = $c->request->params->{'lname'};
	#my $email = $c->request->params->{'email'};
	#my $dateofjoining = $c->params->{'dateofjoining'};
	#my $role = $c->params->{'role'};

	print "name ------------------\n";
=pod	
	my @responsedata = $c->model('Leave::AddEmp')->create({

			FirstName => $fname,
			LastName => $lname,
			Email => $email,
			DateOfJoining => $dateofjoining,
			Role => $role,

		});

	print Dumper \@responsedata;
=cut

}



=encoding utf8
=encoding utf8

=head1 AUTHOR

dharma,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
