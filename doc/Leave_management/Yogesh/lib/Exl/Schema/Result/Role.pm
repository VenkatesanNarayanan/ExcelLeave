use utf8;
package Exl::Schema::Result::Role;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Exl::Schema::Result::Role

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<Role>

=cut

__PACKAGE__->table("Role");

=head1 ACCESSORS

=head2 RoleId

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: '"Role_RoleId_seq"'

=head2 RoleName

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=head2 CreatedBy

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=head2 CreatedOn

  data_type: 'date'
  is_nullable: 0

=head2 UpdatedBy

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=head2 UpdatedOn

  data_type: 'date'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "RoleId",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "\"Role_RoleId_seq\"",
  },
  "RoleName",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "CreatedBy",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "CreatedOn",
  { data_type => "date", is_nullable => 0 },
  "UpdatedBy",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "UpdatedOn",
  { data_type => "date", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</RoleId>

=back

=cut

__PACKAGE__->set_primary_key("RoleId");

=head1 RELATIONS

=head2 employees

Type: has_many

Related object: L<Exl::Schema::Result::Employee>

=cut

__PACKAGE__->has_many(
  "employees",
  "Exl::Schema::Result::Employee",
  { "foreign.RoleId" => "self.RoleId" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-04 16:39:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cLH+y4NJUYyarmXKVk2sFw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
