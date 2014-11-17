use utf8;
package MyApp::Schema::Result::Employee;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::Employee

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

=head1 TABLE: C<Employee>

=cut

__PACKAGE__->table("Employee");

=head1 ACCESSORS

=head2 employeeid

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: '"Employee_EmployeeId_seq"'

=head2 firstname

  data_type: 'varchar'
  is_nullable: 0
  size: 30

=head2 lastname

  data_type: 'varchar'
  is_nullable: 0
  size: 30

=head2 dateofjoing

  data_type: 'date'
  is_nullable: 0

=head2 email

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 password

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 roleid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 token

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 status

  data_type: '"employeestatus"'
  default_value: 'Inactive'::"EmployeeStatus'
  is_nullable: 1
  size: 4

=head2 createdby

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=head2 createdon

  data_type: 'date'
  is_nullable: 0

=head2 updatedby

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 updatedon

  data_type: 'date'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "employeeid",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "\"Employee_EmployeeId_seq\"",
  },
  "firstname",
  { data_type => "varchar", is_nullable => 0, size => 30 },
  "lastname",
  { data_type => "varchar", is_nullable => 0, size => 30 },
  "dateofjoing",
  { data_type => "date", is_nullable => 0 },
  "email",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "password",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "roleid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "token",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "status",
  {
    data_type => "\"employeestatus\"",
    default_value => "Inactive'::\"EmployeeStatus",
    is_nullable => 1,
    size => 4,
  },
  "createdby",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "createdon",
  { data_type => "date", is_nullable => 0 },
  "updatedby",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "updatedon",
  { data_type => "date", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</employeeid>

=back

=cut

__PACKAGE__->set_primary_key("employeeid");

=head1 RELATIONS

=head2 employee_leaves

Type: has_many

Related object: L<MyApp::Schema::Result::EmployeeLeave>

=cut

__PACKAGE__->has_many(
  "employee_leaves",
  "MyApp::Schema::Result::EmployeeLeave",
  { "foreign.employeeid" => "self.employeeid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 employee_manager_employeeids

Type: has_many

Related object: L<MyApp::Schema::Result::EmployeeManager>

=cut

__PACKAGE__->has_many(
  "employee_manager_employeeids",
  "MyApp::Schema::Result::EmployeeManager",
  { "foreign.employeeid" => "self.employeeid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 employee_manager_manageremployeeids

Type: has_many

Related object: L<MyApp::Schema::Result::EmployeeManager>

=cut

__PACKAGE__->has_many(
  "employee_manager_manageremployeeids",
  "MyApp::Schema::Result::EmployeeManager",
  { "foreign.manageremployeeid" => "self.employeeid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 leave_requests

Type: has_many

Related object: L<MyApp::Schema::Result::LeaveRequest>

=cut

__PACKAGE__->has_many(
  "leave_requests",
  "MyApp::Schema::Result::LeaveRequest",
  { "foreign.employeeid" => "self.employeeid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 roleid

Type: belongs_to

Related object: L<MyApp::Schema::Result::Role>

=cut

__PACKAGE__->belongs_to(
  "roleid",
  "MyApp::Schema::Result::Role",
  { roleid => "roleid" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-14 11:35:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:q4l4FbiECY7BzI86XJ2LyQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
