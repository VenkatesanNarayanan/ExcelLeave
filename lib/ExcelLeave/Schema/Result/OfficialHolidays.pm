use utf8;
package ExcelLeave::Schema::Result::OfficialHolidays;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ExcelLeave::Schema::Result::OfficialHolidays

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<OfficialHolidays>

=cut

__PACKAGE__->table("OfficialHolidays");

=head1 ACCESSORS

=head2 HolidayDate

  data_type: 'date'
  is_nullable: 0

=head2 HolidayOccasion

  data_type: 'varchar'
  is_nullable: 0
  size: 150

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
  "HolidayDate",
  { data_type => "date", is_nullable => 0 },
  "HolidayOccasion",
  { data_type => "varchar", is_nullable => 0, size => 150 },
  "CreatedBy",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "CreatedOn",
  { data_type => "date", is_nullable => 0 },
  "UpdatedBy",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "UpdatedOn",
  { data_type => "date", is_nullable => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-05 12:45:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:iHDOqShu+H2YaHjYE1ZbeA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
