use utf8;
package Exl::Schema::Result::Company;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Exl::Schema::Result::Company

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<company>

=cut

__PACKAGE__->table("company");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 age

  data_type: 'integer'
  is_nullable: 0

=head2 address

  data_type: 'char'
  is_nullable: 1
  size: 50

=head2 salary

  data_type: 'real'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
  "age",
  { data_type => "integer", is_nullable => 0 },
  "address",
  { data_type => "char", is_nullable => 1, size => 50 },
  "salary",
  { data_type => "real", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-04 16:39:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TvGDx6dRW1h9tbtj9TAOHQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
