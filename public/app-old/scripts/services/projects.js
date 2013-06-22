'use strict';
var app = window.app;
app.services
	.factory('Project', function($resource){
		return $resource('/ahs/projects?id=:project_id', {}, {
			query: {method:'GET', isArray:true}
		}
	);
});
//app.services
//	.factory('Project', function($scope,$el,$attrs,$http){
//	var get = function(){
//		// clear error from scope
//		delete $scope.error;
//		// try to get data defined in directive
//		
//		$http({
//			method: 'GET',
//			url: 'data/projects'
//		}).
//		success(function(data, status, headers, config) {
//			$scope.meta = data;
//			if ($scope.models) {
//				parseArgs();
//					
//				// share data with any subscribers
//				SharedService.prepForBroadcast($scope.models,$scope.meta);
//			}
//			else {
//				$http({
//					method: 'GET',
//					url: $attrs.data
//				}).
//				success(function(data, status, headers, config) {
//					
//					$scope.models = data.models;
//					parseArgs();
//					
//					// share data with any subscribers
//					SharedService.prepForBroadcast(data.models,$scope.meta);
//				}).
//				error(function($scope,data, status, headers, config){error($scope,data, status, headers, config)})	
//			}
//		}).
//		error(function($scope,data, status, headers, config){error($scope,data, status, headers, config)})
//	};
//
//	return {
//		get : get
//	}
//});