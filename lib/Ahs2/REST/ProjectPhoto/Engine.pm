package Ahs2::REST::ProjectPhoto::Engine;
use strict;
use Data::Dumper;
use parent 'Ahs2::Component::Upload::Engine';

sub _fill_args {
    my ( $self, $data ) = @_;
		
	$self->SUPER::_fill_args($data);
	
	my $project_id = $data->[1]->{value};
	unless($project_id) {
		$project_id = $self->session->{project}->{id};
	}
	$data->[1]->{value} = $project_id;

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
