(function(){
'use strict';
var app = window.app;
app.controller('AuthCtrl', function ($scope,$http,$routeParams,$rootScope,EventBus,Auth) {
	
	$scope.logme = function(){
		$scope.authenticating = 1;
		$scope.showErrorMessage = false;
		function success(data){
			//location.href = data.location;
			$scope.authenticating = false;
		}
		function error(){
				$scope.authenticating = false;
				$scope.showErrorMessage = true;
				$scope.errorMessage = 'Server errrrr';
				return false;
			}
		$http.post('/ahs/auth',{ login:$scope.login, password: $scope.password })
			.success(success)
			.error(error);
			return false;
	};
	$scope.logout = function(){
		Auth.logout(
			{},
			function(){
				EventBus.prepForBroadcast('userDataLoaded','user',{loginStatus:0});
				location.reload();
			},
			function () {
				$scope.errorMessage = 'Server errrrr';
				return false;
			}
		);
	};
	
});
})();