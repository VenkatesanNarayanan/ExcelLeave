package ExcelLeave::Controller::dashboard;
use Moose;
use namespace::autoclean;
use Data::Dumper;
use DateTime;
use Digest::MD5;

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
<<<<<<< HEAD
	#print $c->user->FirstName,"hello\n";
	my $username="Dharmu";
	$c->stash->{ProfileDetails}=$c->model('Leave::Employee')->search({FirstName=>$username});
=======
	
#	my @collected=$c->model('Leave::Employee')->search({});
#	foreach my $var(@collected)
#	{
#		print Dumper $var->{_column_data};
#	}

>>>>>>> b2003c6c9a155436af5693e65c776efe2ecd9b24
	my $Role = "Adminstrator";
	my $emp;
	$emp->{foo2} = ['<li id="viewrequest" class="menubar"><a href="#"><span class="glyphicon glyphicon-eye-open"></span>&nbsp;View Request</a></li>'];
	$emp->{foo3} = ['<li id="viewrequest" class="menubar"><a href="#"><span class="glyphicon glyphicon-eye-open"></span>&nbsp;View Request</a></li>','<li id="addemployee" class="menubar"><a href="#"><span class="glyphicon glyphicon-edit"></span>&nbsp;Update Details</a></li>'];

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

	my ($self,$c)=@_;
	my @fromdate=split('-',$c->req->params->{fromdate});
	my @todate=split('-',$c->req->params->{todate});
	my $start = DateTime->new(year=>$fromdate[0],month=>$fromdate[1],day=>$fromdate[2]);
	my $end   = DateTime->new(year=>$todate[0],month=>$todate[1],day=>$todate[2]);
	my %offcialsholidays;
	
	my @collected=$c->model('Leave::OfficialHolidays')->search({});
	foreach my $var(@collected)
	{
		$offcialsholidays{$var->{_column_data}->{"HolidayDate"}}="";;
	}
	

	while ($start <= $end) 
	{
		unless(exists $offcialsholidays{$start->ymd})
		{
			if($start->day_of_week <= 5)
			{
		  		print $start->ymd, "\n";
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

<<<<<<< HEAD
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
=======
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



>>>>>>> b2003c6c9a155436af5693e65c776efe2ecd9b24
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
