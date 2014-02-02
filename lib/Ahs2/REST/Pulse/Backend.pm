package Ahs2::REST::Pulse::Backend;
use common::sense;
use base 'Ahs2::REST::Backend';
use Data::Dumper;

sub save {
    my ( $self, $param ) = @_;

    my $config  = $self->get_config;
    my $session = $self->get_session();
    my $model 	= $self->get_model;
	
	my $pulse;
	my $now = time();
	if ( $param->{id} ) {
		$pulse = $model->resultset('Pulse')->search(
			{ id => $param->{id} },
		)->single();
		$pulse->updated($now);
		$pulse->update();
	}
	else {
		$pulse = $model->resultset('Pulse')->create({
			description => $param->{description},
			created     => $now,
			updated     => $now,
			author_id   => $session->{user}->{id},
			project_id  => $param->{project_id}
		});
	}
    # make return with values - for tests
    my $res = $self->get({project_id => $param->{project_id},id => $pulse->get_column('id')});

    return $res;

}

sub get {
    my ( $self, $param ) = @_;

    my $config  = $self->get_config;
    my $session = $self->get_session();
    my $model 	= $self->get_model;
	my $rs_param = {
		'me.project_id' => $param->{project_id}
	};
	if ($param->{id}) {
		$rs_param->{'me.id'} = $param->{id};
	}
	my @rs = $model->resultset('Pulse')->search(
		$rs_param,
		{
			join => [qw/author author_info/],
			select => [
				'author.login',
				'author.fname',
				'author.lname',
				'author.id',
				'me.description',
				'author_info.filename',
				'FROM_UNIXTIME(me.created,\'%Y-%m-%d\')',
				'FROM_UNIXTIME(me.updated,\'%Y-%m-%d\')'
			],
			as 			=> [qw/login fname lname user_id description filename created updated/],
			order_by 	=> 'me.updated'
		}
	);
	my @res;
	if ( int(@rs)>0 ) {
		my @columns = $rs[0]->columns;
		foreach ( @rs ) {
			my %hash;
			foreach my $col( @columns ) {
				$hash{$col} = $_->get_column($col);
			}
			$hash{login} 	= $_->get_column('login');
			$hash{filename} = $_->get_column('filename');
			$hash{user_id} 	= $_->get_column('user_id');
			
			push @res,\%hash;
		}	
	}
	
    # make return with values - for tests
    my $res = \@res;

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

=head1 Ahs2::REST::Pulse::Backend


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
