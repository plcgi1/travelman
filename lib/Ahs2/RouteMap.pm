package Ahs2::RouteMap;

use strict;
use base 'Class::Accessor::Fast';

# autogenerated by woax-toolkit.pl
# if you want edit  - edit Map.pm file for service and run "woax-toolkit.pl -a service -n YourServiceName "
# !!! DONT EDIT THIS FILE !!! #

my $rules = [
    
    { path => '/ahs/auth', class => 'Ahs2::REST::Auth::SP' },
    
    { path => '/ahs/projects/project/pulse$', class => 'Ahs2::REST::Pulse::SP' },
    
    { path => '/ahs/projects/project/goals$', class => 'Ahs2::REST::ProjectGoals::SP' },
    
    { path => '/ahs/projects/project/photo$', class => 'Ahs2::REST::ProjectPhoto::SP' },
    
    { path => '/ahs/projects/project/place$', class => 'Ahs2::REST::ProjectPlace::SP' },
    
    { path => '/ahs/projects$', class => 'Ahs2::REST::Project::SP' },
    
    { path => '/ahs/projects/project/confirm$', class => 'Ahs2::REST::ProjectConfirm::SP' },
    
    { path => '/ahs/projects/project/participants$', class => 'Ahs2::REST::ProjectParticipants::SP' },
    
    { path => '/ahs/settings/mydata$', class => 'Ahs2::REST::Settings::SP' },
    
    { path => '/ahs/settings/myrestrict$', class => 'Ahs2::REST::Settings::SP' },
    
    { path => '/ahs/user/info', class => 'Ahs2::REST::UserInfo::SP' },
    
    { path => '/ahs/settings/myquality$', class => 'Ahs2::REST::MyQuality::SP' },
    
    { path => '/ahs/settings/myphoto$', class => 'Ahs2::REST::MyPhoto::SP' },
    
    { path => '/ahs/projects/project/info$', class => 'Ahs2::REST::ProjectInfo::SP' },
    
    { path => '/ahs/settings/passport$', class => 'Ahs2::REST::MyPassport::SP' },
    
    { path => '/ahs/settings/password$', class => 'Ahs2::REST::MyPassword::SP' },
    
];

sub get_appid {
    return 'ahs2';
}

sub get_rules { return $rules; }

1;

__END__
