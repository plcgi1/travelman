package Ahs2::REST::MyPassport::Backend;
use common::sense;
use base 'Ahs2::REST::Settings::Backend';
use Data::Dumper;


sub save {
    my ( $self, $param ) = @_;

    my $config  = $self->get_config;
    my $session = $self->get_session();
    my $model 	= $self->get_model;
    my $fmt 	= $self->get_formatter();
	
    my $user = $model->resultset('PassportData')->search(
        { user_id => $session->{user}->{id} },
    )->single();
	unless ( $user ) {
		$user = $model->resultset('PassportData')->create({
			user_id 			=> $session->{user}->{id},
			updated 			=> time,
			"serial" 			=> $param->{serial},
			"number" 			=> $param->{number},	
			"received" 			=> \"UNIX_TIMESTAMP('$param->{received}')",
			"place" 			=> $param->{place},
			"latin_fname" 		=> $param->{latin_fname},
			"latin_lname" 		=> $param->{latin_lname},
			"place" 			=> $param->{org},
			"date_of_birth" 	=> \"UNIX_TIMESTAMP('$param->{dob}')",
			"place_of_birth" 	=> $param->{pob}
		});
	}
    my $is_edit;
    foreach ( keys %$param ) {
        if ( $param->{$_} && $param->{$_} ne $user->get_column($_) ) {
			if ( $_ =~/dob|received/ ) {
				my $v =  \"UNIX_TIMESTAMP('$param->{$_}')";
				$user->$_($v);
			}
			else {
				$user->$_($param->{$_});
			}
            
            $is_edit++;
        }
    }
	
    if ($is_edit) {
        $user->update();
    }
	
    my $res = $self->get($param);
    return $res;
}



1;

__END__

=head1 Ahs2::REST::MyPassport::Backend


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
