package Ahs2::REST::Settings::Backend;
use common::sense;
use Digest::MD5 qw/md5_hex/;
use Encode qw(from_to decode is_utf8);
use base 'Ahs2::REST::Backend';
use Data::Dumper;

sub save {
    my ( $self, $param ) = @_;

    my $config  = $self->get_config;
    my $session = $self->get_session();
    my $model = $self->get_model;
    my $fmt = $self->get_formatter();
	
    my $user = $model->resultset('User')->search(
        { id => $session->{user}->{id} },
    )->single();
    my $is_edit;
    foreach (qw/fname lname mname quality/) {
        if ($param->{$_}) {
            $user->$_($param->{$_});
            $is_edit++;
        }
    }
	
    if ($is_edit) {
        $user->update();
    }
	if ($param->{birth}) {
		my $birth    = (split 'T',$param->{birth})[0];
		$birth = \"UNIX_TIMESTAMP('$birth')";
		my $user_info = $user->user_info->single;
		$user_info->birth($birth);
		$user_info->update();
	}
    my $res = $self->get($param);
    return $res;
}

sub get {
    my ( $self, $param ) = @_;

    my $config  = $self->get_config;
    my $session = $self->get_session();
    my $model = $self->get_model;
	my $fmt = $self->get_formatter();
	
    my $user_info = $model->resultset('UserInfo')->search(
        { user_id => $session->{user}->{id} },
        {
            join => [qw/user/],
            select => ['me.content_type', 'me.size', 'me.filename', 'user.fname', 'user.mname', 'user.lname', 'user.quality', 'FROM_UNIXTIME(me.birth,\'%Y-%m-%d\')'],
            as => [qw/content_type size filename fname mname lname quality birth/]
        }
    )->single();
    	
    my $filename = $user_info->get_column('filename');
    
    #my $ext = (split '\.',$filename)[-1];
    #my $filename_hash = md5_hex($filename).'.'.$ext;
    # make return with values - for tests
    my $res = {
        mydata  => {
            fname => $user_info->get_column('fname'),
            mname => $user_info->get_column('mname'),
            lname => $user_info->get_column('lname'),
            quality => $user_info->get_column('quality'),
			birth   => $user_info->get_column('birth'),
        },
        myphoto => {
            content_type    => $user_info->get_column('content_type'),
            size            => $user_info->get_column('size'),
            filename        => $filename,
            path            => $config->{static}->{user_profile_path}.'/'.$session->{user}->{login}.'/'.$filename
        }
    };

    return $res;

}

1;

__END__

=head1 Ahs2::REST::Settings::Backend


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
