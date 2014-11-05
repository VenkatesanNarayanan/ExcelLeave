use utf8;
package Exl::Schema::Result::Department;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Exl::Schema::Result::Department

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<department>

=cut

__PACKAGE__->table("department");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 0

=head2 dept

  data_type: 'char'
  is_nullable: 0
  size: 50

=head2 emp_id

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 0 },
  "dept",
  { data_type => "char", is_nullable => 0, size => 50 },
  "emp_id",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-04 16:39:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:wcOMhxX24PIJUtpHbNqRFQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
