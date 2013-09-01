package Ahs2::REST::MyPassword::Backend;
use common::sense;
use Digest::MD5 qw/md5_hex/;
use base 'Ahs2::REST::Backend';
use Data::Dumper;

sub save {
    my ( $self, $param ) = @_;

    my $config  = $self->get_config;
    my $session = $self->get_session();
    my $model = $self->get_model;
    
    my $user_info = $model->resultset('User')->search(
        { id => $session->{user}->{id} },
    )->single();
        
    if ( md5_hex($param->{password}) ne md5_hex($user_info->get_column('password'))) {
        $user_info->password(md5_hex($param->{password}));
        $user_info->update();
    }
    # make return with values - for tests
    my $res = { status => 'ok' };

    return $res;

}



1;

__END__

=head1 Ahs2::REST::MyPassword::Backend


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
