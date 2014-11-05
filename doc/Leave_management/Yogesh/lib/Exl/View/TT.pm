package Exl::View::TT;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
);

=head1 NAME

Exl::View::TT - TT View for Exl

=head1 DESCRIPTION

TT View for Exl.

=head1 SEE ALSO

L<Exl>

=head1 AUTHOR

Yogesh,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
