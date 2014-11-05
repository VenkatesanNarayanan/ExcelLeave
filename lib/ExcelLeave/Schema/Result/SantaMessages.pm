use utf8;
package ExcelLeave::Schema::Result::SantaMessages;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ExcelLeave::Schema::Result::SantaMessages

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<santa_messages>

=cut

__PACKAGE__->table("santa_messages");

=head1 ACCESSORS

=head2 msg_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'santa_messages_msg_id_seq'

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 receiver_id

  data_type: 'integer'
  is_nullable: 1

=head2 msg

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=cut

__PACKAGE__->add_columns(
  "msg_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "santa_messages_msg_id_seq",
  },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "receiver_id",
  { data_type => "integer", is_nullable => 1 },
  "msg",
  { data_type => "varchar", is_nullable => 1, size => 100 },
);

=head1 PRIMARY KEY

=over 4

=item * L</msg_id>

=back

=cut

__PACKAGE__->set_primary_key("msg_id");

=head1 RELATIONS

=head2 user

Type: belongs_to

Related object: L<ExcelLeave::Schema::Result::SecreteSanta>

=cut

__PACKAGE__->belongs_to(
  "user",
  "ExcelLeave::Schema::Result::SecreteSanta",
  { user_id => "user_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-05 12:45:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:bZQ0lWC8mNCf8VkKjO+GLQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
