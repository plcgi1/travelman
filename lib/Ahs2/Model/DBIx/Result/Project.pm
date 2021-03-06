use utf8;
package Ahs2::Model::DBIx::Result::Project;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Ahs2::Model::DBIx::Result::Project

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<project>

=cut

__PACKAGE__->table("project");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=head2 created

  data_type: 'integer'
  is_nullable: 0

=head2 updated

  data_type: 'integer'
  is_nullable: 0

=head2 owner_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "created",
  { data_type => "integer", is_nullable => 0 },
  "updated",
  { data_type => "integer", is_nullable => 0 },
  "start",
  { data_type => "integer", is_nullable => 0 },
  "end",
  { data_type => "integer", is_nullable => 0 },
  "owner_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "status",
  { data_type => "varchar", is_nullable => 1, size => 20 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 goals

Type: has_many

Related object: L<Ahs2::Model::DBIx::Result::Goal>

=cut

__PACKAGE__->has_many(
  "goals",
  "Ahs2::Model::DBIx::Result::Goal",
  { "foreign.project_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 owner

Type: belongs_to

Related object: L<Ahs2::Model::DBIx::Result::User>

=cut

__PACKAGE__->belongs_to(
  "owner",
  "Ahs2::Model::DBIx::Result::User",
  { id => "owner_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 place_project_projects

Type: has_many

Related object: L<Ahs2::Model::DBIx::Result::PlaceProject>

=cut

__PACKAGE__->has_many(
  "place_project_projects",
  "Ahs2::Model::DBIx::Result::PlaceProject",
  { "foreign.project_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 place_project_projects_2s

Type: has_many

Related object: L<Ahs2::Model::DBIx::Result::PlaceProject>

=cut

__PACKAGE__->has_many(
  "place_project_projects_2s",
  "Ahs2::Model::DBIx::Result::PlaceProject",
  { "foreign.project_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 place_project_projects_3s

Type: has_many

Related object: L<Ahs2::Model::DBIx::Result::PlaceProject>

=cut

__PACKAGE__->has_many(
  "place_project_projects_3s",
  "Ahs2::Model::DBIx::Result::PlaceProject",
  { "foreign.project_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_projects

Type: has_many

Related object: L<Ahs2::Model::DBIx::Result::UserProject>

=cut

__PACKAGE__->has_many(
  "user_projects",
  "Ahs2::Model::DBIx::Result::UserProject",
  { "foreign.project_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07022 @ 2013-02-10 00:53:04
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:kZDgQHi8M2ywN/oZenim9g


# You can replace this text with custom code or comments, and it will be preserved on regeneration

__PACKAGE__->resultset_class('Ahs2::Model::DBIx::Result::Project::Resultset');

package Ahs2::Model::DBIx::Result::Project::Resultset;

use strict;
use base qw/DBIx::Class::ResultSet/;
use Log::Log4perl qw/get_logger/;

my $logger = Log::Log4perl->get_logger('Ahs2.Model.DBIx.Result.Project.Resultset');

sub is_user_in_owner_projects {
    my ($self, $project_owner_id, $user_id ) = @_;
  
    my $sql = 'SELECT count(*) AS existed FROM project me JOIN user_project u ON me.id=u.project_id WHERE me.owner_id=? AND u.user_id=? LIMIT 1';
    my $dbh = $self->result_source->storage->dbh;
    my $rs = $dbh->selectall_arrayref($sql,{ Slice => {} }, $project_owner_id, $user_id );
    my $res = ( $rs ? 1 : 0 );
    return $res;
}
1;
