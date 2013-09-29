	(function(){
'use strict';
var app = window.app;
app.controllers
    .controller('ProjectCtrl', function ($scope,$http,$routeParams,$rootScope,$filter,Project,Mode,EventBus,ProjectInfo,ProjectGoals,ProjectGeo,ProjectPhoto) {
        var map = {
            'ProjectInfo' : ProjectInfo,
            'ProjectGoals' : ProjectGoals,
            'ProjectGeo' : ProjectGeo
        };
        function init (args) {
            $scope.project = Project.query(
                {project_id: $routeParams.project_id},
                function(data) {
                    $scope.project   = data[0];
                    EventBus.prepForBroadcast('geoModelLoaded','model',$scope.project);
                }
            );
        }
        
        function save(action,data) {
			$scope.project.from = $filter('date')($scope.project.from,'yyyy-MM-dd');
			$scope.project.to = $filter('date')($scope.project.to,'yyyy-MM-dd');
			
            map[action].save($scope.project,function(data){
                data = data[0];
                if (!(data.goals && data.goals.length>0)) {
                    data.goals = [];
                }
                if (!(data.geo && data.geo.length>0)) {
                    data.geo = [];
                }
                $scope.project = data;
            });
        }
        function setMode(mode) {
            $scope.mode = mode;
            $scope.canProjectSaved = false;
        }
        $scope.dateOptions = { format: 'yyyy-mm-dd' };
		
		$scope.$on('uploadComplete', function(evt, data) {
			$scope.project.photo = data;
		});
		
        $scope.$on('userDataLoaded',function(scope,data){
            $rootScope.loginStatus = data.loginStatus;
        });
        
        $scope.save = save;
        $scope.setMode = setMode;
        
        setMode($routeParams.mode);
        if (!$scope.project) {
            init();
        }
    }
);
})();