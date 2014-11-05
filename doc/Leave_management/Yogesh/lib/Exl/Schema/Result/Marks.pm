use utf8;
package Exl::Schema::Result::Marks;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Exl::Schema::Result::Marks

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<marks>

=cut

__PACKAGE__->table("marks");

=head1 ACCESSORS

=head2 subject

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "subject",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);

=head1 RELATIONS

=head2 

Type: belongs_to

Related object: L<Exl::Schema::Result::Boy>

=cut

__PACKAGE__->belongs_to(
  "",
  "Exl::Schema::Result::Boy",
  { id => "id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-04 16:39:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:axSw+2cQCt5EtzW10GO0og


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
