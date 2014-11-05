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
	
	my @collected=$c->model('Leave::Employee')->search({});
	foreach my $var(@collected)
	{
		print Dumper $var->{_column_data};
	}

	my $Role = "Employee";

	my $emp->{foo1} = [ '<a href="#"><span class="glyphicon glyphicon-user"></span>&nbsp;Profile</a>', '<a href="#"><span class="glyphicon glyphicon-list-alt"></span>&nbsp;Leave Apply</a>' ,'<a href="#"><span class="glyphicon glyphicon-send"></span>&nbsp;Leave Status</a>'];
	$emp->{foo2} = [ '<a href="#"><span class="glyphicon glyphicon-user"></span>&nbsp;Profile</a>', '<a href="#"><span class="glyphicon glyphicon-list-alt"></span>&nbsp;Leave Apply</a>' ,'<a href="#"><span class="glyphicon glyphicon-send"></span>&nbsp;Leave Status</a>','<a href="#"><span class="glyphicon glyphicon-eye-open"></span>&nbsp;View Request</a>'];
	$emp->{foo3} = ['<a href="#"><span class="glyphicon glyphicon-user"></span>&nbsp;Profile</a>','<a href="#"><span class="glyphicon glyphicon-list-alt"></span>&nbsp;Leave Apply</a>','<a href="#"><span class="glyphicon glyphicon-send"></span>&nbsp;Leave Status</a>','<a href="#"><span class="glyphicon glyphicon-eye-open"></span>&nbsp;View Request</a>','<a href="#"><span class="glyphicon glyphicon-edit"></span>&nbsp;Update Details</a>'];

	if($Role eq "Employee") {
		$c->stash->{messages} = $emp->{foo1};
	}
	elsif($Role eq "Manager") {
		$c->stash->{messages} = $emp->{foo2};
	}
	else {
		$c->stash->{messages} = $emp->{foo3};
	}	
	$c->forward('View::TT');

}



sub leaverequest :Path:Args(1) {
	my ($self,$c,$arg)=@_;
	#$c->stash->{template}='dashboard/LeaveRequestForm.tt';
	$c->forward('View::TT');
}
=encoding utf8

=head1 AUTHOR

dharma,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
