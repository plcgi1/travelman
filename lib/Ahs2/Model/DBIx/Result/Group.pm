use utf8;
package Ahs2::Model::DBIx::Result::Group;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Ahs::Model::DBIx::Result::Group

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<groups>

=cut

__PACKAGE__->table("groups");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 title

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 created

  data_type: 'integer'
  is_nullable: 1

=head2 updated

  data_type: 'integer'
  is_nullable: 1

=head2 creator_id

  data_type: 'integer'
  is_nullable: 1

=head2 updater_id

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "title",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "created",
  { data_type => "integer", is_nullable => 1 },
  "updated",
  { data_type => "integer", is_nullable => 1 },
  "creator_id",
  { data_type => "integer", is_nullable => 1 },
  "updater_id",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-09-29 18:08:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:BwV+B/pCDulM7ZBr8OpwEg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
