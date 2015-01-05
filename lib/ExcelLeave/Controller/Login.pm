package ExcelLeave::Controller::Login;
use Moose;
use namespace::autoclean;
use Digest::MD5;
use Session::Token;
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
    $c->stash->{error} = 1;
    if (defined $c->request->params->{password}) {
        my $ctx = Digest::MD5->new;
        $ctx->add($c->request->params->{password});
        my $Password = $ctx->hexdigest;

        if (
            $c->authenticate(
                {

                    "Email"    => $c->request->params->{'email'},
                    "Password" => $Password,
                    "Status"   => 'Active',
                }
            )
          )
        {
            $c->res->redirect($c->uri_for_action('dashboard/index'));
        }
    }

    else {
        $c->stash->{error} = 0;
    }
    $c->forward('View::TT');
}

sub tokencheck : Path : Args(1)
{
    my ($self, $c, $token) = @_;
    $c->stash->{token} = $token;
    my $user = $c->model('Leave::Employee')->search({-and => [Token => $token, Status => "Inactive"]});
	if(my $u =$user->next)
	{
		$c->log->info(Dumper $u);
	}
    $c->stash->{tokenvalidate} = "valid";
    if ($user->count == 0) {
        $c->stash->{tokenvalidate} = "invalid";
    }
    $c->forward('View::TT');
}

sub forgotpassword : Local
{
    my ($self, $c) = @_;
    my $Employee = $c->model('Leave::Employee')->search(
        {Email => $c->req->params->{email}},
        {
            columns => [qw/EmployeeId FirstName Email/],
        }
    );

    if ($Employee->count == 1) {
        my $eid        = $Employee->next;
        my $EmployeeId = $eid->EmployeeId;
        my $token      = Session::Token->new->get;
        $Employee->update(
            {
                Status    => 'Inactive',
                Token     => $token,
                UpdatedBy => $EmployeeId,
                UpdatedOn => $c->forward('/dashboard/CurrentDate'),
            }
        );

        my $esubject = "Activate yourself to ExcelLeave System !!";
        my $email    = 'ExcelLeave@exceleron.com';
        my $content  = "Hi "
          . $eid->FirstName
		  # . ",\n\n\tClick on following link to activate your account in ExcelLeave System.\n\n\tlogin/"
		  .',<br> <p> We got a request to change your Exceleron Library password.To change your password,click the button.<p><a href="http://10.10.10.46:3000/login/'
          . $token
		  . '"> <button> Click me </button></a>'
          . "<br><br>\n\nThank You,<br>ExcelLeave System,\n<br>Exceleron Software (India).";

	    my $contenttype = 'text/html';
        my @args =  ($contenttype, $email, $eid->Email, $esubject, $content);
        $c->stash->{message} = 'Success';
        $c->forward('/dashboard/ExcelLeaveMailing', \@args);
    }
    else {
        $c->stash->{message} = 'Fail';
    }

    $c->forward('View::JSON');
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
