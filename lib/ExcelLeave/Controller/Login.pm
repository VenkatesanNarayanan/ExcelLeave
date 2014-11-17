package ExcelLeave::Controller::Login;
use Moose;
use namespace::autoclean;
use Digest::MD5;
use Data::Dumper;
BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

ExcelLeave::Controller::login - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index : Path : Args(0)
{
    my ($self, $c) = @_;
    $c->forward('View::TT');

    #$c->response->body('Matched ExcelLeave::Controller::login in login.');
}

sub tokencheck : Path : Args(1)
{
    my ($self, $c, $token) = @_;
    $c->stash->{token} = $token;
    my $user = $c->model('Leave::Employee')->search({-and => [Token => $token, Status => "Inactive"]});
    print "\n\nnumber of Records is :", $user->count, "\n";
    $c->stash->{tokenvalidate} = "valid";
    if ($user->count == 0) {
        $c->stash->{tokenvalidate} = "invalid";
    }
    $c->forward('View::TT');
}

sub loginvalidate : Local
{

    my ($self, $c) = @_;
    my $ctx = Digest::MD5->new;
    $ctx->add($c->request->params->{password});
    my $Password = $ctx->hexdigest;
    $c->stash->{error} = "valid";
    if (
        $c->authenticate(
            {

                "Email"    => $c->request->params->{'email'},
                "Password" => $Password,
            }
        )
      )
    {
        $c->res->redirect($c->uri_for_action('dashboard/index'));

        #$c->stash->{template} = "dashboard/index.tt";
        #$c->forward('View::TT');
    }
    else {

        $c->stash->{error} = "invalid";
        $c->forward('View::JSON');
    }
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
