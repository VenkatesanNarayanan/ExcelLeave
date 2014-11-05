use utf8;
package ExcelLeave::Schema::Result::SecreteSanta;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ExcelLeave::Schema::Result::SecreteSanta

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<secrete_santa>

=cut

__PACKAGE__->table("secrete_santa");

=head1 ACCESSORS

=head2 user_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'secrete_santa_user_id_seq'

=head2 username

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 partner_name

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=cut

__PACKAGE__->add_columns(
  "user_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "secrete_santa_user_id_seq",
  },
  "username",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "partner_name",
  { data_type => "varchar", is_nullable => 1, size => 30 },
);

=head1 PRIMARY KEY

=over 4

=item * L</user_id>

=back

=cut

__PACKAGE__->set_primary_key("user_id");

=head1 RELATIONS

=head2 santa_messages

Type: has_many

Related object: L<ExcelLeave::Schema::Result::SantaMessages>

=cut

__PACKAGE__->has_many(
  "santa_messages",
  "ExcelLeave::Schema::Result::SantaMessages",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-05 12:45:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:q/iHtHz3Jyf5Lmu80WDFKw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
