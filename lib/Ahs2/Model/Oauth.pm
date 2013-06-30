package Ahs2::Model::Oauth;
use strict;
use Ahs2::REST::Auth::Backend;
use base 'Class::Accessor::Fast';

__PACKAGE__->mk_accessors(qw/model config session/);

sub login {
	my($self,$user_data,$provider) = @_;
	
	my $backend = Ahs2::REST::Auth::Backend->new({ model => $self->model,config=>$self->config,session => $self->session});
	my $res = $backend->login_via_provider($user_data);
	
	return $res;
}

1;