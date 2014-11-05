use utf8;
package ExcelLeave::Schema::Result::Employee;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ExcelLeave::Schema::Result::Employee

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<Employee>

=cut

__PACKAGE__->table("Employee");

=head1 ACCESSORS

=head2 EmployeeId

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: '"Employee_EmployeeId_seq"'

=head2 FirstName

  data_type: 'varchar'
  is_nullable: 0
  size: 30

=head2 LastName

  data_type: 'varchar'
  is_nullable: 0
  size: 30

=head2 DateOfJoing

  data_type: 'date'
  is_nullable: 0

=head2 Email

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 Password

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 RoleId

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 Token

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 Status

  data_type: '"employeestatus"'
  default_value: 'Inactive'::"EmployeeStatus'
  is_nullable: 1
  size: 4

=head2 CreatedBy

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=head2 CreatedOn

  data_type: 'date'
  is_nullable: 0

=head2 UpdatedBy

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 UpdatedOn

  data_type: 'date'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "EmployeeId",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "\"Employee_EmployeeId_seq\"",
  },
  "FirstName",
  { data_type => "varchar", is_nullable => 0, size => 30 },
  "LastName",
  { data_type => "varchar", is_nullable => 0, size => 30 },
  "DateOfJoing",
  { data_type => "date", is_nullable => 0 },
  "Email",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "Password",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "RoleId",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "Token",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "Status",
  {
    data_type => "\"employeestatus\"",
    default_value => "Inactive'::\"EmployeeStatus",
    is_nullable => 1,
    size => 4,
  },
  "CreatedBy",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "CreatedOn",
  { data_type => "date", is_nullable => 0 },
  "UpdatedBy",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "UpdatedOn",
  { data_type => "date", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</EmployeeId>

=back

=cut

__PACKAGE__->set_primary_key("EmployeeId");

=head1 RELATIONS

=head2 employee_leaves

Type: has_many

Related object: L<ExcelLeave::Schema::Result::EmployeeLeave>

=cut

__PACKAGE__->has_many(
  "employee_leaves",
  "ExcelLeave::Schema::Result::EmployeeLeave",
  { "foreign.EmployeeId" => "self.EmployeeId" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 employee_manager_employees

Type: has_many

Related object: L<ExcelLeave::Schema::Result::EmployeeManager>

=cut

__PACKAGE__->has_many(
  "employee_manager_employees",
  "ExcelLeave::Schema::Result::EmployeeManager",
  { "foreign.EmployeeId" => "self.EmployeeId" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 employee_manager_manager_employees

Type: has_many

Related object: L<ExcelLeave::Schema::Result::EmployeeManager>

=cut

__PACKAGE__->has_many(
  "employee_manager_manager_employees",
  "ExcelLeave::Schema::Result::EmployeeManager",
  { "foreign.ManagerEmployeeId" => "self.EmployeeId" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 leave_requests

Type: has_many

Related object: L<ExcelLeave::Schema::Result::LeaveRequest>

=cut

__PACKAGE__->has_many(
  "leave_requests",
  "ExcelLeave::Schema::Result::LeaveRequest",
  { "foreign.EmployeeId" => "self.EmployeeId" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 role

Type: belongs_to

Related object: L<ExcelLeave::Schema::Result::Role>

=cut

__PACKAGE__->belongs_to(
  "role",
  "ExcelLeave::Schema::Result::Role",
  { RoleId => "RoleId" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-05 12:45:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+PXrNVDNboA+cnMykhjrKw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
