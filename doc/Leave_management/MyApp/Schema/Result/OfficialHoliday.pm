use utf8;
package MyApp::Schema::Result::OfficialHoliday;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::OfficialHoliday

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

=head1 TABLE: C<OfficialHolidays>

=cut

__PACKAGE__->table("OfficialHolidays");

=head1 ACCESSORS

=head2 holidaydate

  data_type: 'date'
  is_nullable: 0

=head2 holidayoccasion

  data_type: 'varchar'
  is_nullable: 0
  size: 150

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
  "holidaydate",
  { data_type => "date", is_nullable => 0 },
  "holidayoccasion",
  { data_type => "varchar", is_nullable => 0, size => 150 },
  "createdby",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "createdon",
  { data_type => "date", is_nullable => 0 },
  "updatedby",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "updatedon",
  { data_type => "date", is_nullable => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-14 11:35:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:wu4m5dPbkz3RfOtGPTQL9Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
