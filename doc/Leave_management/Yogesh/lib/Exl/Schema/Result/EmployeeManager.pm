use utf8;
package Exl::Schema::Result::EmployeeManager;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Exl::Schema::Result::EmployeeManager

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<EmployeeManager>

=cut

__PACKAGE__->table("EmployeeManager");

=head1 ACCESSORS

=head2 EmployeeId

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 ManagerEmployeeId

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

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
  "EmployeeId",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "ManagerEmployeeId",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "CreatedBy",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "CreatedOn",
  { data_type => "date", is_nullable => 0 },
  "UpdatedBy",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "UpdatedOn",
  { data_type => "date", is_nullable => 0 },
);

=head1 RELATIONS

=head2 employee

Type: belongs_to

Related object: L<Exl::Schema::Result::Employee>

=cut

__PACKAGE__->belongs_to(
  "employee",
  "Exl::Schema::Result::Employee",
  { EmployeeId => "EmployeeId" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 manager_employee

Type: belongs_to

Related object: L<Exl::Schema::Result::Employee>

=cut

__PACKAGE__->belongs_to(
  "manager_employee",
  "Exl::Schema::Result::Employee",
  { EmployeeId => "ManagerEmployeeId" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-04 16:39:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:lpAFU3XT9Y6S428L4rnwrw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
