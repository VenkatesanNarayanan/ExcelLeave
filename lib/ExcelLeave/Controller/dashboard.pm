package ExcelLeave::Controller::dashboard;
use Moose;
use namespace::autoclean;
use Data::Dumper;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

ExcelLeave::Controller::dashboard - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
	my ( $self, $c ) = @_;
	
#	my @collected=$c->model('Leave::Employee')->search({});
#	foreach my $var(@collected)
#	{
#		print Dumper $var->{_column_data};
#	}

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
	$c->forward('View::TT');

}



sub leaverequest :Local {
	my ($self,$c)=@_;

	$c->forward('View::TT');
}


sub home :Local {
	my ($self,$c)=@_;

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
