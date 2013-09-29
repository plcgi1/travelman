package Ahs2::REST::ProjectParticipants::Backend;
use strict;
use Ahs2::REST::ProjectPhoto::Backend;
use base 'Ahs2::REST::Project::Backend';
use Data::Dumper;

sub save {
    my ( $self, $param ) = @_;

    my $model       = $self->get_model;
        
    my @parts = $model->resultset('UserProject')->search({
        project_id  => $param->{id}
    });
    foreach ( @parts ) {
        $_->delete;
    }
    foreach ( @{$param->{participants}} ) {
        $model->resultset('UserProject')->find_or_create({
            user_id     => $_,
            project_id  => $param->{id}
        });
    }
    my $res = $self->SUPER::get($param);

    return $res;
}

sub get {
    my ( $self, $param ) = @_;
    my $model       = $self->get_model;
	my $session = $self->get_session();
    my $formatter = $self->get_formatter();
	
    my $res;
    if ($param->{id}) {
        my $rs = $model->resultset('UserInfo')->search(
            { 'user.id' => $param->{id} },
            {
                join => [qw/user/],
                select => ['user.login', 'user.fname', 'user.lname', 'me.filename', 'user.id', 'user.quality', 'FROM_UNIXTIME(me.birth,\'%Y-%m-%d\')'],
                as => [qw/login fname lname filename id quality birth/],
                order_by => 'user.login'
            }
        )->single;
        my $f = $rs->get_column('filename');
            if ( $f ) {
                $f = '/img/users/'.$rs->get_column('login').'/'.$f;
            }
            else {
                $f = '/img/users/no-photo.gif';
            }
            my $fio;
            unless ( $rs->get_column('fname') && $rs->get_column('lname')) {
                $fio = $rs->get_column('login');
            }
            else {
                $fio = $rs->get_column('lname').' '.$rs->get_column('fname');
            }
        $res = [
            {
                "fio"       => $fio,
                "login"     => $rs->get_column('login'),
                "id"        => $rs->get_column('id'),
                quality     => $rs->get_column('quality'),
                "filename"  => $f ,
				"birth"     => $rs->get_column('birth'),
				"projects" => $self->_get_projects({ session => $session, formatter => $formatter, model => $model,user_id => $param->{id} })
            }
        ];
    }
    else {
        my @rs = $model->resultset('UserInfo')->search(
            {},
            {
                join => [qw/user/],
                select => [qw/user.login user.fname user.lname me.filename user.id/],
                as => [qw/login fname lname filename id/],
                order_by => 'user.login'
            }
        );
        foreach ( @rs ) {
            my $f = $_->get_column('filename');
            if ( $f ) {
                $f = '/img/users/'.$_->get_column('login').'/'.$f;
            }
            else {
                $f = '/img/users/no-photo.gif';
            }
            my $fio;
            unless ( $_->get_column('fname') && $_->get_column('lname')) {
                $fio = $_->get_column('login');
            }
            else {
                $fio = $_->get_column('lname').' '.$_->get_column('fname');
            }
            push @$res,{
                "fio" => $fio,
                "login" => $_->get_column('login'),
                "id" => $_->get_column('id'),
                "filename" => $f ,
				
            };
        }   
    }
    return $res;
}

sub _get_projects {
	my($self,$param) = @_;
	my @rs = $param->{model}->resultset('UserProject')->search(
		{
			'me.user_id' => $param->{user_id}
		},
		{
			join => [qw/project/],
			select => [
				'project.id', 'project.name',
				'FROM_UNIXTIME(project.created,\'%Y-%m-%d\')',
				'FROM_UNIXTIME(project.updated,\'%Y-%m-%d\')',
				'FROM_UNIXTIME(project.start,\'%Y-%m-%d\')',
				'FROM_UNIXTIME(project.end,\'%Y-%m-%d\')',
				'project.owner_id'
			],
			as => [qw/id name created updated start end owner_id/],
			order_by => 'updated',
			sort_by => 'desc'
		}
	);
	my $photo = Ahs2::REST::ProjectPhoto::Backend->new({ config => $self->get_config });
	my @res;
	foreach ( @rs ) {
		my $can_edit = '0';
		if ($_->get_column('owner_id') eq $param->{session}->{user}->{id}) {
			$can_edit = 1;
		}
		
		my $thumb = $photo->get({id=>$_->get_column('id')});
		if ($thumb) {
			$thumb = $thumb->[0]->{thumb};
		}
		else {
			$thumb = '/images/no-photo.gif';
		}
		push @res, {
			thumb   => $thumb,
			id      => $_->get_column('id'),
			can_edit=> $can_edit,
			label   => $param->{formatter}->encode_utf($_->get_column('name')),
			path    => "#/projects/project/".$_->get_column('id')."/view",
			created => $_->get_column('created'),
			updated => $_->get_column('updated'),
			from    => $_->get_column('start'),
			to      => $_->get_column('end')
		};
	}
	return \@res;
}
1;

__END__

=head1 Ahs2::REST::ProjectParticipants::Backend


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
