	(function(){
'use strict';
var app = window.app;
app.controllers
    .controller('PulseCtrl', function ($scope,$http,$routeParams,$rootScope,$filter,Project,Mode,EventBus,ProjectInfo,ProjectPulse) {
        $scope.mode 	= 'pulse';
		$scope.pulse 	= [];
		
		function save() {
			ProjectPulse.save(
                {project_id: $routeParams.project_id, description : $scope.description},
                function(data) {
                    $scope.pulse.push(data[0]);
                }
            );
        }
		
        function init (args) {
            $scope.project = Project.query(
                {project_id: $routeParams.project_id},
                function(data) {
                    $scope.project   = data[0];
                }
            );
			
        }
        
        $scope.$on('userDataLoaded',function(scope,data){
            $rootScope.loginStatus = data.loginStatus;
        });
        
        //setMode($routeParams.mode);
        if (!$scope.project) {
            init();
        }
		$scope.pulse = ProjectPulse.query(
			{project_id: $routeParams.project_id},
			function(data) {
				$scope.pulse   = data;
			}
		);
		$scope.save = save;
    }
);
})();