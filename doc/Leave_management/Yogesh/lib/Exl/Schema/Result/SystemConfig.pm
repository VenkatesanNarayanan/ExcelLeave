use utf8;
package Exl::Schema::Result::SystemConfig;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Exl::Schema::Result::SystemConfig

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<SystemConfig>

=cut

__PACKAGE__->table("SystemConfig");

=head1 ACCESSORS

=head2 ConfigKey

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 ConfigValue

  data_type: 'varchar'
  is_nullable: 1
  size: 10

=cut

__PACKAGE__->add_columns(
  "ConfigKey",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "ConfigValue",
  { data_type => "varchar", is_nullable => 1, size => 10 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-04 16:39:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pIF93BRuWfYWJECCl5C19Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
