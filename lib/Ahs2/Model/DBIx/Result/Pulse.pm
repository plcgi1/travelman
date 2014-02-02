package Ahs2::Model::DBIx::Result::Pulse;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Ahs::Model::DBIx::Result::Pulse

=cut

use strict;
use warnings;
use utf8;
use base 'DBIx::Class::Core';

=head1 TABLE: C<pulse>

=cut

__PACKAGE__->table("pulse");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 author_id

  data_type: 'integer'
  is_nullable: 0

=head2 project_id

  data_type: 'integer'
  is_nullable: 0

=head2 created

  data_type: 'integer'
  is_nullable: 0

=head2 updated

  data_type: 'integer'
  is_nullable: 0

=head2 description

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "author_id",
  { data_type => "integer", is_nullable => 0 },
  "project_id",
  { data_type => "integer", is_nullable => 0 },
  "created",
  { data_type => "integer", is_nullable => 0 },
  "updated",
  { data_type => "integer", is_nullable => 0 },
  "description",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2014-02-01 20:06:22
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3Bc5txwO/SyS3iqpzYQAdg


# You can replace this text with custom code or comments, and it will be preserved on regeneration

__PACKAGE__->belongs_to(
  "author",
  "Ahs2::Model::DBIx::Result::User",
  { id => "author_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);
__PACKAGE__->belongs_to(
  "author_info",
  "Ahs2::Model::DBIx::Result::UserInfo",
  { user_id => "author_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);
#__PACKAGE__->belongs_to(
#  "project",
#  "Ahs2::Model::DBIx::Result::Project",
#  { id => "project_id" },
#  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
#);

1;
