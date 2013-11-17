package Ahs2::REST::ProjectPlace::Backend;
use common::sense;
use base 'Ahs2::REST::Project::Backend';
use Data::Dumper;

sub save {
   my ( $self, $param ) = @_;

    my $model       = $self->get_model;
    my $res = { res => 'ok' };
    
    my @geo = $model->resultset('PlaceProject')->search(
        {
            'me.project_id' 	=> $param->{id},
			'me.place_id'         => $param->{location_id}
        },
        {
            join    => [qw/place/],
            limit   => 1,
            select  => [qw/me.place_id place.lattitude place.longtitude place.id place.name/],
            as      => [qw/place_id latitude longtitude id name/],
        }
    );
    if ($geo[0]) {
		my $place = $geo[0]->place;
		$place->updated(time);
		$place->lattitude($param->{lattitude});
		$place->longtitude($param->{longtitude});
		$place->name($param->{name});
		$place->update();
    }
	else {
		my $place = $model->resultset('Place')->create({
            created     => time,
            updated     => time,
            lattitude   => $param->{lattitude},
            longtitude  => $param->{longtitude},
			name        => $param->{name}
        });
        $model->resultset('PlaceProject')->create({
            place_id    => $place->id,
            project_id  => $param->{id},
        });    
	}
    my $res = $self->SUPER::get($param);

    return $res;
}

sub remove {
   my ( $self, $param ) = @_;

    my $model       = $self->get_model;
    my $res = { res => 'ok' };
    
    my @geo = $model->resultset('PlaceProject')->search(
        {
            'me.project_id'     => $param->{id},
            'place.lattitude'   => $param->{lattitude},
            'place.longtitude'  => $param->{longtitude}
        },
        {
            join    => [qw/place/],
        }
    );
    if (int(@geo)>0) {
        foreach ( @geo ) {
            my $place = $_->place;
            $_->delete;
            $place->delete;            
        }
    }
    my $res = $self->SUPER::get($param);

    return $res;
}

1;

__END__

=head1 Ahs2::REST::ProjectPlace::Backend


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
