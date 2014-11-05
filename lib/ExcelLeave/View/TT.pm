package ExcelLeave::View::TT;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
);

=head1 NAME

ExcelLeave::View::TT - TT View for ExcelLeave

=head1 DESCRIPTION

TT View for ExcelLeave.

=head1 SEE ALSO

L<ExcelLeave>

=head1 AUTHOR

dharma,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
