use inc::Module::Install;

# Define metadata
name 'WOA';
abstract 'web oriented toolkit for easy building REST services';
version '0.001';
author 'plcgi1@gmail.com';
license 'perl';
perl_version('5.10.1');

# Specific dependencies
requires 'CGI::Cookie'		=> '0';
requires 'Module::Install'	=> '0';
requires 'Try'		        => '0';
requires 'Starman'          => '0';
requires 'Plack'			=> '1.0029';
requires 'DateTime' 	=> '0';
requires 'Time::Local' 	=> 0;

requires 'Dir::Iterate' => 0;
requires 'Digest::SHA1'	=> '0';
requires 'Digest::MD5'	=> '0';
requires 'MIME::Types'	=> '0';
requires 'Image::Resize'=> '0';
requires 'Imager'		=> '0';

requires 'Text::Xslate' => '0';
requires 'Text::Xslate::Bridge::TT2' => '0';
		
requires 'Plack::Middleware::Auth::AccessToken' => '0',
requires 'Plack::Middleware::Session' => '0',
requires 'Plack::Middleware::Log4perl' => '0',
requires 'Plack::Middleware::Static' => '0',
requires 'Plack::Middleware::AccessLog' => '0',
requires 'Plack::Middleware::ContentMD5' => '0',
requires 'Plack::Middleware::OAuth' => '0',
		
requires 'Carp';
requires 'Error'          => 0.17010;
requires 'File::Basename' => 2.77;
requires 'MIME::Base64'   => 3.08;
requires 'Mail::Mailer'   => 2.06;
requires 'Template'       => 2.22;

requires 'Config::General';
requires 'Config::Any';

requires 'File::Find'; 
requires 'Class::Accessor::Fast' => 0.31;
requires 'Class::Singleton';
requires 'Class::Inspector' => 1.25;

requires 'Encode::Guess' => 2.03;
requires 'POSIX'         => 1.17;

requires 'Test::Strict';
requires 'Test::Pod';
requires 'Test::Builder';
requires 'Test::Builder::Module';

requires 'Getopt::Long' => 2.38;
requires 'Pod::Usage'   => 1.36;

requires 'JSON::XS' => 2.3;
requires 'Data::Dumper';

requires 'Exception::Class';

requires 'URI::Escape'   => 3.30;
requires 'interface'     => 0.03;
requires 'Date::Manip'   => 6.22;
requires 'base'          => 2.14;
requires 'common::sense' => 3.4;
requires 'parent'        => 0.225;
requires 'Locale::Maketext';
requires 'HTTP::Request::AsCGI';

auto_install;

WriteAll;

1;

__END__

use strict;
use warnings;
use ExtUtils::MakeMaker;
perl_version('5.14');
WriteMakefile(
    NAME      => 'ahs',
    VERSION   => '0.01',
    AUTHOR    => 'Nosoff Alex',
    EXE_FILES => ['psgi/Ahs2.psgi'],
    PREREQ_PM => {
		'CGI::Cookie'	=> '0',
        'Module::Install'            => '0',
        'Try'		                 => '0',
        'Starman'                  => '0',
		'Plack'	=> '0',
		'Plack::Middleware::Auth::AccessToken' => '0',
		'Plack::Middleware::Session' => '0',
		'Plack::Middleware::Log4perl' => '0',
		'Plack::Middleware::Static' => '0',
		'Plack::Middleware::AccessLog' => '0',
		'Plack::Middleware::ContentMD5' => '0',
		'Plack::Middleware::OAuth' => '0',
		
		'JavaScript::Value::Escape' => '0',
		'Carp' => '0',
		'Error'          => '0.17010',
		'File::Basename' => '2.77',
		'MIME::Base64'   => '3.08',
		'Mail::Mailer'   => '2.06',
		'Text::Xslate' => '0',
		'Text::Xslate::Bridge::TT2' => '0',
		'Config::General' => '0',
		'Config::Any' => '0',
		
		'File::Find' => '0',
		'Class::Accessor::Fast' => '0.31',
		'Class::Singleton' => '0',
		'Class::Inspector' => '1.25',

		'Encode::Guess' => '2.03',
		'POSIX'         => '1.17',
		
		'Test::Strict' => '0',
		'Test::Pod' => '0',
		'Test::Builder' => '0',
		'Test::Builder::Module' => '0',
		'Digest::HMAC_SHA1' => '0',
		'Digest::SHA1' => '0',
		
		'Getopt::Long' => '2.38',
		'Pod::Usage'   => '1.36',
		
		'JSON::XS' => '2.3',
		'Data::Dumper' => '0',
		
		'Exception::Class' => '0',

		'URI::Escape'   => '3.30',
		'interface'     => '0.03',
		'Date::Manip'   => '6.22',
		'base'          => '2.14',
		'common::sense' => '3.4',
		'parent'        => '0.225',
		'Locale::Maketext' => '0',
		'HTTP::Request::AsCGI' => '0',
		'HTTP::Exception' => '0',
		
		'DBIx::Class' => '0',
		'DBD::mysql' => '0',
		'DBI'        => '0',
		'Cache::FastMmap' => '0',
		
		'Class::Declare' => '0',
		'Log::Log4perl' => '0',
		'Log::Dispatch::FileRotate' => '0',

    },
    test => {TESTS => 't/*.t'}
);

1;
