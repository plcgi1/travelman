package Ahs2::REST::MyQuality::Backend;
use common::sense;
use base 'Ahs2::Component::Upload::Backend';
use Data::Dumper;

sub save {
    my ( $self, $param ) = @_;

    my $config  = $self->get_config;
    my $session = $self->get_session();
    my $model   = $self->get_model;
    my $fmt     = $self->get_formatter;
        
    $param->{file} = $self->get_request->uploads->{file};
    
    my $files = $self->get();
    if ( $param->{file}->filename ) {
        $param->{out_dir} = $config->{app_root}.'/public'.$config->{static}->{user_profile_path}.'/'.$session->{user}->{login}.'/myquality';
	    
        my $file_data = $self->save_file($param);
        
        my $rs = $model->resultset('UserQualityFile')->find_or_create({
            user_id         => $session->{user}->{id},
            filename        => $file_data->{filename},
            type            => $file_data->{type},
            size            => $file_data->{size},
            original_name   => $file_data->{original_name},
            path            => $config->{static}->{user_profile_path}.'/'.$session->{user}->{login}.'/myquality/'.$file_data->{filename}
        });
        $file_data->{path} = $rs->get_column('path');
        $file_data->{id} = $rs->get_column('id');
        push @{$files->{myquality}},$file_data;
    }        
    
    # make return with values - for tests
    
    return $files;
}


sub get {
    my ( $self, $param ) = @_;

    my $config  = $self->get_config;
    my $session = $self->get_session();
    my $model   = $self->get_model;
    my $fmt     = $self->get_formatter;
    
    my @rs = $model->resultset('UserQualityFile')->search(
        {'user_id' => $session->{user}->{id} },
    );
    my @res;
    foreach (@rs) {
        push @res,{
            id    => $_->get_column('id'),
            filename    => $_->get_column('filename'),
            path        => $_->get_column('path'),
            type        => $_->get_column('type'),
            size        => $_->get_column('size'),
            original_name   => $_->get_column('original_name'),
        };
    }
    return { myquality => \@res };
}


sub remove {
    my ( $self, $param ) = @_;

    my $config  = $self->get_config;
    my $session = $self->get_session();
    my $model   = $self->get_model;
    my $fmt     = $self->get_formatter;
    
    my $rs = $model->resultset('UserQualityFile')->search({ id => $param->{id}})->single();
    if ($rs) {
        $rs->delete;
        $param->{out_dir} = 'myquality';
        $self->remove_file({filename => $rs->get_column('filename'), out_dir => 'myquality' });
    }
    # make return with values - for tests
    my $res = $self->get;

    return $res->{myquality};

}



1;

__END__

=head1 Ahs2::REST::MyQuality::Backend


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
