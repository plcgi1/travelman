(function() {
	'use strict';
	var app = window.app;
	angular.module('AhsApp').controller('SettingsCtrl', function($scope, $http, $routeParams, Settings,Uploads,MyPassword) {
		$scope.mode = $routeParams.mode || 'view';
		$scope.myphoto = {};
		$scope.mypassword = {
			1 : '',
			2 : ''
		};
		$scope.myphoto = Settings.query({}, function(data) {
			$scope.myphoto = data.myphoto;
			$scope.mydata  = data.mydata;
		});
		
		Uploads.query({}, function(data) {
			$scope.myquality = data.myquality;
		});
						
		$scope.$on('uploadComplete', function(evt, data) {
			$scope.myphoto.path = data.filename_hash;
			$scope.myphoto.filename = data.filename;
		});
		
		$scope.$on('myqualityUploaded', function(evt, data) {
			//alert('myqualityUploaded');
			$scope.myquality = data.myquality;
		});
		
		function save(data) {
			Settings.save($scope.mydata, function(data) {
				$scope.myphoto = data.myphoto;
				$scope.mydata  = data.mydata;
			});	
		}
		function save_password() {
			MyPassword.save({
				password  : $scope.mypassword['1'],
				password2 : $scope.mypassword['2']
			});
		}
		$scope.save = save;
		$scope.save_password = save_password;
	});
	
})();