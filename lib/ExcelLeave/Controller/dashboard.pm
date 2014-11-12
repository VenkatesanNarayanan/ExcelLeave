package ExcelLeave::Controller::dashboard;
use Moose;
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
	my $username="Girish";
	$c->stash->{ProfileDetails}=$c->model('Leave::Employee')->search({FirstName=>$username});
	
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

sub newemployee :Local{
	my ($self,$c)=@_;

	print Dumper $c->req->params;
	$c->forward('View::JSON');

}
sub addemployee :Local {
	my ($self,$c)=@_;
	my @collected=$c->model('Leave::Role')->search({});

	push( @{$c->stash->{roles}},{
			RoleName => $_->RoleName,
		}) foreach @collected;

	$c->forward('View::TT');
}

sub updatedetailsform:Local
{
	my ($self,$c)=@_;
	my @collected=$c->model('Leave::Role')->search({});

	push( @{$c->stash->{roles}},{
			RoleName => $_->RoleName,
		}) foreach @collected;

	my @empcollection=$c->model('Leave::Employee')->search({EmployeeId=>$c->req->params->{employeeid}},{
			join => 'role',
			'+select' => ["role.RoleName"],
			'+as' => ["RoleName"],
		});

	push( @{$c->stash->{empdetails}},{
			EmployeeId=>$_->EmployeeId,
			FirstName=>$_->FirstName,
			Email=>$_->Email,
			LastName=>$_->LastName,
			DateOfJoining=>$_->DateOfJoing,
			Status=>$_->Status,
			RoleName => $_->get_column('RoleName'),
		}) foreach @empcollection;

	$c->forward('View::TT');
}

sub employeeupdate:Local
{
	my ($self,$c)=@_;
	my $user=$c->model('Leave::Employee')->search({EmployeeId=>$c->req->params->{employeeid}});
	my @roleid=$c->model('Leave::Role')->search({RoleName=>$c->req->params->{role}});
	my $id;
	foreach my $var (@roleid)
	{
		$id=$var->{_column_data}->{RoleId};
	}
	$user->update({
			FirstName=>$c->req->params->{fname},
			LastName=>$c->req->params->{lname},
			Email=>$c->req->params->{email},
			DateOfJoing=>$c->req->params->{dateofjoining},
			RoleId=>$id,
			Status=>$c->req->params->{status}
		});
	$c->forward('View::JSON');
}
=encoding utf8
=encoding utf8

=head1 AUTHOR

girish,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
