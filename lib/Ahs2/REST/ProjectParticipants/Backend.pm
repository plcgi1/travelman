package Ahs2::REST::ProjectParticipants::Backend;
use common::sense;
use base 'Ahs2::REST::Project::Backend';
use Data::Dumper;

sub save {
    my ( $self, $param ) = @_;

    my $model       = $self->get_model;
        
    my @parts = $model->resultset('UserProject')->search({
        project_id  => $param->{id}
    });
    foreach ( @parts ) {
        $_->delete;
    }
    foreach ( @{$param->{participants}} ) {
        $model->resultset('UserProject')->find_or_create({
            user_id     => $_,
            project_id  => $param->{id}
        });
    }
    my $res = $self->SUPER::get($param);

    return $res;
}

sub get {
    my ( $self, $param ) = @_;
    my $model       = $self->get_model;
    my $res;
    if ($param->{id}) {
        my $rs = $model->resultset('UserInfo')->search(
            { 'user.id' => $param->{id} },
            {
                join => [qw/user/],
                select => [qw/user.login user.fname user.lname me.filename user.id user.quality/],
                as => [qw/login fname lname filename id quality/],
                order_by => 'user.login'
            }
        )->single;
        my $f = $rs->get_column('filename');
            if ( $f ) {
                $f = '/img/users/'.$rs->get_column('login').'/'.$f;
            }
            else {
                $f = '/img/users/no-photo.gif';
            }
            my $fio;
            unless ( $rs->get_column('fname') && $rs->get_column('lname')) {
                $fio = $rs->get_column('login');
            }
            else {
                $fio = $rs->get_column('lname').' '.$rs->get_column('fname');
            }
        $res = [
            {
                "fio"       => $fio,
                "login"     => $rs->get_column('login'),
                "id"        => $rs->get_column('id'),
                quality     => $rs->get_column('quality'),
                "filename"  => $f ,
            }
        ];
    }
    else {
        my @rs = $model->resultset('UserInfo')->search(
            {},
            {
                join => [qw/user/],
                select => [qw/user.login user.fname user.lname me.filename user.id/],
                as => [qw/login fname lname filename id/],
                order_by => 'user.login'
            }
        );
        foreach ( @rs ) {
            my $f = $_->get_column('filename');
            if ( $f ) {
                $f = '/img/users/'.$_->get_column('login').'/'.$f;
            }
            else {
                $f = '/img/users/no-photo.gif';
            }
            my $fio;
            unless ( $_->get_column('fname') && $_->get_column('lname')) {
                $fio = $_->get_column('login');
            }
            else {
                $fio = $_->get_column('lname').' '.$_->get_column('fname');
            }
            push @$res,{
                "fio" => $fio,
                "login" => $_->get_column('login'),
                "id" => $_->get_column('id'),
                "filename" => $f ,
            };
        }   
    }
    return $res;
}

1;

__END__

=head1 Ahs2::REST::ProjectParticipants::Backend


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
