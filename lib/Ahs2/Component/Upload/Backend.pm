package Ahs2::Component::Upload::Backend;
use common::sense;
use base 'Ahs2::REST::Backend';
use Digest::MD5 qw/md5_hex/;
use MIME::Types;
use Data::Dumper;

__PACKAGE__->mk_accessors(qw/uploads/);

sub save_file {
	my ( $self, $param ) = @_;
	my @arr;
	
	my $config  = $self->get_config;
    my $session = $self->get_session();
    my $model   = $self->get_model;
    my $fmt     = $self->get_formatter;
	
	my $tempname = $param->{file}->tempname;
    my $filename;
    
	my $out_dir = $self->_get_dir_path.'/'.$session->{user}->{login};
	if ($param->{out_dir}) {
		$out_dir = $self->_get_dir_path.'/'.$session->{user}->{login}.'/'.$param->{out_dir};
	}
	my $ext = (split '\.',$param->{file}->filename)[-1];
	my $out_file = "$out_dir/".md5_hex($param->{file}->filename).'.'.$ext;        
	my $filename = md5_hex($param->{file}->filename).'.'.$ext;
	
	unless ( -d $out_dir ) {
		mkdir $out_dir;
	}
	
	if ($param->{clear}) {
		opendir D, $out_dir;
		my @files = readdir D;
		closedir D;
		
		foreach (@files) {
			unlink $out_dir.'/'.$_;
		}	
	}
	
	open F, $tempname || die "Cant open file ".$param->{file}->tempname." - '$!'";
	open OUT,">$out_file";
	while ( my $line = <F> ) {
		print OUT $line;
	}
	close OUT;
	close F;
	
	my $mt = MIME::Types->new;
	return {
		filename => $filename,
        type     => $mt->mimeTypeOf($filename)->type,
        size     => $param->{file}->size,
		original_name 	=> $fmt->encode_utf($param->{file}->filename),
		full_filename   	=> $config->{static}->{user_profile_path}.'/'.$session->{user}->{login}.'/'.$param->{out_dir}.'/'.$filename
	};
}

sub remove_file {
	my($self,$param) = @_;
	my $config  = $self->get_config;
    my $session = $self->get_session();
	my $file = $self->_get_dir_path.'/'.$session->{user}->{login}.'/'.$param->{out_dir}.'/'.$param->{filename};
	unlink 	$file;
	return;
}

sub _get_dir_path {
    my $config = $_[0]->get_config();
    my $res = $config->{app_root}.'/public'.$config->{static}->{user_profile_path};
    return $res;
}

1;

__END__

=head1 Ahs2::Component::Upload::Backend


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
