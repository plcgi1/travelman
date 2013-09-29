(function() {
	'use strict';
	var app = window.app;
	angular.module('AhsApp').controller('SettingsCtrl', function($scope, $http, $routeParams, $filter, Settings,Uploads,MyPassword) {
		$scope.mode = $routeParams.mode || 'view';
		$scope.myphoto = {};
		$scope.mypassword = {
			1 : '',
			2 : ''
		};
		$scope.dateOptions = { format: 'yyyy-mm-dd' };
		
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
		
		function save(data) {
			$scope.mydata.birth = $filter('date')($scope.mydata.birth,'yyyy-MM-dd');
			console.log($scope.mydata.birth);
			Settings.save($scope.mydata, function(data) {
				$scope.myphoto = data.myphoto;
				$scope.mydata  = data.mydata;
				$scope.birth   = data.birth;
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