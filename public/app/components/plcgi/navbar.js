// <navbar model=""/>
/*
	@dependencies: angular.js,angular-resource.js
	@description: <navbar model="/path/to/top-level-navigation-data"/>
		Data: [
			{ "label": "LABEL", "path" : "PATH" },
			...
		]
*/
var module = angular.module('plcgi.navbar', ['ngResource']);

module.controller('NavCtrl',function ($scope, $element, $attrs,$resource,$route,$location){
	var url = $element.parent()[0].attributes.model.value;
	var rc  = $resource(url, {}, {query: {method:'GET', isArray:true}});
	var data = rc.query({},function(res){
		$scope.model = data;
		var current = false;
		var p = location.hash;
		if (p) {
			//code
		}
		for (var i=0;i<$scope.model.length;i++ ) {
			var path = $scope.model[i].path;
			var ar = path.split('/');
			if (ar[1].length>0) {
				path = '/'+ar[1];
			}
			
			var regexp = new RegExp('^' + path, ['i']);
			//console.log(path + ' ' + regexp);
			//if ($scope.model[i].path === $location.path()) {
			if ( regexp.test($location.path()) ) {
				current = $scope.model[i];
				break;
			}
		}
		
		//if ( !current) {
		//	current = $scope.model[0];
		//}
		current.selected = 'active';
		
	});
	var switchTab = function(el) {
		//console.log(el);
		var has_selected = false;
        angular.forEach($scope.model,function(item){
            item.selected = '';
            var p = item.path;
            p = p.replace(/^#/,'');
			var e = el.path;
            e = e.replace(/^#/,'');
			var arr1 = p.split('/');
			var arr2 = e.split('/');
			
            if(arr1[1] === arr2[1]) {
                item.selected = 'active';
				has_selected  = true;
            }
        });
		if (!has_selected) {
			angular.forEach($scope.model,function(item){
				item.selected = '';
			});	
		}
    };
	$scope.switchTab = switchTab;
	//switchTab({path:$location.path()});
});

module.directive('navbar', function($timeout) {
    return {
        restrict: 'E',
        transclude: true,
        scope: true,
        templateUrl: 'views/lib/navbar.html'
    };
});