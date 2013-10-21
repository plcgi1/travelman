package Ahs2::REST::Settings::Backend;
use common::sense;
use Digest::MD5 qw/md5_hex/;
use Encode qw(from_to decode is_utf8);
use JSON::XS qw/decode_json encode_json/;
use base 'Ahs2::REST::Backend';
use Data::Dumper;

sub save {
    my ( $self, $param ) = @_;

    my $config  = $self->get_config;
    my $session = $self->get_session();
    my $model 	= $self->get_model;
    my $fmt 	= $self->get_formatter();
	
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
	my $restricts;
	foreach ( qw/view_passport_data/ ) {
		$restricts->{$_} = $param->{$_};
	}
	if ($restricts) {
		$user->settings(encode_json($restricts));
		$is_edit++;
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
        { 'user.id' => $session->{user}->{id} },
        {
            join => [qw/user passport/],
            select => [
				'me.content_type',
				'me.size',
				'me.filename',
				'user.fname',
				'user.mname',
				'user.lname',
				'user.settings',
				'user.quality',
				'FROM_UNIXTIME(me.birth,\'%Y-%m-%d\')',
				'FROM_UNIXTIME(passport.dob,\'%Y-%m-%d\')',
				'passport.pob',
				'FROM_UNIXTIME(passport.received,\'%Y-%m-%d\')',
				'passport.serial',
				'passport.org',
				'passport.number','passport.latin_fname','passport.latin_lname'
			],
            as => [qw/content_type size filename fname mname lname settings quality birth dob pob received serial org number latin_fname latin_lname/]
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
            path            => $config->{static}->{user_profile_path}.'/'.$session->{user}->{login}.'/'.$filename,
			
        },
		passport        => {
			latin_fname => $user_info->get_column('latin_fname'),
			latin_lname => $user_info->get_column('latin_lname'),
			serial    => $user_info->get_column('serial'),
			number    => $user_info->get_column('number'),
			dob       => $user_info->get_column('dob'),
			pob       => $user_info->get_column('pob'),
			received  => $user_info->get_column('received'),
			org       => $user_info->get_column('org'),
		}
	};
	if ( $user_info->get_column('settings') ) {
		$res->{myrestrict} = decode_json($user_info->get_column('settings'));
	}
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
