use utf8;
package MyApp::Schema::Result::FEmployee;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::FEmployee

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

=head1 TABLE: C<f_employee>

=cut

__PACKAGE__->table("f_employee");

=head1 ACCESSORS

=head2 id

  data_type: 'varchar'
  is_nullable: 0
  size: 10

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 team_id

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "varchar", is_nullable => 0, size => 10 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "team_id",
  { data_type => "varchar", is_nullable => 1, size => 20 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 f_teams

Type: has_many

Related object: L<MyApp::Schema::Result::FTeam>

=cut

__PACKAGE__->has_many(
  "f_teams",
  "MyApp::Schema::Result::FTeam",
  { "foreign.manager_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-14 11:35:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:xTJYFbMTTfrnjV1CLYK7Pg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
