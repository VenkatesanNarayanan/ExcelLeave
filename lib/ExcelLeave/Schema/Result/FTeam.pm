use utf8;
package ExcelLeave::Schema::Result::FTeam;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ExcelLeave::Schema::Result::FTeam

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<f_team>

=cut

__PACKAGE__->table("f_team");

=head1 ACCESSORS

=head2 id

  data_type: 'varchar'
  is_nullable: 0
  size: 10

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 manager_id

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "varchar", is_nullable => 0, size => 10 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "manager_id",
  { data_type => "varchar", is_foreign_key => 1, is_nullable => 1, size => 20 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 manager

Type: belongs_to

Related object: L<ExcelLeave::Schema::Result::FEmployee>

=cut

__PACKAGE__->belongs_to(
  "manager",
  "ExcelLeave::Schema::Result::FEmployee",
  { id => "manager_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-05 12:45:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RmOrNBxmGIZ5zjofhN/6LQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
