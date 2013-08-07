(function() {
	'use strict';
	var app = window.app;
	angular.module('AhsApp').controller('SettingsCtrl', function($scope, $http, $routeParams, Settings) {
		$scope.mode = $routeParams.mode || 'view';
		$scope.myphoto = {};

		$scope.myphoto = Settings.query({}, function(data) {
			$scope.myphoto = data.myphoto;
		});

		$scope.$on('uploadComplete', function(evt, data) {

			$scope.myphoto.path = data.filename_hash;
			$scope.myphoto.filename = data.filename;
		});
	});
	//function SettingsCtrl($scope,$http,$routeParams,Settings) {
	//	$scope.mode = $routeParams.mode || 'view';
	//	$scope.myphoto = {};
	//	
	//	$scope.myphoto = Settings.query({},function(data){
	//		$scope.myphoto = data.myphoto;
	//	});
	//	
	//	$scope.$on('uploadComplete',function(evt,data){
	//		
	//		$scope.myphoto.path = data.filename_hash;
	//		$scope.myphoto.filename = data.filename;
	//	});
	//}
})();