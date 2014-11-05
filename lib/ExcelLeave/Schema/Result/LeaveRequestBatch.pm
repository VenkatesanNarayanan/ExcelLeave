use utf8;
package ExcelLeave::Schema::Result::LeaveRequestBatch;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ExcelLeave::Schema::Result::LeaveRequestBatch

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<LeaveRequestBatch>

=cut

__PACKAGE__->table("LeaveRequestBatch");

=head1 ACCESSORS

=head2 BatchId

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=head2 FromDate

  data_type: 'date'
  is_nullable: 0

=head2 ToDate

  data_type: 'date'
  is_nullable: 0

=head2 Message

  data_type: 'varchar'
  is_nullable: 0
  size: 100

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
  "BatchId",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "FromDate",
  { data_type => "date", is_nullable => 0 },
  "ToDate",
  { data_type => "date", is_nullable => 0 },
  "Message",
  { data_type => "varchar", is_nullable => 0, size => 100 },
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

=item * L</BatchId>

=back

=cut

__PACKAGE__->set_primary_key("BatchId");

=head1 RELATIONS

=head2 leave_requests

Type: has_many

Related object: L<ExcelLeave::Schema::Result::LeaveRequest>

=cut

__PACKAGE__->has_many(
  "leave_requests",
  "ExcelLeave::Schema::Result::LeaveRequest",
  { "foreign.BatchId" => "self.BatchId" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-05 12:45:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2vTAkzmsiPi4W3ssECgbvw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
