package Ahs2::Formatter;
use common::sense;
use Encode qw(from_to decode is_utf8);
use DateTime;
use Time::Local;
use Ahs2;
use base 'WOA::Formatter';

sub to_mysql_datetime {
    my ($self, $param ) = @_;
    my $res = join '-',($param->{year},$param->{month},$param->{day});
    return $res;
}

sub format_ts_ymd {
	my ( $self, $ts ) = @_;
	my $res = $self->woa_strftime( "%Y-%m-%d", localtime($ts) );
	return $res;
}

sub to_uts {
    my ($self, $param ) = @_;

    my($y,$m,$d) = split '\-',$param->{date};
    my($h,$min,$s)=split(':',$param->{time});
    my $res;
    if( $y && $m && $d ){
        #my $dt = DateTime->new(
        #    year    => $y,
        #    month   => $m,
        #    day     => $d,
        #    hour    => $h,
        #    minute  =>  $min
        #);
        #$res = $dt->epoch;
        $res = timelocal(0, $min, $h, $d, $m-1, $y);
    }
    
    return $res;
}

sub to_uts_simple {
	my ($self, $date_time ) = @_;
	my($d,$t) = split ' ',$date_time;
	return $self->to_uts({ date => $d,time => $t });
}

1;

__END__