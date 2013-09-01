package Ahs2::REST::MyPassword::Engine;
use strict;
use Data::Dumper;
use JSON::XS;
use URI::Escape qw/uri_unescape/;
use IO::File;
use WOA::Validator::ErrorCode;
use parent 'Ahs2::REST::Engine';

__PACKAGE__->mk_accessors(qw/model session formatter config logger res/);

sub validate {
    my( $self,$validator,$args )=@_;
    
    my $config = $self->backend->get_config;
    my $fmt = $self->formatter;
    
    # делаем стандартную валидацию
    my $res = $self->SUPER::validate($validator,$args);
    if( ref $res eq 'WOA::REST::Error' ){
        return $self->set_error($res->status,$res->message);
    }
    
    if ( $self->request->method eq 'POST' ){
        if ( $args->[0]->{value} ne $args->[1]->{value} ) {
            $res = WOA::Validator::ErrorCode->new();
            $res->errorFields([
                { name => 'password', error => $fmt->encode_utf('Пароли должны совпадать') }
            ]);
        }
        
    }
    return $res;
}

sub process {
    my($self,$query_args)=@_;
    
    $self->SUPER::process($query_args);
    
    return;
}


1;


__END__

=head1 NAME

Ahs::REST::Engine - extended WOA::REST::Engine engine for Maillist

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
