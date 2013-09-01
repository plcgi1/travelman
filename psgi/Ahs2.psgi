use common::sense;
use Log::Log4perl;
use File::Basename;

use lib dirname(__FILE__).'/woa-toolkit-core/lib';
use lib dirname(__FILE__).'/woa-toolkit-plack/lib';
use lib dirname(__FILE__).'/lib';

use Plack::Builder;
use Plack::Middleware::OAuth::UserInfo;
use Plack::Middleware::WOAx::App;

use WOA::Config::Provider;
use Log::Log4perl;
use Text::Xslate;
use Text::Xslate::Bridge::TT2;
use Text::Xslate::Util qw(
    mark_raw
    unmark_raw
    html_escape
    uri_escape
    p
    html_builder
    hash_with_default
);
use JavaScript::Value::Escape;
use Plack::App::File;
use Cache::FastMmap;
use WOA::REST::ServiceProvider::Loader;
use JSON::XS qw/encode_json decode_json/;
use Ahs2::Model::DBIx;
use Ahs2::Formatter;
use Ahs2::RouteMap;
use Ahs2::Model::Oauth;

my $app_root    = dirname(__FILE__).'/../';

my $config = WOA::Config::Provider->get_config($app_root.'/etc/Ahs2.conf');
#$config->{app_root} = $app_root;

my $tpl = Text::Xslate->new(
    path        => $config->{template_root},
    #cache_dir  => $config->{template_cache},
    syntax      => 'TTerse',
    verbose     => 2,
    module      => [
        'Text::Xslate::Bridge::TT2',
        'JavaScript::Value::Escape' => [qw(js)] 
    ],
    function    => {
        to_json => sub {
            my $res = encode_json($_[0]);
            return mark_raw($res);
        }
    }
);

Log::Log4perl::init($config->{log4perl});

my $fmt = Ahs2::Formatter->instance();
my $model = Ahs2::Model::DBIx->connect(
    $config->{connect_info}->[0],
    $config->{connect_info}->[1],
    $config->{connect_info}->[2],
    {
        on_connect_do       => $config->{on_connect_do},
        mysql_enable_utf8   => 1
    }
);

my $fast_storage = Cache::FastMmap->new();

my $controller_param = {
    config              => $config,
    renderer            => $tpl,
    model               => $model,
    formatter           => $fmt ,
    fast_storage        => $fast_storage
};

my $rules = Ahs2::RouteMap->get_rules;

my $app = Plack::Middleware::WOAx::App->new({
    service_provider =>  WOA::REST::ServiceProvider::Loader->new({
        rules => $rules
    }),
    %$controller_param
});

builder {
    enable "Plack::Middleware::Static",  path => qr{\.(i|js|css|html|png|gif|ico|jpg|json|xml|txt)$}i, root => "$app_root/public";
    enable "Plack::Middleware::AccessLog", format => "combined";
    enable "Plack::Middleware::ContentMD5";
    enable "Session",   store       => "File";
    
    # uncomment it if you need some state for all pages and request
    # enable "Plack::Middleware::WOAx::Project";
    
    # from $env->{'psgix.logger'}
    enable "Log4perl", category => "main";    
    
    enable "OAuth",
        on_success => sub {
            my ($self,$token) = @_;
            my $env = $self->env;
        
            my $config = $self->config;   # provider config
            
            my $userinfo = Plack::Middleware::OAuth::UserInfo->new( 
                token =>  $token , 
                config => $config
            );
            my $info_hash = $userinfo->ask( $self->{provider} );   # load Plack::Middleware::OAuth::UserInfo::Twitter
            my $auth = Ahs2::Model::Oauth->new({ model => $model, config => $config, session => $self->{env}->{'psgix.session'} });
            use Data::Dumper;
            warn Dumper $info_hash;
            my $res = $auth->login($info_hash,$self->{provider});
            
            return $self->redirect( $res->{location} );
        },
        on_error => sub {
            my ($self) = @_;
            warn "ERROR";
            return $self->redirect( '/app/404.html' );
        },
        providers => $config->{oauth};
           
    foreach ( @{$rules} ) {
        mount $_->{path} => $app;    
    }
    
    $app;
};