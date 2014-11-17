use utf8;
package MyApp::Schema::Result::LeaveRequestBatch;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::LeaveRequestBatch

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

=head1 TABLE: C<LeaveRequestBatch>

=cut

__PACKAGE__->table("LeaveRequestBatch");

=head1 ACCESSORS

=head2 batchid

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=head2 fromdate

  data_type: 'date'
  is_nullable: 0

=head2 todate

  data_type: 'date'
  is_nullable: 0

=head2 message

  data_type: 'varchar'
  is_nullable: 0
  size: 100

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
  "batchid",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "fromdate",
  { data_type => "date", is_nullable => 0 },
  "todate",
  { data_type => "date", is_nullable => 0 },
  "message",
  { data_type => "varchar", is_nullable => 0, size => 100 },
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

=item * L</batchid>

=back

=cut

__PACKAGE__->set_primary_key("batchid");

=head1 RELATIONS

=head2 leave_requests

Type: has_many

Related object: L<MyApp::Schema::Result::LeaveRequest>

=cut

__PACKAGE__->has_many(
  "leave_requests",
  "MyApp::Schema::Result::LeaveRequest",
  { "foreign.batchid" => "self.batchid" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-14 11:35:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YbQ8Y7NEV9WTyBLnkaaq+A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
