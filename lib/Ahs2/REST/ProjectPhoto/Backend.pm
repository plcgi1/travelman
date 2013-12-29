package Ahs2::REST::ProjectPhoto::Backend;
use common::sense;
use base 'Ahs2::Component::Upload::Backend';
use Data::Dumper;
use Dir::Iterate;

sub save {
    my ( $self, $param ) = @_;

    my $config  = $self->get_config;
    my $session = $self->get_session();
    
    my $res;

    $param->{file} = $self->get_request->uploads->{file};
    if ( $param->{file} ) {
        $param->{out_dir} = $config->{app_root}.'/public'.$config->{static}->{project_profile_path}.'/'.$param->{project_id};
        $param->{clear} = 1;
        $res = $self->save_file($param);
        $res->{id} = $param->{project_id};
        $res = $self->get($res);
    }
    
    return $res;
}

sub get {
    my ( $self, $param ) = @_;

    my $config  = $self->get_config;
    my $session = $self->get_session();
    
    my $web_path = $config->{static}->{project_profile_path}.'/'.$param->{id};
    
    my $full_path = $config->{app_root}.'/public'.$web_path;
    my @f = mapdir { (split '/')[-1] } $full_path;
	
    my $fname ;
    my $thumb;
    
    foreach (@f) {
        next if $_ eq '.';
        next if $_ eq '..';
        
        if ( $_=~/^120/) {
            $thumb = $web_path.'/'.$_;
        }
        else {
            $fname = $web_path.'/'.$_;
        }
    }
    my $res;
    if (-f $config->{app_root}.'/public/'.$fname) {
        # make return with values - for tests
        $res = [{ path => $fname, thumb => $thumb }];
    }       

    return $res;

}


sub remove {
    my ( $self, $param ) = @_;

    my $config  = $self->get_config;
    my $session = $self->get_session();
    
    # make return with values - for tests
    my $res = { status => 'ok' };

    return $res;

}



1;

__END__

=head1 Ahs2::REST::ProjectPhoto::Backend


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
