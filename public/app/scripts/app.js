;(function(){
'use strict';
window.app = angular.module('AhsApp', [
  'plcgi.navbar','plcgi.list','plcgi.dropdown','plcgi.mode',
  'ahs.services','ahs.controllers','ahs.directives','plcgi.eventbus'
]);
app.services    = angular.module('ahs.services', ['ngResource']);
app.controllers = angular.module('ahs.controllers', ['ahs.services','$strap.directives']);
app.directives  = angular.module('ahs.directives', ['plcgi.mode','ahs.services']);

//app.value('$strapConfig', {
//  datepicker: {
//    language: 'ru',
//    format: 'yyyy-mm-dd'
//  }
//});

app
    .config(function ($routeProvider,$httpProvider) {
        $routeProvider
            .when('/', {
              templateUrl: 'views/about.html',
              controller: 'AboutCtrl'
            })
            .when('/login', {
              controller: 'AuthCtrl',
              templateUrl: 'views/login-page.html'
            })
            .when('/projects', {
              templateUrl: 'views/projects.html'
            })
            .when('/projects/project/:project_id/:mode', {
              templateUrl: 'views/project-detail.html',
              controller: 'ProjectCtrl'
            })
            .when('/participants', {
              templateUrl: 'views/participants.html',
              controller: 'ProjectsCtrl'
            })
            .when('/settings', {
              templateUrl: 'views/settings.html',
              controller: 'SettingsCtrl'
            })
            .when('/settings/:mode', {
              templateUrl: 'views/settings.html',
              controller: 'SettingsCtrl'
            })
            .otherwise({
              redirectTo: '/'
            });
            var interceptor = [
                '$rootScope',
                '$q',
                'appLoading',
                function (scope, $q,appLoading) {
                
                    function success(response) {
                        appLoading.ready();
                        //console.log(response);
                        return response;
                    }
            
                    function error(response) {
                        var status = response.status;
            
                        if (status === 401) {
                            window.location = './401.html';
                            return;
                        }
                        // otherwise
                        appLoading.ready();
                        return $q.reject(response);
                    }
                    return function (promise) {
                        appLoading.loading();
                        return promise.then(success, error);
                    };
                }
            ];
            $httpProvider.responseInterceptors.push(interceptor);
    })
    .factory('appLoading', function($rootScope) {
        var timer;
        return {
            loading : function() {
                clearTimeout(timer);
                $rootScope.status = 'loading';
                if(!$rootScope.$$phase) {
                    $rootScope.$apply();
                }
            },
            ready : function(delay) {
                function ready() {
                    $rootScope.status = 'ready';
                    if(!$rootScope.$$phase) {
                        $rootScope.$apply();
                    }
                }
    
                clearTimeout(timer);
                delay = delay === null ? 500 : false;
                if(delay) {
                    timer = setTimeout(ready, delay);
                }
                else {
                    ready();
                }
            }
        };
    }
);
})();