use utf8;
package Exl::Schema::Result::LeaveRequest;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Exl::Schema::Result::LeaveRequest

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<LeaveRequest>

=cut

__PACKAGE__->table("LeaveRequest");

=head1 ACCESSORS

=head2 LeaveId

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: '"LeaveRequest_LeaveId_seq"'

=head2 EmployeeId

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 BatchId

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 1
  size: 20

=head2 LeaveDate

  data_type: 'date'
  is_nullable: 0

=head2 LeaveStatus

  data_type: '"leavestatus"'
  default_value: 'Pending'::"LeaveStatus'
  is_nullable: 1
  size: 4

=head2 CreatedBy

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=head2 CreatedOn

  data_type: 'date'
  is_nullable: 0

=head2 UpadatedBy

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=head2 UpdatedOn

  data_type: 'date'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "LeaveId",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "\"LeaveRequest_LeaveId_seq\"",
  },
  "EmployeeId",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "BatchId",
  { data_type => "varchar", is_foreign_key => 1, is_nullable => 1, size => 20 },
  "LeaveDate",
  { data_type => "date", is_nullable => 0 },
  "LeaveStatus",
  {
    data_type => "\"leavestatus\"",
    default_value => "Pending'::\"LeaveStatus",
    is_nullable => 1,
    size => 4,
  },
  "CreatedBy",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "CreatedOn",
  { data_type => "date", is_nullable => 0 },
  "UpadatedBy",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "UpdatedOn",
  { data_type => "date", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</LeaveId>

=back

=cut

__PACKAGE__->set_primary_key("LeaveId");

=head1 RELATIONS

=head2 batch

Type: belongs_to

Related object: L<Exl::Schema::Result::LeaveRequestBatch>

=cut

__PACKAGE__->belongs_to(
  "batch",
  "Exl::Schema::Result::LeaveRequestBatch",
  { BatchId => "BatchId" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

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


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-04 16:39:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:UPx5MBe4Dg8e6DOy+3UlJw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
