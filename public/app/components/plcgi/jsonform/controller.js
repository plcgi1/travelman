
/* Controller for manage model.data and meta.data */
function JsonformCtrl($scope, $element, $attrs, $http, SharedService, Location,jsonformService) {
    jsonformService.initialize($scope,$attrs);    
}

var module = angular.module('jsonform.controllers', ['jsonform.services','jsonform.directives']);

module.controller('jsonformCtrl',[],JsonformCtrl);