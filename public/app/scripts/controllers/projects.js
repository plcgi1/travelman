(function(){
'use strict';
var app = window.app;
angular.module('AhsApp')
    .controller('ProjectsCtrl', function ($scope,$routeParams,Project) {
		$scope.projects = Project.query(
			{project_id: $routeParams.project_id},
			function(data) {
				$scope.projects   = data;
			}
		);
    }
);
})();