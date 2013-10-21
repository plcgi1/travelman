package Ahs2::REST::Auth::Backend;
use common::sense;
use Digest::SHA1 qw/sha1_hex/;
use Digest::MD5 qw/md5_hex/;
use JSON::XS qw/encode_json decode_json/;
use base 'Ahs2::REST::Backend';
use Data::Dumper;

__PACKAGE__->mk_accessors(qw/mode/);

# length for message sign
my $DEFAULT_LENGTH = 64;

# length for idKey
my $DEFAULT_UNIQID_LENGTH = 12;

my $DEFAULT_TTL = 86400;

sub default {
    return {
        length          => $DEFAULT_LENGTH,
        uniqid_length   => $DEFAULT_UNIQID_LENGTH,
        ttl             => $DEFAULT_TTL
    };
}

sub login {
    my ( $self, $param ) = @_;

    my $config  = $self->get_config;
    my $session = $self->get_session();
    my $res;
	
	if ( $session->{user} && $session->{user}->{id} ) {
		$res = { location => '/app/index.html'  };
	}
	else {
		my @user = $self->get_model()->resultset('User')->search(
			{
				'me.login'       => $param->{login},
				'me.password'    => md5_hex($param->{password})
			},
			{
				limit   => 1
			}
		);
		if ( $user[0] ) {
			# get ACL user data
			$res->{acl} = $self->_get_acl_data($user[0]);
			# create token with TTL
			# set ACL user data to response
			$res->{token} = $self->_uniqid();
			
			# save ACL user data to fast_storage with token
			$param->{ttl} ||= $self->default->{ttl};
			$self->get_session->{acl} 	= $res->{acl}->{page};
			$self->get_session->{rest} 	= $res->{acl}->{rest};
			
			my $user = {
				id 				=> $user[0]->get_column('id'),
				email 			=> $user[0]->get_column('email'),
				login 			=> $user[0]->get_column('login'),
				fname 			=> $user[0]->get_column('fname'),
				lname 			=> $user[0]->get_column('lname'),
				mname 			=> $user[0]->get_column('mname'),
				email_confirmed => $user[0]->get_column('email_confirmed'),
                loginStatus 	=> 1
			};
			if ( $user[0]->get_column('settings') ) {
				$user->{settings} = decode_json($user[0]->get_column('settings'));
			}
			$self->get_session->{user} 	= $user;
			
			my $default_page = $res->{acl}->{page}->[0];
			
			$self->get_session->{active_page} = $default_page->{name};
			if ( $default_page->{children} ) {
				$self->get_session->{active_subpage} = $default_page->{children}->[0]->{name};	
			}
						
			$res = { location => '/app/index.html'  };
		} # END if ( $user[0] )
	}
    
    return $res;
}

sub login_via_provider {
    my ( $self, $param ) = @_;

    my $config  = $self->get_config;
    my $session = $self->get_session();
    my $res;
	if ( $session->{user}) {
		$res = { location => '/app/index.html'  };
	}
	else {
		my $user = $self->get_model()->resultset('User')->find_or_create(
			{
				'me.email'       => $param->{email}
			},
		);
		if ( $user ) {
			$user->actions('[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]');
			$user->updated(time);
			$user->login($param->{username});
			$user->fname($param->{first_name});
			$user->lname($param->{first_name});
			$user->from_provider($param->{provider});
			$user->update();
			
			$user->user_info->find_or_create({user_id => $user->id });
			# get ACL user data
			$res->{acl} = $self->_get_acl_data($user);
			# create token with TTL
			# set ACL user data to response
			$res->{token} = $self->_uniqid();
			
			# save ACL user data to fast_storage with token
			$param->{ttl} ||= $self->default->{ttl};
			$self->get_session->{acl} 	= $res->{acl}->{page};
			$self->get_session->{rest} 	= $res->{acl}->{rest};
			
			my $user = {
				id => $user->get_column('id'),
				email => $user->get_column('email'),
				login => $user->get_column('login'),
				fname => $user->get_column('fname'),
				lname => $user->get_column('lname'),
				mname => $user->get_column('mname'),
				email_confirmed => $user->get_column('email_confirmed'),
                loginStatus => 1
			};
			
			$self->get_session->{user} 	= $user;
			
			my $default_page = $res->{acl}->{page}->[0];
			
			$self->get_session->{active_page} = $default_page->{name};
			if ( $default_page->{children} ) {
				$self->get_session->{active_subpage} = $default_page->{children}->[0]->{name};	
			}
						
			$res = { location => '/app/index.html'  };
		} # END if ( $user[0] )
	}
    
    return $res;
}

sub isauth {
    my ( $self, $param ) = @_;

    my $config  = $self->get_config;
    my $session = $self->get_session();
    
    # make return with values - for tests
    my $res = $self->get_session->{user};

    return $res;

}

sub has_access {
    my ( $self, $param ) = @_;

    my $config  = $self->get_config;
    my $session = $self->get_session();
    
    # make return with values - for tests
    my $res = { status => 'ok' };

    return $res;
}


sub logout {
    my ( $self, $param ) = @_;

    my $config  = $self->get_config;
    my $session = $self->get_session();
    
    delete $self->get_session->{user};
    # make return with values - for tests
    my $res = { loginStatus => '0' };

    return $res;

}

sub _get_acl_data {
    my ($self,$user,$active) = @_;
    my $action_id_array = decode_json($user->get_column('actions'));
    my @actions = $self->get_model()->resultset('Action')->search(
		{
	        id      => { -in => $action_id_array },
			type    => 'page'
	    },
		{
			order_by => qw/order_by/
		}
	);
    my $debug = $self->get_config->{debug};
    
    my (%hash,@res,@rest_acl);
    if ( $actions[0] ) {
        foreach ( @actions ) {
            my $h = {
                #page    		=> $_->get_column('page'),
                name    		=> $_->get_column('name'),
                path    		=> $_->get_column('path'),
                title   		=> $_->get_column('description'),
				is_public       => $_->get_column('is_public'),
				type    		=> $_->get_column('type'),
                parentid 		=> $_->get_column('parentid') || "0",
                method_types 	=> decode_json($_->get_column('method_type')), 
                id 				=> $_->get_column('id'),
				#hide_from_menu	=> $_->get_column('hide_from_menu'),
            };
            if ( $_->get_column('parentid') ){
                push @{$hash{$_->get_column('parentid')}->{children}},$h;
            }
            else {
                foreach my $key(keys %$h) {
                    $hash{$_->get_column('id')}->{$key} = $h->{$key};
                }
            }
        }
        my $last;
        foreach ( keys %hash ) {
            if( $hash{$_}->{name} eq 'LOGOUT' ){
                $last = $hash{$_};
            }
            else {
                $hash{$_}->{hide} = 1;
                push @res,$hash{$_};
            }
        }
		@actions = $self->get_model()->resultset('Action')->search(
			{
				id      => { -in => $action_id_array },
				type    => 'rest'
			},
			{
				order_by => qw/order_by/
			}
		);
		
		foreach ( @actions ) {
            my $h = {
                name    		=> $_->get_column('name'),
                path    		=> $_->get_column('path'),
				type    		=> $_->get_column('type'),
				is_public       => $_->get_column('is_public'),
                parentid 		=> $_->get_column('parentid') || "0",
                method_types 	=> decode_json($_->get_column('method_type')), 
                id 				=> $_->get_column('id'),
				#hide_from_menu 	=> $_->get_column('hide_from_menu'),
            };
			push @rest_acl,$h;
        }
        #push @res,$last;
    }
	 
    
    my $res = { page => \@res, rest => \@rest_acl };
	
	return $res;
}

sub _uniqid {
    my ($self,$length) = @_;

    my $unique = $ENV{UNIQUE_ID} || ( [] . rand() );
    $length ||= $self->default->{length};
    my $res = substr(
        Digest::MD5::md5_hex( Time::HiRes::gettimeofday() . $unique ),
        0,
        $length
    );
            
    return $res;
}

1;

__END__

=head1 Ahs2::REST::Auth::Backend


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
