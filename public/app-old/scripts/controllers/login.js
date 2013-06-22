'use strict';
var app = window.app;
app.controller('AuthCtrl', function ($scope,$http,$routeParams,$rootScope,EventBus) {
	
	$scope.logme = function(){
		$scope.authenticating = 1;
		$scope.showErrorMessage = false;
		$http.post('/ahs/auth',{ login:$scope.login, password: $scope.password })
			.success(function(data, status, headers, config){
				location.href = data.location;
				$scope.authenticating = false;
			})
			.error(function(data, status, headers, config){
				$scope.authenticating = false;
				$scope.showErrorMessage = true;
				$scope.errorMessage = 'Server errrrr';
				return false;
			})
			return false;
	};
	$scope.logout = function(){
		$http.delete('/ahs/auth',{})
			.success(function(data, status, headers, config){
				EventBus.prepForBroadcast('userDataLoaded','user',{loginStatus:0});
				location.reload();
			})
			.error(function(data, status, headers, config){
				console.log(data);
				$scope.errorMessage = 'Server errrrr';
				return false;
			})
			return false;
	};
});
