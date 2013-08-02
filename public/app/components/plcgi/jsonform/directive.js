/**
 *
 * jsonform.directives - Json schema form renderer/parser
 * @version v0.0.1 - 2013-04-15
 * @author https://github.com/plcgi1
 * @dependencies AngularJS v1.0.6(http://angularjs.org), jquery(http://jquery.com), nod.js(http://casperin.github.io/nod/)
 *
 */

'use strict';

var module = angular.module('jsonform.directives', []);

/**
 * @name SharedService
 *
 * @description Share data between components,directives,controllers etc. - when they loaded by ajax
 * @example
 *  Task: share data from accounts.json in cmcObject - to other controller ( see public/app/js/users.js )
 *  in your controller:
 *      function YourController($scope,$http,$routeParams,SharedService) {
 *           // subscribe on data loaded in directive
 *           $scope.$on('dataLoaded',function(event,args,meta){
 *               $scope.accounts = args;
 *           });    
 *       }
 *       UsersCtrl.$inject = ['$scope', '$http', 'SharedService'];
 *
 *  in html
 *      <ul ng-controller="YourController" class="nav nav-list">
 *           <li ng-repeat="account in accounts">
 *             <a href="?id={{account.Id}}">{{account.Name}}</a><a style="top:-25px;position:relative;" class="pull-right" href="?id={{account.Id}}&mode=edit"><i class="icon-edit"></i></a>
 *           </li>
 *       </ul>
 */
module.factory('SharedService', function($rootScope) {
    var sharedService = {};

    sharedService.models = {};
    sharedService.model = {};
    sharedService.meta = {};
    sharedService.nodRules = [];
    
    sharedService.prepForBroadcast = function(models, meta, nodRules) {
        this.models = models;
        this.meta = meta;
        this.nodRules = nodRules;
        this.broadcastItem();
    };

    sharedService.broadcastItem = function() {
        $rootScope.$broadcast('dataChanged', sharedService.models, sharedService.meta, sharedService.nodRules);
    };

    return sharedService;
});

/**
 * @name Location
 *
 * @description Parse query string params into javascript object
 * @example
 *  in your controller:
 *       function YourController($scope,$http,$routeParams,Location) {
 *           console.log(Location.param('id'));
 *       }
 *       UsersCtrl.$inject = ['$scope', '$http', 'Location'];
 *  in your browser
 *      http://yourhost/yorpage.html?id=BLABLA
 */

module.factory('Location', function() {
    var Location = {
        param: function(name) {
            var url = location.href;

            var qs = (url.split("?"))[1];

            if (qs) {
                var pairs = qs.split("&");
                var hash = {};
                for (var i = 0; i < pairs.length; i++) {
                    var arr = pairs[i].split('=');
                    hash[arr[0]] = arr[1];
                }

                var found = hash[name];
                if (found && typeof found != 'undefined') {
                    var res = found.length == 0 ? false : found;
                    return res;
                }
                return 0;
            }
        }
    };
    return Location;
});
/*
 * @name cmcObject
 *
 * @description Angularjs directive to render and validate form data with json schema ( see public/app/data/meta.json )
 *
 * @example
 *   in html
 *      <cmc-object id="<ID>" data="<model.json>" meta="<model.meta>" mode="<view|edit>"/>
 *
 *      model.data - see public/app/data/accounts.json for example
 *      model.meta - see public/app/data/meta.json for example
 *      id         - Id of the object in model.data, which can be passed via url query string 
 *      mode       - view (or edit) view renders readOnly view allowing no editing; edit should show something
 *      
*/
module.directive('jsonform', function($timeout) {
    /* map from json schema field types to nod.js metrics */
    var fieldsForNodMap = {
        phone: {
            label: 'Phone must be filled by pattern [(dddd)dddddddd]',
            rule: (function(v){
                if (v.length === 0) {
                    return true;
                }
                else {
                    return v.match(/^(\(\d+\)\d+)$/)
                }
            })
        },
        currency: {
            label: 'Must be float',
            rule: 'float'
        },
        int: {
            label: 'Must be integer',
            rule: 'integer'
        },
        datetime: {
            label: 'Must be filled by pattern [YYYY-MM-DD hh:mm:ss.zone]',
            rule: (function(v){
                if (v.length === 0) {
                    return true;
                }
                else {
                    return v.match(/^(\d{4}\-\d{2}\-\d{2} \d{2}:\d{2}:\d{2}\.\d{3}\+\d{4})$/)
                }
            })
        },
        date: {
            label: 'Must be filled by pattern [YYYY-MM-DD]',
            rule: (function(v){
                if (v.length === 0) {
                    return true;
                }
                else {
                    return v.match(/^(\d\d\d\d\-\d\d\-\d\d)$/)
                }
            })
        },
        double: {
            label: 'Must be float',
            rule: 'float'
        },
        default: {
            label: '',
            rule: function(val) {
                return val
            }
        }
    };

    return {
        restrict: 'E',
        transclude: true,
        scope: true,
        templateUrl: 'views/lib/jsonform.html',
        controller: JsonformCtrl,
        link: function($scope, $element, $attrs){
            if ($scope.mode === 'edit' ) {
                $scope.$on('dataChanged', function(event, models, meta) {
                    // why do i need such magic ((
                    // if we call code without $timeout - we see in console
                    /*
                    <!-- ngSwitchWhen: view -->
                    <!-- ngSwitchWhen: edit -->
                    <!-- ngSwitchDefault: view -->
                    <div ng-switch-when="edit" class="ng-scope">
                        <form name="" id="" class="form-horizontal ng-pristine ng-valid">
                            <fieldset>
                              <legend class="ng-binding">Account</legend>
                              <!-- ngRepeat: group in meta.groups -->
                              <button type="submit" class="btn">Submit</button>
                            </fieldset>
                          </form>
                        </div>
                        
                        for nod.js - we need full parsed template
                    */
                    $timeout(function(){
                        var frm = $($element).find('form');
                        var nodRules = [];
                        for(var item in fieldsForNodMap ) {
                            nodRules.push([
                                '[dataType="'+item+'"]',
                                fieldsForNodMap[item].rule,
                                fieldsForNodMap[item].label
                            ]);                            
                        }
                        nodRules.push([
                            '[name="Name"]',
                            'presence',
                            'Required'
                        ]);
                        frm.nod(nodRules, {
                            errorClass: 'label label-important'
                        });
                    },0);
                    
                });
            }
        },
        replace: true
    };
});