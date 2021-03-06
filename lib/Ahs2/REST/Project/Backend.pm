package Ahs2::REST::Project::Backend;
use common::sense;
use Ahs2::REST::ProjectPhoto::Backend;
use base 'Ahs2::REST::Backend';
use Data::Dumper;

sub get {
    my ( $self, $param ) = @_;

    my $config  = $self->get_config;
    my $session = $self->get_session();
    my $formatter = $self->get_formatter();
    my $model = $self->get_model;
  
    my $res;
    if ( $param->{id} ) {
        if ( $param->{id} eq 'new') {
            $res = $self->_get_for_new($param,$model,$formatter);
        }
        else {
            $res = $self->_get_by_id($param,$model,$formatter,$session);
            $res->{photo} = $self->_get_project_photo($param);
        }
        $session->{project} = $res;
		$res = [$res];
    }
    else {
        my @rs = $self->get_model->resultset('Project')->search(
            {

            },
            {
                join => [qw/owner/],
                select => [
					'me.id',
					'me.name',
					'FROM_UNIXTIME(me.created,\'%Y-%m-%d\')',
					'FROM_UNIXTIME(me.updated,\'%Y-%m-%d\')',
					'FROM_UNIXTIME(me.start,\'%Y-%m-%d\')',
					'FROM_UNIXTIME(me.end,\'%Y-%m-%d\')',
					'owner.fname','owner.lname','owner.login', 'owner.id'
				],
                as => [qw/id name created updated start end fname lname login owner_id/],
                order_by => 'me.updated',
                sort_by => 'desc'
            }
        );
        foreach ( @rs ) {
            my $can_edit = '0';

            if ($_->get_column('owner_id') eq $session->{user}->{id}) {
                $can_edit = 1;
            }
			
			my $thumb = $self->_get_project_photo({id=>$_->get_column('id')});
			if ($thumb) {
				$thumb = $thumb->[0]->{thumb};
			}
			else {
				$thumb = $config->{static}->{no_photo};
			}
            push @$res, {
				thumb   => $thumb,
                id      => $_->get_column('id'),
                can_edit=> $can_edit,
                label   => $formatter->encode_utf($_->get_column('name')),
                path    => "#/projects/project/".$_->get_column('id')."/pulse",
                created => $_->get_column('created'),
                updated => $_->get_column('updated'),
                from    => $_->get_column('start'),
                to      => $_->get_column('end'),
                owner   => $_->get_column('login'),
                owner_name => $_->get_column('lname').' '.$_->get_column('fname')
            };
        }
    }
    
    return $res;
}

sub _get_project_photo {
    my($self,$param) = @_;
    my $photo = Ahs2::REST::ProjectPhoto::Backend->new({ config => $self->get_config });
    my $res = $photo->get($param);
    return $res;
}

sub _get_by_id {
    my($self,$param,$model,$formatter,$session) = @_;
    
    my $res;
    #"id" : "3",
    #"name" : "Поездка в Монголию 3",
    #"from" : "2013-01-01",
    #"to" : "2013-04-04",
    #"goals" : [
    #    { "value" : "v1", "label" : "L1" },
    #],
    #"geo" : [
    #    { "latitude" : "55.167596", "longitude" : "28.248897" },
    #],
    #"participants" : [
    #    { "fio" : "user1", "id" : "1", "filename" : "images/no-photo.gif" },
    #]
        
    my $project     = $model->resultset('Project')->single({id => $param->{id} });
    $res->{id}      = $project->get_column('id');
    $res->{name}    = $project->get_column('name');
    $res->{from}    = $formatter->format_ts_ymd($project->get_column('start'));
    $res->{to}      = $formatter->format_ts_ymd($project->get_column('end'));
    $res->{can_edit}= ($project->get_column('owner_id') eq $session->{user}->{id});
        
    my @goals = $model->resultset('Goal')->search({project_id => $param->{id}},{ sort_by => 'name'});
    foreach ( @goals ) {
        #{ "value" : "v1", "label" : "L1" },
        push @{$res->{goals}},{
            id      => $_->get_column('id'),
            name    => $_->get_column('name'),
        };
    }
    unless ( $res->{goals} ) {
        $res->{goals} = [];
    }
    # { "latitude" : "55.167596", "longitude" : "28.248897" },
    my @geo = $model->resultset('PlaceProject')->search(
        { 'me.project_id' => $param->{id} },
        {
            join    => [qw/place/],
            select  => [qw/place.lattitude place.longtitude place.id place.name/],
            as      => [qw/latitude longtitude id name/],
        }
    );
    foreach ( @geo ) {
        push @{$res->{geo}}, {
            lattitude    =>  $_->get_column('latitude'),
            longtitude  =>  $_->get_column('longtitude'),
            id          =>  $_->get_column('id'),
            name        =>  $_->get_column('name'),
        };
    }
    unless ( $res->{geo} ) {
        $res->{geo} = [];
    }
    
    my @users = $model->resultset('UserInfo')->search(
        {},
        {
            join    => [qw/user/],
            select  => [qw/user.login user.fname user.lname me.filename user.id/],
            as      => [qw/login fname lname filename id/],
            order_by => 'user.login'
        }
    );
    my @u_in_project = $model->resultset('UserProject')->search({ project_id => $param->{id} });
    foreach my $user( @users ) {
        my $f = $user->get_column('filename');
        if ( $f ) {
            $f = '/img/users/'.$user->get_column('login').'/'.$f;
        }
        else {
            $f = $self->get_config->{static}->{no_photo};
        }
        my $hash = {
            "fio" => $user->get_column('login'),
            "id" => $user->get_column('id'),
            "filename" => $f,
        };
        foreach my $uip ( @u_in_project ) {
            if ($uip->get_column('project_id') == $param->{id} && $uip->get_column('user_id') == $user->get_column('id') ) {
                $hash->{selected} = 'selected';
            }
        }
        push @{$res->{participants}},$hash;
    }
    
    return $res;
}

sub _get_for_new {
    my($self,$param,$model,$formatter) = @_;
    my $res;
    
    $res->{can_edit}= 1;
    $res->{goals}   = [];
    $res->{geo}     = [];
	# костыль для того чтоб на странице эти даты при создании были установлены
    $res->{from}    = $formatter->format_ts_ymd(time);
    $res->{to}      = $formatter->format_ts_ymd(time);
    $res->{name}    = "";
    $res->{id}      = "new";
    
    my @participants = $model->resultset('User')->outer_users({},{});
    foreach ( @participants ) {
        # me.login,me.lname,me.fname,me.id,up.project_id,ui.filename
        # { "fio" : "user1", "id" : "1", "filename" : "images/no-photo.gif" },
        push @{$res->{participants}},{
            "fio"       => $_->[0],
            "id"        => $_->[3],
            "filename"  => $_->[5] || $self->get_config->{static}->{no_photo}
        };
    }
    return $res;
}

1;

__END__

=head1 Ahs2::REST::Project::Backend


=head2 SYNOPSIS

[TODO]

=head2 DESCRIPTION

[TODO]

=head2 EXAMPLES

[TODO]

=head2 EXPORT

[TODO]

=head2 SEE ALSO

[TODO]

=head2 AUTHOR

plcgi E<lt>plcgi1 at gmail dot com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by plcgi1

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut
