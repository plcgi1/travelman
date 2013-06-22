use strict;
use warnings;
use ExtUtils::MakeMaker;
WriteMakefile(
    NAME      => 'ahs',
    VERSION   => '0.01',
    AUTHOR    => 'Nosoff Alex',
    EXE_FILES => ['psgi/Ahs2.psgi'],
    PREREQ_PM => {
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
		
		'Cache::FastMmap' => '0',
		
		'Class::Declare' => '0',
		'Log::Log4perl' => '0',
		'Log::Dispatch::FileRotate' => '0',

    },
    test => {TESTS => 't/*.t'}
);

#use inc::Module::Install;
#
## Define metadata
#name 'WOA';
#abstract 'Alpine human register REST services';
#version '0.001';
#author 'plcgi1@gmail.com';
#license 'perl';
#perl_version('5.14');
#
## Specific dependencies
#requires 'Module::Install';
#requires 'Try';
#requires 'Plack';
#requires 'Plack::Middleware::Session';
#requires 'Plack::Middleware::Log4perl';
#requires 'Plack::Middleware::Static';
#requires 'Plack::Middleware::AccessLog';
#requires 'Plack::Middleware::ContentMD5';
#
#requires 'JavaScript::Value::Escape';
#requires 'Carp';
#requires 'Error'          => 0.17010;
#requires 'File::Basename' => 2.77;
#requires 'MIME::Base64'   => 3.08;
#requires 'Mail::Mailer'   => 2.06;
#requires 'Text::Xslate';
#requires 'Text::Xslate::Bridge::TT2';
#requires 'Config::General';
#requires 'Config::Any';
#
#requires 'File::Find'; 
#requires 'Class::Accessor::Fast' => 0.31;
#requires 'Class::Singleton';
#requires 'Class::Inspector' => 1.25;
#
#requires 'Encode::Guess' => 2.03;
#requires 'POSIX'         => 1.17;
#
#requires 'Test::Strict';
#requires 'Test::Pod';
#requires 'Test::Builder';
#requires 'Test::Builder::Module';
#requires 'Digest::HMAC_SHA1';
#requires 'Digest::SHA1';
#
#requires 'Getopt::Long' => 2.38;
#requires 'Pod::Usage'   => 1.36;
#
#requires 'JSON::XS' => 2.3;
#requires 'Data::Dumper';
#
#requires 'Exception::Class';
#
#requires 'URI::Escape'   => 3.30;
#requires 'interface'     => 0.03;
#requires 'Date::Manip'   => 6.22;
#requires 'base'          => 2.14;
#requires 'common::sense' => 3.4;
#requires 'parent'        => 0.225;
#requires 'Locale::Maketext';
#requires 'HTTP::Request::AsCGI';
#requires 'HTTP::Exception';
#
#requires 'DBIx::Class';
#requires 'DBD::mysql';
#
#requires 'Cache::FastMmap';
#
#requires 'Class::Declare';
#requires 'Log::Log4perl';
#requires 'Log::Dispatch::FileRotate';
#
#requires 'Plack::Middleware::Auth::AccessToken';
#
#install_script glob('bin/*.pl');
#
#auto_install;
#
#WriteAll;

1;
