use utf8;
package Exl::Schema::Result::LeaveRequestBatch;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Exl::Schema::Result::LeaveRequestBatch

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

Related object: L<Exl::Schema::Result::LeaveRequest>

=cut

__PACKAGE__->has_many(
  "leave_requests",
  "Exl::Schema::Result::LeaveRequest",
  { "foreign.BatchId" => "self.BatchId" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-04 16:39:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6yFlY6BuF6ETqCxSbY/G9w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
