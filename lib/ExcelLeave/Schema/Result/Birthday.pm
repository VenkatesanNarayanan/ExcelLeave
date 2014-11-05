use utf8;
package ExcelLeave::Schema::Result::Birthday;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ExcelLeave::Schema::Result::Birthday

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<birthday>

=cut

__PACKAGE__->table("birthday");

=head1 ACCESSORS

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 date

  data_type: 'date'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "name",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "date",
  { data_type => "date", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-05 12:45:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:PS5VRtDFwurC4+3KxJ/CDQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
