(function() {
	'use strict';
	var app = window.app;
	angular.module('AhsApp').controller('SettingsCtrl', function($scope, $http, $routeParams, $filter, Settings, Uploads, MyPassword, PassportInfo) {
		$scope.mode = $routeParams.mode || 'view';
		$scope.myphoto = {};
		$scope.mypassword = {
			1: '',
			2: ''
		};
		$scope.dateOptions = {
			format: 'yyyy-mm-dd'
		};
	
		$scope.$on('uploadComplete', function(evt, data) {
			$scope.myphoto.path = data.filename_hash;
			$scope.myphoto.filename = data.filename;
		});

		function settings_cb(data) {
			$scope.myphoto = data.myphoto;
			$scope.mydata = data.mydata;
			$scope.passport = data.passport;
			$scope.birth = data.birth;
			
			$scope.myrestrict = data.myrestrict;
			
			if ( $scope.myrestrict.view_passport_data === 1 ) {
				$('#view_passport_data').checked();
			}	
		}

		function save(data) {
			$scope.mydata.birth = $filter('date')($scope.mydata.birth, 'yyyy-MM-dd');
			Settings.save($scope.mydata, settings_cb);
		}

		function save_password() {
			MyPassword.save({
				password: $scope.mypassword['1'],
				password2: $scope.mypassword['2']
			});
		}

		function save_passport_data(args) {
			$scope.passport.dob = $filter('date')($scope.passport.dob, 'yyyy-MM-dd');
			$scope.passport.received = $filter('date')($scope.passport.received, 'yyyy-MM-dd');

			PassportInfo.save($scope.passport, settings_cb);
		}
		function save_restrict() {
			Settings.save_restrict($scope.myrestrict, settings_cb);
		}
		function toggle_content(target_id) {
			$('#' + target_id).collapse('toggle');
		}
		
		$scope.save = save;
		$scope.save_password = save_password;
		$scope.save_passport_data = save_passport_data;
		$scope.save_restrict = save_restrict;
		$scope.toggle_content = toggle_content;

		Settings.query({}, settings_cb);
	});

})();