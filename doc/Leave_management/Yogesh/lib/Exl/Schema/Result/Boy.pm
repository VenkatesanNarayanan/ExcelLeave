use utf8;
package Exl::Schema::Result::Boy;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Exl::Schema::Result::Boy

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<boy>

=cut

__PACKAGE__->table("boy");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 1

=head2 age

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 1 },
  "age",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 marks

Type: has_many

Related object: L<Exl::Schema::Result::Marks>

=cut

__PACKAGE__->has_many(
  "marks",
  "Exl::Schema::Result::Marks",
  { "foreign.id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-04 16:39:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OAahtomyD4FRgcVVouNm2A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
