use utf8;
package ExcelLeave::Schema::Result::Login;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ExcelLeave::Schema::Result::Login

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<login>

=cut

__PACKAGE__->table("login");

=head1 ACCESSORS

=head2 user_name

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 password

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=cut

__PACKAGE__->add_columns(
  "user_name",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "password",
  { data_type => "varchar", is_nullable => 1, size => 30 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-05 12:45:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Dh1Ef1aGChx+fNRcx1SUUg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
