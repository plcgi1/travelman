#!/usr/bin/perl -w
use strict;
use FindBin qw/$Bin/;
use Getopt::Long;
use Pod::Usage;
use File::Basename;
use Data::Dumper;
use Path::Class;

my $app_root    = $Bin.'/..';

my ($help);

GetOptions(
    'help|?'    => \$help,
);

pod2usage(1) if $help;

#my $app_root    = $Bin.'/..';

my $config = get_config($app_root);

process($config);

exit(0);

sub process {
    my ($config) = @_;
    my @command = ($config->{compiler});
	my $min_js_root = $config->{min_js_root};
	my (@str,$str);
	#print $config->{app_root}.'/index.html';
	
	open F,$config->{app_root}.'/index.html' || die "Cant open file ".$config->{app_root}.'/index.html - '.$!;
	while (<F>) {
		push @str,$_;
	}
	close F;
	$str = join '',@str;
	my $block;
	$str =~s/\n//g;
	$str =~m/<!-- build:js -->(.*)<!-- endbuild -->/gi;
	$str = $1;
	
	$str =~s/<!--(.*)-->//g;
	$str =~s/<\/script>/<\/script>\n/g;
	@str = split "\n",$str;
	
	my @scr;
	foreach ( @str ) {
		my $l = $_;
		$l=~s/\s+/g/;
		next unless $l=~/script/;
		$l =~m/src="(.*)"/;
		$l = $config->{app_root}.'/'.$1;
		push @scr,$l;
	}
	my $concated = concat(@scr);
	unless ( -d $config->{min_js_root} ) {
		mkdir $config->{min_js_root};
	}
	
	open(F, ">$config->{min_js_root}/app.js") or die "$!";
	print F $concated;
	close F;
	#print $concated;
	
	push @command,'--js '.$config->{min_js_root}.'/app.js';	
	push @command,' --module '.$config->{app_name}.':1';
		
	chdir $config->{min_js_root};
	my $command = join ' ',@command;
	print "\n$command\n";
	system $command;
}

sub get_config {
	my ($app_root) = @_;
    return {
        compiler    => 'java -jar /home/harper/soft/bin/compiler.jar',
        app_root     => $app_root.'/public/app',
		min_js_root => $app_root.'/public/app/build',
        app_name    => 'ahs',
    };
}

sub concat {
	my ( @files) = @_;
		
	my @arr;
	for my $f (@files) {
		my $file_name = (split '/',$f)[-1];
		my $base = $f;
		$base =~s/\/$file_name$//;
		$base = dir($base);
		my $file = $base->file($file_name);
		next unless -e $file;

		$file->resolve;
		#next unless $base->contains($file);

		push @arr,$file->slurp;
	}
	my $concat = join "\n",@arr;
	return $concat;
}


1;

__END__


=head1 NAME

genjs.pl  - компиляция js модуля

=head1 SYNOPSIS

genjs.pl modulename
 
 Options:
   -? -help      вывод справки и выход

=head1 DESCRIPTION

Параметры: имя ключа из get_config->{path}
   в необходимой папке(public/js/min) будет создан скомпилированный js модуль

В итоговой версии используется сжатая версия js модуля

Зависимости
   java
   google js compiler


=head1 AUTHOR


=head1 COPYRIGHT

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
