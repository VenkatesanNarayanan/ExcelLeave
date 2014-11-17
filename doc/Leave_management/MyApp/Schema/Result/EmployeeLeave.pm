use utf8;
package MyApp::Schema::Result::EmployeeLeave;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::EmployeeLeave

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

=head1 TABLE: C<EmployeeLeave>

=cut

__PACKAGE__->table("EmployeeLeave");

=head1 ACCESSORS

=head2 employeeid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 availablepersonalleaves

  data_type: 'integer'
  is_nullable: 0

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
  "employeeid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "availablepersonalleaves",
  { data_type => "integer", is_nullable => 0 },
  "createdby",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "createdon",
  { data_type => "date", is_nullable => 0 },
  "updatedby",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "updatedon",
  { data_type => "date", is_nullable => 0 },
);

=head1 RELATIONS

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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:lNcM8dCR5J5wJr2IEte2cw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
