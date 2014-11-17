use utf8;
package MyApp::Schema::Result::SystemConfig;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::SystemConfig

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

=head1 TABLE: C<SystemConfig>

=cut

__PACKAGE__->table("SystemConfig");

=head1 ACCESSORS

=head2 configkey

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 configvalue

  data_type: 'varchar'
  is_nullable: 1
  size: 10

=cut

__PACKAGE__->add_columns(
  "configkey",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "configvalue",
  { data_type => "varchar", is_nullable => 1, size => 10 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-14 11:35:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ULsy7bFOsn0yM2y5w237ZA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
