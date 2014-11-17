use utf8;
package MyApp::Schema::Result::Role;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::Role

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<Role>

=cut

__PACKAGE__->table("Role");

=head1 ACCESSORS

=head2 roleid

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: '"Role_RoleId_seq"'

=head2 rolename

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=head2 createdby

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=head2 createdon

  data_type: 'date'
  is_nullable: 0

=head2 updatedby

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=head2 updatedon

  data_type: 'date'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "roleid",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "\"Role_RoleId_seq\"",
  },
  "rolename",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "createdby",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "createdon",
  { data_type => "date", is_nullable => 0 },
  "updatedby",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "updatedon",
  { data_type => "date", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</roleid>

=back

=cut

__PACKAGE__->set_primary_key("roleid");

=head1 RELATIONS

=head2 employees

Type: has_many

Related object: L<MyApp::Schema::Result::Employee>

=cut

__PACKAGE__->has_many(
  "employees",
  "MyApp::Schema::Result::Employee",
  { "foreign.roleid" => "self.roleid" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-14 11:35:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:D5H4uyEx/u+Nl/y5xxgG4w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
