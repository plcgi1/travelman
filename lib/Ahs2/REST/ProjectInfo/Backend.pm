package Ahs2::REST::ProjectInfo::Backend;
use common::sense;
use Ahs2::REST::ProjectPhoto::Backend;
use base 'Ahs2::REST::Project::Backend';

use Data::Dumper;

sub save {
    my ( $self, $param ) = @_;

    my $config      = $self->get_config;
    my $session     = $self->get_session();
    my $formatter   = $self->get_formatter();
    my $model       = $self->get_model;
    my $res;
    
    my $from    = (split 'T',$param->{from})[0];
    my $to      = (split 'T',$param->{to})[0];
    
    if ($param->{id} eq 'new') {
        
        $res = {
            name    => $param->{name},
            created => time,
            updated => time,
            start   => $formatter->to_uts({date=>$from}),
            end     => $formatter->to_uts({date=>$to}),
            status  => 'started',
            owner_id => $session->{user}->{id},            
        };
        
        my $rs = $model->resultset('Project')->create($res);
        $res->{id} = $rs->get_column('id');
    }
    else {
        my $rs = $model->resultset('Project')->single({ id => $param->{id} });
        if ( $rs ) {
            $res = {
                id      => $param->{id},
                name    => $param->{name},
                updated => time,
                start   => $formatter->to_uts({date => $from}),
                end     => $formatter->to_uts({date => $to}),
                owner_id => $session->{user}->{id},
                
            };
            foreach(keys %$res) {
                $rs->$_($res->{$_});
            }
            $rs->update();
        }
    }
    
    if ($res) {
        
        $res = $self->get($res);
    }
    
    return $res;

}


1;

__END__

=head1 Ahs2::REST::ProjectInfo::Backend


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
