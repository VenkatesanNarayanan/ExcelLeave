package Exl::Controller::Login;
use Moose;
use namespace::autoclean;
use Data::Dumper;
use Digest::MD5;
use Encode qw(encode_utf8);

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Exl::Controller::Login - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
	my ( $self, $c ) = @_;

	# $c->response->body('Matched Exl::Controller::Login in Login.');

#	$c->stash->{template} = 'login.tt';
	$c->stash->{myvar}= "Failed";
	$c->forward('View::TT');

}

=pod
sub index :Path {
	my ($self, $c) = @_;
	$c->stash->{myvar}= "Failed";
	print "back to normal\n";
	$c->forward('View::TT');

}
=cut
=pod
sub valiidate :Local {
	my ($self, $c) = @_;
#print Dumper $c->req->params;
#my $en_password = md5_hex(encode_utf8($password));

	print $password,"this s my Password \n";
	my $collected = $c->model('TestDatabase::Employee')->search({Email => $c->req->params->{email} and Password => $password});

#if($c->req->params->{email} ne "$collected->{Email}" and $en_password  ne "$collected->{Password}")
#{
#  print $collected->count, "count \n";
	if($collected->count > 0)
	{

		$c->stash->{myvar}="Success";
	}
	else
	{
		$c->stash->{myvar}="Failed";
		#  $c->stash->{template}='/login/index.tt';
	}
	#  }
	$c->forward('View::JSON');

}
=cut
sub login : Local {

	my($self, $c) = @_;

	my $ctx = Digest::MD5->new;
	$ctx->add($c->req->params->{password});
	my $password = $ctx->hexdigest;
	if ($c->authenticate( {
				"Email" => $c->request->params->{'email'},
				"Password" => $password,
			})) {

		



	} 
	else {
		 $c->stash->{failmsg} = " Doesn't match email and password";
		

	   }

	   $c->forward('View::JSON');

}


=encoding utf8

=head1 AUTHOR

Yogesh,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
