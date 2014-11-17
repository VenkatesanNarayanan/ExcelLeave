use utf8;
package MyApp::Schema::Result::LeaveRequest;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::LeaveRequest

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

=head1 TABLE: C<LeaveRequest>

=cut

__PACKAGE__->table("LeaveRequest");

=head1 ACCESSORS

=head2 leaveid

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: '"LeaveRequest_LeaveId_seq"'

=head2 employeeid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 batchid

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 1
  size: 20

=head2 leavedate

  data_type: 'date'
  is_nullable: 0

=head2 leavestatus

  data_type: '"leavestatus"'
  default_value: 'Pending'::"LeaveStatus'
  is_nullable: 1
  size: 4

=head2 createdby

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=head2 createdon

  data_type: 'date'
  is_nullable: 0

=head2 upadatedby

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=head2 updatedon

  data_type: 'date'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "leaveid",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "\"LeaveRequest_LeaveId_seq\"",
  },
  "employeeid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "batchid",
  { data_type => "varchar", is_foreign_key => 1, is_nullable => 1, size => 20 },
  "leavedate",
  { data_type => "date", is_nullable => 0 },
  "leavestatus",
  {
    data_type => "\"leavestatus\"",
    default_value => "Pending'::\"LeaveStatus",
    is_nullable => 1,
    size => 4,
  },
  "createdby",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "createdon",
  { data_type => "date", is_nullable => 0 },
  "upadatedby",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "updatedon",
  { data_type => "date", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</leaveid>

=back

=cut

__PACKAGE__->set_primary_key("leaveid");

=head1 RELATIONS

=head2 batchid

Type: belongs_to

Related object: L<MyApp::Schema::Result::LeaveRequestBatch>

=cut

__PACKAGE__->belongs_to(
  "batchid",
  "MyApp::Schema::Result::LeaveRequestBatch",
  { batchid => "batchid" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 employeeid

Type: belongs_to

Related object: L<MyApp::Schema::Result::Employee>

=cut

__PACKAGE__->belongs_to(
  "employeeid",
  "MyApp::Schema::Result::Employee",
  { employeeid => "employeeid" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-14 11:35:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Ikvc4BI0Ce4A5yxNQNn+KA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
